import 'package:flutter/material.dart';
import 'package:hablar/src/Widgets/custom_text_form_field.dart';
import 'package:hablar/src/Widgets/error_dialog.dart';
import 'package:hablar/src/auth/genre_section_screen.dart';
import 'package:provider/provider.dart';

import '../Widgets/custom_elevated_button.dart';
import '../provider/user_model.dart';

class SignupNameScreen extends StatefulWidget {
  const SignupNameScreen({super.key});

  @override
  _SignupNameScreenState createState() => _SignupNameScreenState();
}

class _SignupNameScreenState extends State<SignupNameScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _acceptedTerms = false;

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
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título "Crie uma conta"
              const Center(
                child: Text(
                  'Crie uma conta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Pergunta "Qual o seu nome?"
              const Text(
                'Qual o seu nome?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              // Campo de input para o nome
              CustomTextFormFied(
                controller: _nameController,
                hintText: 'Digite seu primeiro nome',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  if (value.length < 3) {
                    return 'O nome deve ter ao menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              const Text(
                'Qual o seu segundo nome?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              CustomTextFormFied(
                controller: _secondNameController,
                hintText: 'Digite seu segundo nome',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu segundo nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              const Text(
                'Qual será seu nome de usuário?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              CustomTextFormFied(
                controller: _usernameController,
                hintText: 'Digite seu nome de usuário',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              // Quebra de linha (traço branco)
              const Divider(
                color: Colors.white,
                thickness: 1,
              ),
              const SizedBox(height: 20),
              // (1) Letras miúdas
              const Text(
                'Ao clicar em Criar uma conta, você aceita aos termos de uso do Hablar',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              // (2) Título miúdo "Termos de uso" em verde
              GestureDetector(
                onTap: () {
                  // Ação ao clicar em "Termos de uso"
                },
                child: const Text(
                  'Termos de uso',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // (3) Texto miúdo
              const Text(
                'Para saber mais sobre a forma como o Hablar recolhe, utiliza, partilha e protege os seus dados pessoais, consulte a Política de Privacidade do Hablar.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              // (4) Título miúdo "Políticas de privacidade" em verde
              GestureDetector(
                onTap: () {
                  // Ação ao clicar em "Políticas de privacidade"
                },
                child: const Text(
                  'Políticas de privacidade',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // (5) Checkbox 1
              CheckboxListTile(
                activeColor: Colors.green,
                checkColor: Colors.white,
                value: _checkbox1,
                onChanged: (bool? value) {
                  setState(() {
                    _checkbox1 = value ?? false;
                  });
                },
                title: const Text(
                  'Enviar-me notícias e ofertas do Hablar.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              // (6) Checkbox 2
              CheckboxListTile(
                activeColor: Colors.green,
                checkColor: Colors.white,
                value: _checkbox2,
                onChanged: (bool? value) {
                  setState(() {
                    _checkbox2 = value ?? false;
                  });
                },
                title: const Text(
                  'Partilhar os meus dados de registo com os fornecedores de conteúdos do Hablar para fins de marketing.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              CheckboxListTile(
                activeColor: Colors.green,
                checkColor: Colors.white,
                value: _acceptedTerms,
                onChanged: (bool? value) {
                  setState(() {
                    _acceptedTerms = value ?? false;
                  });
                },
                title: const Text(
                  'Eu aceito os termos de uso do Hablar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 20),
              // (7) Botão "Criar uma conta"
              CustomElevatedButton(
                onPressed: _acceptedTerms
                    ? () {
                        if (_formkey.currentState!.validate()) {
                          // Salva o nome do usuário usando o Provider
                          Provider.of<UserModel>(context, listen: false)
                              .setName(_nameController.text);

                          // Navega para a próxima tela
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const GenreSelectionScreen(),
                            ),
                          );
                        } else {
                          showErrorDialog(
                              context, 'Preencha todos os campos corretamente');
                        }
                      }
                    : null,
                text: 'Criar uma conta',
                enabled: _acceptedTerms,
              ),

              const SizedBox(height: 20), // Espaço no final
            ],
          ),
        ),
      ),
    );
  }
}
