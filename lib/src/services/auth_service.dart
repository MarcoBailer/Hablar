import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hablar/src/provider/auth_result_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/io_client.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  IOClient createHttpClient() {
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    return IOClient(httpClient);
  }

  Future<AuthResultModel> login(String email, String password) async {
    final client = createHttpClient();

    final url = Uri.parse('https://192.168.0.26:7235/api/Auth/Login');
    final headers = {'Content-Type': 'application/json-patch+json'};
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await client.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['isSuccess'] == true) {
          final token = data['message'];

          try {
            // Decodificar o token JWT
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

            // Verificar se a claim existe
            if (decodedToken.containsKey(
                'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier')) {
              String userId = decodedToken[
                  'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

              // Armazenar o token e o userId de forma segura
              await _storage.write(key: 'auth_token', value: token);
              await _storage.write(key: 'user_id', value: userId);

              return AuthResultModel(
                  success: true, message: 'Login efetuado com sucesso.');
            } else {
              return AuthResultModel(
                  success: false, message: 'Claim não encontrada no token.');
            }
          } catch (e) {
            return AuthResultModel(
                success: false, message: 'Erro ao decodificar o token.');
          }
        } else {
          // Login falhou
          return AuthResultModel(success: false, message: data['message']);
        }
      } else {
        // Erro no servidor
        return AuthResultModel(
            success: false,
            message: 'Erro no servidor: ${response.statusCode}');
      }
    } catch (e) {
      return AuthResultModel(success: false, message: 'Erro na requisição.');
    }
  }

  Future<AuthResultModel> register({
    required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String password,
  }) async {
    final client = createHttpClient();

    final url = Uri.parse('https://192.168.0.26:7235/api/Auth/Register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'password': password,
    });

    try {
      final response = await client.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['isSuccess'] == true) {
          final token = data['message'];

          try {
            // Decodificar o token JWT
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

            // Verificar se a claim existe
            if (decodedToken.containsKey(
                'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier')) {
              String userId = decodedToken[
                  'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

              // Armazenar o token e o userId de forma segura
              await _storage.write(key: 'auth_token', value: token);
              await _storage.write(key: 'user_id', value: userId);

              return AuthResultModel(
                  success: true, message: 'Registro efetuado com sucesso.');
            } else {
              return AuthResultModel(
                  success: false, message: 'Claim não encontrada no token.');
            }
          } catch (e) {
            return AuthResultModel(
                success: false, message: 'Erro ao decodificar o token.');
          }
        } else {
          // Registro falhou
          return AuthResultModel(success: false, message: data['message']);
        }
      } else {
        // Erro no servidor
        return AuthResultModel(success: false, message: 'Erro no servidor.');
      }
    } catch (e) {
      // Erro na requisição
      return AuthResultModel(success: false, message: 'Erro na requisição.');
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  // Outros métodos relacionados à autenticação
}
