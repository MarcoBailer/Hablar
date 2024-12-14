import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hablar/src/provider/message_result_model.dart';
import 'package:http/http.dart' as http;

class MessageService {
  final _storage = const FlutterSecureStorage();

  Future<List<dynamic>> fetchSessions() async {
    // Recuperar o token armazenado
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    final url = Uri.parse('http://{ip}:3000/api/chat/get-user-sessions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Falha ao carregar sessões: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchMessages(String sessionId) async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    final url = Uri.parse('http://{ip}:3000/api/chat/get-user-message-session');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({'sessionId': sessionId});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Falha ao carregar mensagens: ${response.statusCode}');
    }
  }

  Future<MessageResultModel> startSession(String name) async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      return MessageResultModel(
        success: false,
        message: 'Token não encontrado. Faça login novamente.',
      );
    }

    final url = Uri.parse('http://{ip}:3000/api/chat/start-session');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({'name': name}),
    );
    if (response.statusCode == 200) {
      return MessageResultModel(
        success: true,
        message: 'Sessão iniciada com sucesso.',
        response: response,
      );
    } else {
      return MessageResultModel(
        success: false,
        message: 'Erro ao iniciar sessão: ${response.statusCode}',
        response: response,
      );
    }
  }
}
