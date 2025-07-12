
import 'package:flutter/material.dart';
import 'package:futuropdv/backend/services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await _authService.sendPasswordResetEmail(_emailController.text.trim());
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Verifique seu Email'),
              content: const Text('Um link para redefinir sua senha foi enviado para o seu email.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o diálogo
                    Navigator.of(context).pop(); // Volta para a tela de login
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Falha ao enviar email. Tente novamente.')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendResetEmail,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Enviar Email de Recuperação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 