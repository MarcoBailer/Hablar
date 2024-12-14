import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hablar/src/pages/chat/chat_screen.dart';
import 'package:hablar/src/services/message_service.dart';
import 'package:http/http.dart';

class StoriesTab extends StatefulWidget {
  const StoriesTab({Key? key}) : super(key: key);

  @override
  _StoriesTabState createState() => _StoriesTabState();
}

class _StoriesTabState extends State<StoriesTab> {
  late Future<List<dynamic>> _futureSessions;
  final TextEditingController _name = TextEditingController();
  final MessageService _messageService = MessageService();

  @override
  void initState() {
    super.initState();
    _futureSessions = _messageService.fetchSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<dynamic>>(
        future: _futureSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma sessão encontrada',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final names = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      final name = names[index];
                      final sessionName = name['name'] ?? '';
                      final messages = name['messages'] ?? [];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  sessionId: name['sessionId'],
                                  name: sessionName,
                                  messages: messages,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            sessionName,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Iniciar nova sessão'),
                  content: TextField(
                    controller: _name,
                    decoration: const InputDecoration(
                      hintText: 'Nome da sessão',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Fechar o diálogo primeiro
                        _handleStartSession(); // Iniciar sessão em seguida
                      },
                      child: const Text('Iniciar'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
            backgroundColor: const Color.fromARGB(255, 240, 126, 27),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  Future<void> _handleStartSession() async {
    final result = await _messageService.startSession(_name.text);

    if (result.success) {
      _name.clear();

      if (result.response is Response) {
        final responseBody = (result.response as Response).body;
        final data = jsonDecode(responseBody);
        final name = data['session']['name'];
        final sessionId = data['session']['sessionId'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              name: name,
              sessionId: sessionId,
              messages: const [],
            ),
          ),
        );
      } else {
        // Trate o caso onde response não é do tipo esperado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resposta inesperada do servidor')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }
}
