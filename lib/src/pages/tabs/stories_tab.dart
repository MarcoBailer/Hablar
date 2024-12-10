import 'package:flutter/material.dart';
import 'package:hablar/src/pages/chat/chat_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoriesTab extends StatefulWidget {
  const StoriesTab({Key? key}) : super(key: key);

  @override
  _StoriesTabState createState() => _StoriesTabState();
}

class _StoriesTabState extends State<StoriesTab> {
  late Future<List<dynamic>> _futureSessions;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _futureSessions = _fetchSessions();
  }

  Future<List<dynamic>> _fetchSessions() async {
    // Recuperar o token armazenado
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    final url =
        Uri.parse('http://192.168.0.26:3000/api/chat/get-user-sessions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Incluindo o Bearer Token
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Falha ao carregar sessões: ${response.statusCode}');
    }
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
            final sessions = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final sessionId = session['sessionId'];
                      final messages = session['messages'] ?? [];

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
                                  sessionId: sessionId,
                                  messages: messages,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Título', // Futuramente substituído pelo nome do usuário
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Ação do botão de adicionar algo futuramente
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: const Color.fromARGB(255, 240, 126, 27),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 40),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
