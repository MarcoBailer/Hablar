import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hablar/src/Widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../../Widgets/custom_elevated_button.dart';
import '../home/home_page.dart';
import '../../widgets/error_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variável para controlar a visibilidade da senha
  bool _obscureText = true;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 16, 16),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey, // Chave para o formulário
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título "Entrar"
              const Text(
                'Entrar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Campo de email
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFormFied(
                controller: _emailController,
                hintText: 'Digite seu primeiro nome',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  // Validação básica de email
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Campo de senha
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Senha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintText: 'Digite sua senha',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              // Botão "Entrar"
              CustomElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                text: 'Entrar',
                isLoading: _isLoading,
              ),

              const SizedBox(height: 20),
              // Link "Esqueci minha senha"
              GestureDetector(
                onTap: () {
                  // Navegar para a tela de recuperação de senha
                },
                child: const Text(
                  'Esqueci minha senha',
                  style: TextStyle(
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final success = await login(email, password);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Navega para a tela principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Exibe mensagem de erro
        showErrorDialog(context, 'Email ou senha inválidos.');
      }
    }
  }

  IOClient createHttpClient() {
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    return IOClient(httpClient);
  }

  Future<bool> login(String email, String password) async {
    final client = createHttpClient();

    final url = Uri.parse('https://{ip-da-maquina}:7235/api/Auth/Login');
    final headers = {'Content-Type': 'application/json-patch+json'};
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await client.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['isSuccess'] == true) {
          final token = data['message'];

          // Armazene o token de forma segura
          final storage = FlutterSecureStorage();
          await storage.write(key: 'auth_token', value: token);

          return true;
        } else {
          // Login falhou
          return false;
        }
      } else {
        // Erro no servidor
        return false;
      }
    } catch (e) {
      // Erro na requisição
      print('Erro na requisição: $e');
      return false;
    }
  }
}
