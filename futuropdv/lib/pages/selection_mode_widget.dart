import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futuropdv/backend/repositories/user_repository.dart';
import 'package:futuropdv/pages/home_page.dart';

class SelectionModeWidget extends StatefulWidget {
  const SelectionModeWidget({Key? key}) : super(key: key);

  @override
  State<SelectionModeWidget> createState() => _SelectionModeWidgetState();
}

class _SelectionModeWidgetState extends State<SelectionModeWidget> {
  final UserRepository _userRepository = UserRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _selectRole(String role) async {
    final user = _auth.currentUser;
    if (user == null) {
      // Isso não deveria acontecer, mas é uma boa prática verificar.
      // Redirecionar para o login se não houver usuário.
      // Navigator.of(context).pushAndRemoveUntil(...)
      return;
    }

    setState(() => _isLoading = true);

    try {
      // No futuro, podemos querer adicionar múltiplos papéis. Por enquanto, substituímos.
      await _userRepository.updateUserRoles(user.uid, [role]);
      
      // Marcar onboarding como completo
      await _userRepository.markOnboardingCompleted(user.uid);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false, // Remove todas as rotas anteriores
        );
      }
    } catch (e) {
      // Tratar o erro, talvez mostrando uma SnackBar
      print('Erro ao salvar a modalidade: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível salvar sua escolha. Tente novamente.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha como usar o app'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildOptionCard(
                    context: context,
                    title: 'Sou Cliente',
                    description: 'Quero contratar serviços e fazer compras.',
                    icon: Icons.person_outline,
                    userRole: 'cliente',
                  ),
                  const SizedBox(height: 16),
                  _buildOptionCard(
                    context: context,
                    title: 'Sou Parceiro',
                    description: 'Quero oferecer meus produtos e serviços.',
                    icon: Icons.storefront_outlined,
                    userRole: 'parceiro',
                  ),
                  const SizedBox(height: 16),
                  _buildOptionCard(
                    context: context,
                    title: 'Sou Motorista',
                    description: 'Quero realizar entregas e corridas.',
                    icon: Icons.local_taxi_outlined,
                    userRole: 'motorista',
                  ),
                  const SizedBox(height: 16),
                  _buildOptionCard(
                    context: context,
                    title: 'Sou Empresa',
                    description: 'Quero gerenciar minha equipe e operações.',
                    icon: Icons.business_center_outlined,
                    userRole: 'empresa',
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required String userRole,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: _isLoading ? null : () => _selectRole(userRole),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(description, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
} 