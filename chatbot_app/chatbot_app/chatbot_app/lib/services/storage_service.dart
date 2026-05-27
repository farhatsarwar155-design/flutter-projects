import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';

class StorageService {
  static const String _storageKey = 'chat_messages';

  Future<void> saveMessages(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = messages.map((m) => m.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(messagesJson));
  }


  Future<List<Message>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesString = prefs.getString(_storageKey);

    if (messagesString == null) return [];

    final List<dynamic> messagesJson = jsonDecode(messagesString);
    return messagesJson.map((json) => Message.fromJson(json)).toList();
  }

  Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}