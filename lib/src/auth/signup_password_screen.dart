import 'package:flutter/material.dart';
import 'package:hablar/src/auth/signup_name_screen.dart';
import 'package:provider/provider.dart';

import '../provider/user_model.dart';
import '../sign_up_generic_screen/signup_generic_screen.dart';

class SignupPasswordScreen extends StatelessWidget {
  const SignupPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = Provider.of<UserModel>(context).email;

    return SignupGenericScreen(
      title: 'Crie uma senha',
      question: 'Escolha uma senha',
      hintText: 'Digite sua senha',
      helperText: 'Use ao menos 8 caracteres',
      inputType: TextInputType.text,
      isPassword: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira uma senha';
        }
        if (value.length < 8) {
          return 'A senha deve ter ao menos 8 caracteres';
        }
        return null;
      },
      onNext: (password) {
        Provider.of<UserModel>(context, listen: false).setPassword(password);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupNameScreen()),
        );
      },
    );
  }
}
