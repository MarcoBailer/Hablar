import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  bool isTyping =
      false; // Indica se a "ai" está "digitando" (esperando resposta)

  // Controlador para a animação simples de "digitando..."
  Timer? _typingTimer;
  String _typingText = "..."; // Texto base da animação
  int _typingIndex = 1; // Para animar a quantidade de pontos

  @override
  void initState() {
    super.initState();
    _messages = List<dynamic>.from(widget.messages);
    // Opcional: se quiser iniciar alguma animação de digitação em outro momento
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

    // Adicionar imediatamente a mensagem do usuário na tela
    final userMessage = {
      "author": "user",
      "content": trimmedContent,
      "timestamp": DateTime.now().toIso8601String()
    };
    setState(() {
      _messages.add(userMessage);
      _controller.clear();
    });

    // Agora ativamos o indicador de digitação
    _startTypingAnimation();

    // Enviar a requisição para o endpoint de resposta (exemplo)
    final url = Uri.parse('http://192.168.0.20:3000/api/chat/send-message');

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
        // Supondo que a resposta da AI venha diretamente neste endpoint
        // Exemplo de resposta: {"author": "ai", "content": "Resposta da ai..."}
        final newMessage = json.decode(response.body);

        // Adicionar a mensagem da AI
        setState(() {
          _messages.add(newMessage);
          isTyping = false;
        });
        _stopTypingAnimation();
      } else {
        // Falha no envio ou na obtenção da resposta
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
          // Lista de mensagens
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: _messages.length + (isTyping ? 1 : 0),
              // Se isTyping for true, adicionamos um item a mais para o indicador de digitação
              itemBuilder: (context, index) {
                if (isTyping && index == _messages.length) {
                  // Último item é o indicador de digitação
                  return _buildTypingIndicator();
                } else {
                  final message = _messages[index];
                  return _buildMessageItem(message);
                }
              },
            ),
          ),
          // Campo de input
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
