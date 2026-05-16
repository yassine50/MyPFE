class Message {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });

  factory Message.fromMap(Map<dynamic, dynamic> map, String id) {
    return Message(
      id: id,
      senderId: map['senderId']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
          : DateTime.now(),
      isRead: map['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isRead': isRead,
    };
  }
}
