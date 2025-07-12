
import 'package:flutter/material.dart';
import 'package:futuropdv/backend/services/auth_service.dart';
import 'package:futuropdv/backend/repositories/user_repository.dart';
import 'package:futuropdv/backend/services/audit_log_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _userRepository = UserRepository();
  String? _selectedRole = 'cliente';
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _auditLogService = AuditLogService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await _authService.registerWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (result['success'] && _selectedRole != null) {
          final newUser = result['user'];
          await _userRepository.createUser(
            newUser.uid,
            _nameController.text.trim(),
            _emailController.text.trim(),
            [_selectedRole!],
          );

          // Adiciona log de auditoria
          await _auditLogService.logAction(
            action: 'userCreated',
            performedBy: newUser.uid, // Este campo será sobrescrito pela função, mas é bom tê-lo aqui
            targetId: newUser.uid,
            targetType: 'user',
            newData: {
              'name': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'roles': [_selectedRole!],
            },
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registro realizado com sucesso!')),
            );
            Navigator.of(context).pop(); // Volta para a tela de login
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result['error'] ?? 'Falha no registro.')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao criar perfil: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter no mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme sua senha';
                  }
                  if (value != _passwordController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Perfil',
                  border: OutlineInputBorder(),
                ),
                items: ['cliente', 'parceiro', 'motorista', 'empresa']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 