import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hablar/src/services/message_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final String sessionId;
  final String name;
  final List<dynamic> messages;

  const ChatScreen(
      {super.key,
      required this.sessionId,
      required this.name,
      required this.messages});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<dynamic> _messages;
  final TextEditingController _controller = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final _messageService = MessageService();

  bool isTyping = false;

  Timer? _typingTimer;
  String _typingText = "...";
  int _typingIndex = 1;

  @override
  void initState() {
    super.initState();
    _messages = List<dynamic>.from(widget.messages);
    _messageService.fetchMessages(widget.sessionId);
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  Future<void> _sendMessage(String content) async {
    final trimmedContent = content.trim();
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Token não encontrado. Faça login novamente.')),
      );
      return;
    }

    if (trimmedContent.isEmpty) return;

    final userMessage = {
      "author": "user",
      "content": trimmedContent,
      "timestamp": DateTime.now().toIso8601String()
    };
    setState(() {
      _messages.add(userMessage);
      _controller.clear();
    });

    _startTypingAnimation();

    final url = Uri.parse('http://{ip}:3000/api/chat/send-message');

    final body = {
      "sessionId": widget.sessionId,
      "message": trimmedContent,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        final newMessage = {
          "author": "bot",
          "content": decoded['response'],
          "timestamp": DateTime.now().toIso8601String()
        };

        setState(() {
          _messages.add(newMessage);
          isTyping = false;
        });
        _stopTypingAnimation();
      } else {
        setState(() {
          isTyping = false;
        });
        _stopTypingAnimation();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Falha ao obter resposta da AI: ${response.body}')),
        );
      }
    } catch (e) {
      setState(() {
        isTyping = false;
      });
      _stopTypingAnimation();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Erro ao enviar mensagem. Verifique a conexão.')),
      );
    }
  }

  void _startTypingAnimation() {
    setState(() {
      isTyping = true;
      _typingIndex = 1;
      _typingText = ".";
    });
    _typingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _typingIndex++;
        if (_typingIndex > 3) {
          _typingIndex = 1;
        }
        _typingText = "." * _typingIndex;
      });
    });
  }

  void _stopTypingAnimation() {
    _typingTimer?.cancel();
    setState(() {
      _typingText = "...";
    });
  }

  Widget _buildMessageItem(dynamic message) {
    final isUser = message['author'] == 'user';
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bgColor = isUser ? Colors.blue[300]! : Colors.grey[300]!;
    const textColor = Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      alignment: align,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['content'] ?? '',
          style: const TextStyle(color: textColor),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      alignment: Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("", style: TextStyle(color: Colors.black)),
            const SizedBox(width: 8),
            Text(_typingText, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat - Sessão: ${widget.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: _messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                } else {
                  final message = _messages[index];
                  return _buildMessageItem(message);
                }
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        _sendMessage(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _sendMessage(_controller.text);
                    },
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
