import 'package:flutter/material.dart';
import 'package:futuropdv/pages/selection_mode_widget.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({Key? key}) : super(key: key);

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  double _pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page!;
      });
    });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Começa um pouco abaixo
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(), // Adiciona bounce effect
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
              // Reinicia a animação para a nova página
              _animationController.reset();
              _animationController.forward();
            },
            children: <Widget>[
              _buildPage(
                index: 0,
                title: 'Bem-vindo ao FuturoPDV',
                description: 'Sua solução completa para gestão de ponto de venda e muito mais.',
                icon: Icons.waving_hand,
              ),
              _buildPage(
                index: 1,
                title: 'Gerencie suas Vendas',
                description: 'Acompanhe suas vendas, estoque e clientes de forma fácil e intuitiva.',
                icon: Icons.trending_up,
              ),
              _buildPage(
                index: 2,
                title: 'Múltiplas Modalidades',
                description: 'Escolha como você quer usar o app: como cliente, parceiro, motorista ou empresa.',
                icon: Icons.apps,
              ),
            ],
          ),
          Positioned(
            bottom: 80.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => _buildDot(index, context)),
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _currentPage == 2
                  ? ElevatedButton(
                      key: const ValueKey('começar'),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const SelectionModeWidget()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('COMEÇAR'),
                    )
                  : TextButton(
                      key: const ValueKey('próximo'),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('PRÓXIMO'),
                    ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 20.0,
            left: _currentPage == 2 ? -100 : 20.0, // Anima para fora da tela na última página
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _currentPage == 2 ? 0.0 : 1.0,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SelectionModeWidget()),
                  );
                },
                child: const Text('PULAR'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required int index,
    required String title,
    required String description,
    required IconData icon,
  }) {
    // Calcula o offset para o efeito parallax
    double parallaxOffset = (_pageOffset - index).clamp(-1.0, 1.0) * 100;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Placeholder visual para as imagens com efeito parallax
            Transform.translate(
              offset: Offset(parallaxOffset, 0),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 120,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 40),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForPage(String title) {
    if (title.contains('Bem-vindo')) {
      return Icons.waving_hand;
    } else if (title.contains('Vendas')) {
      return Icons.trending_up;
    } else if (title.contains('Modalidades')) {
      return Icons.apps;
    }
    return Icons.info;
  }

  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 10,
      width: _currentPage == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColor.withValues(alpha: 0.3),
      ),
    );
  }
} 