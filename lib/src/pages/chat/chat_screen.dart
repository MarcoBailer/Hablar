import 'package:flutter/material.dart';
import 'package:hablar/src/services/message_service.dart';
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
  List<dynamic> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final _messageService = MessageService();

  bool isTyping = false;

  Timer? _typingTimer;
  String _typingText = "...";
  int _typingIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
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
                        _handleMessageService(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _handleMessageService(_controller.text);
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

  Future<void> _loadMessages() async {
    try {
      final messages = await _messageService.fetchMessages(widget.sessionId);
      setState(() {
        _messages = List<dynamic>.from(messages);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar mensagens.')),
      );
    }
  }

  Future<void> _handleMessageService(String content) async {
    final trimmedContent = content.trim();
    if (trimmedContent.isEmpty) return;

    // Primeiro, adicionar a mensagem do usuário localmente
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

    // Agora chamar o serviço
    final result =
        await _messageService.sendMessage(widget.sessionId, trimmedContent);

    // Parar animação independente do resultado
    _stopTypingAnimation();
    setState(() {
      isTyping = false;
    });

    if (result.success) {
      // Adicionar a mensagem do bot retornada no result.data
      final newMessage = result.data;
      // Esperamos que result.data seja um mapa com o author, content, timestamp
      if (newMessage != null) {
        setState(() {
          _messages.add(newMessage);
        });
      }
    } else {
      // Exibir erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }
}
