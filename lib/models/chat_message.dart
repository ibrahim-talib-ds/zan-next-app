// ZanNext — ChatMessage model

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String? senderName;
  final String text;
  final String? imageUrl;
  final DateTime? createdAt;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.senderName,
    required this.text,
    this.imageUrl,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        chatId: json['chat_id'] as String,
        senderId: json['sender_id'] as String,
        senderName: json['sender_name'] as String?,
        text: json['text'] as String,
        imageUrl: json['image_url'] as String?,
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'chat_id': chatId,
        'sender_id': senderId,
        'sender_name': senderName,
        'text': text,
        'image_url': imageUrl,
        'created_at': createdAt?.toIso8601String(),
      };
}
