import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../local_storage/local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.forward();

    _navigate(); // 👈 Call async method
  }

  Future<void> _navigate() async {
    final isLoggedIn = await LocalStorage.isLoggedIn();

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (isLoggedIn) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C73D2),
      body: Center(
        child: FadeTransition(
          opacity: animation,
          child: const Text(
            "My Assessment",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}