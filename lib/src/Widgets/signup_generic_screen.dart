import 'package:flutter/material.dart';

class SignupGenericScreen extends StatefulWidget {
  final String title;
  final String question;
  final String hintText;
  final String helperText;
  final TextInputType inputType;
  final bool isPassword;
  final Function(String) onNext;
  final String? Function(String?)? validator;

  const SignupGenericScreen({
    super.key,
    required this.title,
    required this.question,
    required this.hintText,
    required this.helperText,
    required this.inputType,
    this.isPassword = false,
    required this.onNext,
    this.validator,
  });

  @override
  _SignupGenericScreenState createState() => _SignupGenericScreenState();
}

class _SignupGenericScreenState extends State<SignupGenericScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true; // Para controlar a visibilidade da senha

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
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Pergunta
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Campo de input
              TextFormField(
                controller: _controller,
                keyboardType: widget.inputType,
                obscureText: widget.isPassword ? _obscureText : false,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      : null,
                ),
                validator: widget.validator,
              ),
              const SizedBox(height: 5),
              // Texto de ajuda
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.helperText,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Botão "Próximo"
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onNext(_controller.text);
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.red, Colors.orange],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      child: const Text(
                        'Próximo',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
