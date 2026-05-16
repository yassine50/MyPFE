import 'package:firebase_database/firebase_database.dart';
import 'package:pfe/core/models/conversation_model.dart';
import 'package:pfe/core/models/message_model.dart';

class ChatRepository {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  /// Creates a new chat or returns an existing one between guest and host for a property.
  Future<String> createOrGetChat(String propertyId, String hostId, String guestId) async {
    final chatsRef = _db.ref('chats');
    
    // Attempt to find existing chat
    final snapshot = await chatsRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      for (var entry in data.entries) {
        final chatData = entry.value as Map<dynamic, dynamic>;
        if (chatData['propertyId'] == propertyId &&
            chatData['hostId'] == hostId &&
            chatData['guestId'] == guestId) {
          return entry.key.toString(); // Found existing chat ID
        }
      }
    }

    // Create new chat
    final newChatRef = chatsRef.push();
    final newChat = Conversation(
      id: newChatRef.key!,
      propertyId: propertyId,
      hostId: hostId,
      guestId: guestId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastMessage: '',
      isClosed: false,
    );

    await newChatRef.set(newChat.toMap());
    return newChatRef.key!;
  }

  /// Sends a message in a specific chat
  Future<void> sendMessage(String chatId, String senderId, String content, {bool force = false}) async {
    // Prevent recreating the chat if it was deleted
    final chatSnapshot = await _db.ref('chats/$chatId').get();
    if (!chatSnapshot.exists) return;
    
    if (!force) {
      final chatData = chatSnapshot.value as Map<dynamic, dynamic>;
      if (chatData['isClosed'] == true) return;
    }

    final messageRef = _db.ref('chats/$chatId/messages').push();
    final message = Message(
      id: messageRef.key!,
      senderId: senderId,
      content: content,
      timestamp: DateTime.now(),
      isRead: false,
    );

    await messageRef.set(message.toMap());

    // Update the lastMessage and updatedAt on the conversation
    await _db.ref('chats/$chatId').update({
      'lastMessage': content,
      'updatedAt': ServerValue.timestamp,
    });
  }

  /// Opens a chat so messages can be sent
  Future<void> openChat(String chatId) async {
    await _db.ref('chats/$chatId').update({
      'isClosed': false,
      'updatedAt': ServerValue.timestamp,
    });
  }

  /// Closes a chat so no more messages can be sent
  Future<void> closeChat(String chatId) async {
    await _db.ref('chats/$chatId').update({
      'isClosed': true,
      'updatedAt': ServerValue.timestamp,
    });
  }

  /// Stream of conversations for a specific user (either as guest or host)
  Stream<List<Conversation>> getUserChats(String userId) {
    return _db.ref('chats').onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return [];
      }
      
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<Conversation> chats = [];

      data.forEach((key, value) {
        final chatData = value as Map<dynamic, dynamic>;
        if (chatData['guestId'] == userId || chatData['hostId'] == userId) {
          chats.add(Conversation.fromMap(chatData, key.toString()));
        }
      });

      // Sort by newest updated
      chats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return chats;
    });
  }

  /// Stream of conversations where the user is the guest (renter)
  Stream<List<Conversation>> getGuestChats(String guestId) {
    return _db.ref('chats').orderByChild('guestId').equalTo(guestId).onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return [];
      }
      
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<Conversation> chats = [];

      data.forEach((key, value) {
        final chatData = value as Map<dynamic, dynamic>;
        chats.add(Conversation.fromMap(chatData, key.toString()));
      });

      chats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return chats;
    });
  }

  /// Stream of conversations where the user is the host
  Stream<List<Conversation>> getHostChats(String hostId) {
    return _db.ref('chats').orderByChild('hostId').equalTo(hostId).onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return [];
      }
      
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<Conversation> chats = [];

      data.forEach((key, value) {
        final chatData = value as Map<dynamic, dynamic>;
        chats.add(Conversation.fromMap(chatData, key.toString()));
      });

      chats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return chats;
    });
  }

  /// Stream of messages for a specific chat
  Stream<List<Message>> getChatMessages(String chatId) {
    return _db.ref('chats/$chatId/messages').orderByChild('timestamp').onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return [];
      }
      
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<Message> messages = [];

      data.forEach((key, value) {
        final messageData = value as Map<dynamic, dynamic>;
        messages.add(Message.fromMap(messageData, key.toString()));
      });

      // Sort by timestamp
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  }

  /// Mark all unread messages as read for a user
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    final messagesRef = _db.ref('chats/$chatId/messages');
    final snapshot = await messagesRef.get();
    
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final Map<String, dynamic> updates = {};
      
      data.forEach((key, value) {
        final messageData = value as Map<dynamic, dynamic>;
        if (messageData['senderId'] != userId && messageData['isRead'] == false) {
          updates['$key/isRead'] = true;
        }
      });
      
      if (updates.isNotEmpty) {
        await messagesRef.update(updates);
      }
    }
  }
}
