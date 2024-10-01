import 'package:flutter/material.dart';
import 'package:hablar/src/auth/login_page.dart';
import 'package:hablar/src/auth/signup_email_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Imagem de background que ocupa metade da tela
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.5,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/IMG_2756 1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              // color: const Color.fromARGB(255, 19, 16, 16),
            ),
          ),
          // Fundo preto na metade inferior da tela
          Positioned(
            top: screenHeight * 0.5,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color.fromARGB(255, 19, 16, 16),
            ),
          ),
          // Conteúdo da tela
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone genérico (Flutter)
                  const FlutterLogo(size: 80),
                  const SizedBox(height: 20),
                  // Título com quebra de linha
                  const Text(
                    'Milhões de histórias\nGratuitos no Hablar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Botão "Iniciar de forma gratuita" com gradiente
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.red, Colors.orange],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupEmailScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Iniciar de forma gratuita',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Continuar com Google',
                          style: TextStyle(fontSize: 18),
                        ),
                      )),
                  const SizedBox(height: 15),
                  // Botão "Continuar com Facebook"
                  SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Continuar com Facebook',
                          style: TextStyle(fontSize: 18),
                        ),
                      )),
                  const SizedBox(height: 15),
                  // Link "Logar"
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Logar',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
