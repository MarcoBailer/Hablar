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

    final url = Uri.parse('http://192.168.1.6:3000/api/chat/get-user-sessions');
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

    final url =
        Uri.parse('http://192.168.1.6:3000/api/chat/get-user-message-session');
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

    final url = Uri.parse('http://192.168.1.6:3000/api/chat/start-session');
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

  Future<MessageResultModel> sendMessage(
      String sessionId, String content) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      return MessageResultModel(
          success: false,
          message: 'Token não encontrado. Faça login novamente.');
    }

    final url = Uri.parse('http://192.168.1.6:3000/api/chat/send-message');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = {
      "sessionId": sessionId,
      "message": content.trim(),
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      // 'response' é o campo retornado pela API com a resposta da IA.
      final botResponse = decoded['response'];
      return MessageResultModel(
        success: true,
        message: 'Mensagem enviada com sucesso.',
        data: {
          "author": "ai",
          "content": botResponse,
          "timestamp": DateTime.now().toIso8601String()
        },
      );
    } else {
      return MessageResultModel(
        success: false,
        message: 'Falha ao obter resposta da AI: ${response.body}',
      );
    }
  }
}
