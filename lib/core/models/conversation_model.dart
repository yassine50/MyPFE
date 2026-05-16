import 'message_model.dart';

class Conversation {
  final String id;
  final String propertyId;
  final String hostId;
  final String guestId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String lastMessage;
  final bool isClosed;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.propertyId,
    required this.hostId,
    required this.guestId,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage = '',
    this.isClosed = false,
    this.messages = const [],
  });

  factory Conversation.fromMap(Map<dynamic, dynamic> map, String id) {
    return Conversation(
      id: id,
      propertyId: map['propertyId']?.toString() ?? '',
      hostId: map['hostId']?.toString() ?? '',
      guestId: map['guestId']?.toString() ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : DateTime.now(),
      lastMessage: map['lastMessage']?.toString() ?? '',
      isClosed: map['isClosed'] as bool? ?? false,
      // Note: we usually fetch messages separately from a sub-node, but if they are nested:
      messages: map['messages'] != null
          ? (map['messages'] as Map<dynamic, dynamic>)
              .entries
              .map((e) => Message.fromMap(e.value as Map<dynamic, dynamic>, e.key.toString()))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'propertyId': propertyId,
      'hostId': hostId,
      'guestId': guestId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
      'isClosed': isClosed,
    };
  }
}
