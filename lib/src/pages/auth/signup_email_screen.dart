import 'package:flutter/material.dart';
import 'package:hablar/src/provider/user_model.dart';
import 'package:hablar/src/Widgets/signup_generic_screen.dart';
import 'package:provider/provider.dart';

import 'signup_password_screen.dart';

class SignupEmailScreen extends StatelessWidget {
  const SignupEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SignupGenericScreen(
      title: 'Crie uma conta',
      question: 'Qual seu email?',
      hintText: 'Digite seu email',
      helperText: 'Esse email deverá ser confirmado',
      inputType: TextInputType.emailAddress,
      isPassword: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira um email';
        }
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(value)) {
          return 'Por favor, insira um email válido';
        }
        return null;
      },
      onNext: (email) {
        // Validação do email (se não estiver usando o validator do Form)
        // if (email.isEmpty) {
        //   showErrorDialog(context, 'Por favor, insira um email.');
        //   return;
        // }
        // final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        // if (!emailRegex.hasMatch(email)) {
        //   showErrorDialog(context, 'Por favor, insira um email válido.');
        //   return;
        // }
        Provider.of<UserModel>(context, listen: false).setEmail(email);
        // Navegar para a próxima tela, por exemplo, senha
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupPasswordScreen()),
        );
      },
    );
  }
}
