import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() {
  runApp(const FarhatChatApp());
}

class FarhatChatApp extends StatelessWidget {
  const FarhatChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F1B),
        primaryColor: const Color(0xFF6C63FF),
      ),
      home: const FrontScreen(),
    );
  }
}

// ✅ FRONT SCREEN / WELCOME SCREEN
class FrontScreen extends StatefulWidget {
  const FrontScreen({super.key});

  @override
  State<FrontScreen> createState() => FrontScreenState();
}

class FrontScreenState extends State<FrontScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F1B),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Animated Logo
                  Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Title
                  Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        "Farhat AI",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Subtitle
                  Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        "Your Intelligent Assistant",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Start Button
                  Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatListScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Get Started",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ✅ CHAT LIST SCREEN (All Chats)
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  List<Map<String, dynamic>> chats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  Future<void> loadChats() async {
    final prefs = await SharedPreferences.getInstance();
    final String? chatsJson = prefs.getString('chats');

    if (chatsJson != null) {
      final List<dynamic> decoded = jsonDecode(chatsJson);
      setState(() {
        chats = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveChats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chats', jsonEncode(chats));
  }

  void createNewChat() {
    final newChat = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': 'New Chat ${chats.length + 1}',
      'timestamp': DateTime.now().toIso8601String(),
      'messages': <Map<String, dynamic>>[],
    };

    setState(() {
      chats.insert(0, newChat);
    });
    saveChats();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: newChat['id'] as String,
          chatTitle: newChat['title'] as String,
          onChatUpdate: updateChat,
        ),
      ),
    );
  }

  void updateChat(String id, String title, List<Map<String, dynamic>> messages) {
    final index = chats.indexWhere((c) => c['id'] == id);
    if (index != -1) {
      setState(() {
        chats[index]['title'] = title;
        chats[index]['messages'] = messages;
        chats[index]['timestamp'] = DateTime.now().toIso8601String();
        // Move to top
        final chat = chats.removeAt(index);
        chats.insert(0, chat);
      });
      saveChats();
    }
  }

  void deleteChat(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text("Delete Chat?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "This will permanently delete this conversation.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                chats.removeWhere((c) => c['id'] == id);
              });
              saveChats();
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void deleteAllChats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text("Delete All Chats?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "This will permanently delete all conversations.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                chats.clear();
              });
              saveChats();
              Navigator.pop(context);
            },
            child: const Text("Delete All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String formatTime(String timestamp) {
    final date = DateTime.parse(timestamp);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else if (diff.inDays == 1) {
      return "Yesterday";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  String getLastMessagePreview(Map<String, dynamic> chat) {
    final messages = chat['messages'] as List<dynamic>?;
    if (messages == null || messages.isEmpty) {
      return 'Start a conversation';
    }
    final lastMsg = messages.last as Map<String, dynamic>;
    final content = lastMsg['content'] as String?;
    return content ?? 'No message';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F1B),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F1B).withValues(alpha: 0.8),
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Farhat AI",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (chats.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.delete_sweep, color: Colors.white70),
                        onPressed: deleteAllChats,
                        tooltip: "Delete all chats",
                      ),
                  ],
                ),
              ),

              // Chat List
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
                    : chats.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final chatId = chat['id'] as String? ?? '';
                    final chatTitle = chat['title'] as String? ?? 'Untitled';
                    final timestamp = chat['timestamp'] as String? ?? DateTime.now().toIso8601String();

                    return Dismissible(
                      key: Key(chatId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                      onDismissed: (_) => deleteChat(chatId),
                      child: GestureDetector(
                        onTap: () {
                          final messagesDynamic = chat['messages'] as List<dynamic>? ?? [];
                          final initialMessages = messagesDynamic.map((e) => Map<String, dynamic>.from(e as Map)).toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                chatId: chatId,
                                chatTitle: chatTitle,
                                initialMessages: initialMessages,
                                onChatUpdate: updateChat,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E2E),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.chat_bubble,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chatTitle,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      getLastMessagePreview(chat),
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.5),
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatTime(timestamp),
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.4),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => deleteChat(chatId),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red.withValues(alpha: 0.6),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createNewChat,
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add),
        label: const Text("New Chat"),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: const Color(0xFF6C63FF).withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No conversations yet",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap + to start a new chat",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ CHAT SCREEN (Updated with persistence)
class ChatScreen extends StatefulWidget {
  final String chatId;
  final String chatTitle;
  final List<Map<String, dynamic>> initialMessages;
  final Function(String, String, List<Map<String, dynamic>>) onChatUpdate;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.chatTitle,
    this.initialMessages = const [],
    required this.onChatUpdate,
  });

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;
  bool isTyping = false;
  File? selectedImage;
  String chatTitle = "";

  final String apiKey = "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";

  late AnimationController _typingAnimationController;
  late AnimationController _sendButtonController;

  @override
  void initState() {
    super.initState();
    messages = List<Map<String, dynamic>>.from(widget.initialMessages);
    chatTitle = widget.chatTitle;

    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _sendButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) await Permission.camera.request();

    var storageStatus = await Permission.storage.status;
    if (storageStatus.isDenied) await Permission.storage.request();

    var photosStatus = await Permission.photos.status;
    if (photosStatus.isDenied) await Permission.photos.request();
  }

  @override
  void dispose() {
    _typingAnimationController.dispose();
    _sendButtonController.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      PermissionStatus status;
      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
      } else {
        status = await Permission.photos.request();
        if (status.isDenied) status = await Permission.storage.request();
      }

      if (status.isGranted || status.isLimited) {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          imageQuality: 70,
          maxWidth: 1200,
          maxHeight: 1200,
        );

        if (pickedFile != null) {
          setState(() {
            selectedImage = File(pickedFile.path);
          });
        }
      } else if (status.isPermanentlyDenied) {
        _showPermissionDialog();
      }
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text("Permission Required", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Please enable permissions from app settings.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("Settings", style: TextStyle(color: Color(0xFF6C63FF))),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select Image Source",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt, color: Color(0xFF6C63FF)),
              ),
              title: const Text("Camera", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library, color: Color(0xFF6C63FF)),
              ),
              title: const Text("Gallery", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void removeSelectedImage() {
    setState(() {
      selectedImage = null;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _updateChatTitle(String firstMessage) {
    if (chatTitle.startsWith('New Chat')) {
      String newTitle = firstMessage.length > 30
          ? '${firstMessage.substring(0, 30)}...'
          : firstMessage;
      chatTitle = newTitle;
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty && selectedImage == null) return;

    String displayContent = message.isEmpty ? "📷 Image" : message;

    if (messages.isEmpty && message.isNotEmpty) {
      _updateChatTitle(message);
    }

    setState(() {
      messages.add({
        "role": "user",
        "content": displayContent,
        "image": selectedImage?.path,
        "timestamp": DateTime.now().toIso8601String(),
      });
      isLoading = true;
      isTyping = true;
      selectedImage = null;
    });

    _controller.clear();
    _scrollToBottom();
    widget.onChatUpdate(widget.chatId, chatTitle, messages);

    try {
      List<Map<String, String>> apiMessages = [];
      for (var m in messages) {
        final role = m["role"] as String?;
        final content = m["content"] as String?;
        if (role != null && content != null) {
          if (role == "user" || role == "assistant" || role == "system") {
            apiMessages.add({"role": role, "content": content});
          }
        }
      }

      final response = await http.post(
        Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": apiMessages,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = data["choices"] as List<dynamic>?;

        if (choices != null && choices.isNotEmpty) {
          final firstChoice = choices[0] as Map<String, dynamic>;
          final message = firstChoice["message"] as Map<String, dynamic>?;
          final reply = message?["content"] as String? ?? "No response";

          await Future.delayed(const Duration(milliseconds: 500));

          setState(() {
            isTyping = false;
            messages.add({
              "role": "assistant",
              "content": reply,
              "timestamp": DateTime.now().toIso8601String(),
            });
          });
        }
      } else {
        setState(() {
          isTyping = false;
          messages.add({
            "role": "assistant",
            "content": "Error ${response.statusCode}: ${response.body}",
            "timestamp": DateTime.now().toIso8601String(),
            "isError": true,
          });
        });
      }
    } catch (e) {
      setState(() {
        isTyping = false;
        messages.add({
          "role": "assistant",
          "content": "Exception: $e",
          "timestamp": DateTime.now().toIso8601String(),
          "isError": true,
        });
      });
    }

    setState(() => isLoading = false);
    _scrollToBottom();
    widget.onChatUpdate(widget.chatId, chatTitle, messages);
  }

  void clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text("Clear Chat?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Delete all messages in this conversation?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                messages.clear();
              });
              widget.onChatUpdate(widget.chatId, chatTitle, messages);
              Navigator.pop(context);
            },
            child: const Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(left: 16, bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _typingAnimationController,
            builder: (context, child) {
              final double offset = sin(
                (_typingAnimationController.value * 2 * pi) + (index * 0.8),
              );
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 8,
                height: 8 + (offset * 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, int index) {
    final role = msg["role"] as String?;
    final isUser = role == "user";
    final isError = msg["isError"] as bool? ?? false;
    final imagePath = msg["image"] as String?;
    final content = msg["content"] as String?;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(
                left: isUser ? 64 : 16,
                right: isUser ? 16 : 64,
                bottom: 12,
              ),
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : null,
                      color: isUser
                          ? null
                          : isError
                          ? Colors.red.withValues(alpha: 0.2)
                          : const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isUser ? 20 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isUser
                              ? const Color(0xFF6C63FF).withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (imagePath != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(imagePath),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 200,
                                  height: 100,
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.error, color: Colors.white),
                                );
                              },
                            ),
                          ),
                        if (imagePath != null && content != "📷 Image")
                          const SizedBox(height: 8),
                        if (content != null && content != "📷 Image")
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                              content,
                              style: TextStyle(
                                color: isUser
                                    ? Colors.white
                                    : isError
                                    ? Colors.red[300]
                                    : Colors.white.withValues(alpha: 0.9),
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(msg["timestamp"] as String?),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return "";
    final date = DateTime.tryParse(timestamp);
    if (date == null) return "";
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F1B),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F1B).withValues(alpha: 0.8),
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.green[400],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Online",
                                style: TextStyle(
                                  color: Colors.green[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white70),
                      onPressed: clearChat,
                      tooltip: "Clear chat",
                    ),
                  ],
                ),
              ),

              // Messages
              Expanded(
                child: messages.isEmpty
                    ? _buildEmptyChatState()
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(messages[index], index);
                  },
                ),
              ),

              if (isTyping) _buildTypingIndicator(),

              if (selectedImage != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          selectedImage!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Image selected",
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: removeSelectedImage,
                      ),
                    ],
                  ),
                ),

              // Input
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.image,
                        color: selectedImage != null
                            ? const Color(0xFF6C63FF)
                            : Colors.white.withValues(alpha: 0.6),
                      ),
                      onPressed: showImageSourceDialog,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: selectedImage != null
                              ? "Add a caption..."
                              : "Message Farhat...",
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onSubmitted: (text) => sendMessage(text),
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (_) => _sendButtonController.forward(),
                      onTapUp: (_) {
                        _sendButtonController.reverse();
                        sendMessage(_controller.text);
                      },
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1, end: 0.9).animate(
                          CurvedAnimation(parent: _sendButtonController, curve: Curves.easeInOut),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF4A90E2)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChatState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chat, color: Color(0xFF6C63FF), size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            "Start a conversation",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 16),
          ),
        ],
      ),
    );
  }
}