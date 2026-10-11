// ZanNext — ChatRepository

import '../models/chat.dart';
import '../models/chat_message.dart';
import '../services/api_client.dart';

class ChatRepository {
  /// List chats where the given user is buyer or seller.
  static Future<List<Chat>> listForUser(String userId) async {
    final result = await ApiClient.get('/chats?user_id=$userId') as List;
    return result
        .map((j) => Chat.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Get a single chat.
  static Future<Chat> get(String chatId) async {
    final result = await ApiClient.get('/chats/$chatId');
    return Chat.fromJson(result as Map<String, dynamic>);
  }

  /// List messages in a chat (oldest first).
  static Future<List<ChatMessage>> messages(String chatId) async {
    final result = await ApiClient.get('/chats/$chatId/messages') as List;
    return result
        .map((j) => ChatMessage.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Create a new chat with a seller.
  static Future<Chat> create(Map<String, dynamic> data) async {
    final result = await ApiClient.post('/chats', body: data);
    return Chat.fromJson(result as Map<String, dynamic>);
  }

  /// Send a message.
  static Future<ChatMessage> sendMessage(String chatId, String text, {String? imageUrl}) async {
    final result = await ApiClient.post(
      '/chats/$chatId/messages',
      body: {'text': text, if (imageUrl != null) 'image_url': imageUrl},
    );
    return ChatMessage.fromJson(result as Map<String, dynamic>);
  }

  /// Mark a chat as read by the current user.
  static Future<void> markRead(String chatId) async {
    await ApiClient.post('/chats/$chatId/read');
  }
}
