import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> headerAnimation;
  late Animation<double> trailingAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      reverseDuration: const Duration(seconds: 2),
    );

    headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 0.5, curve: Curves.fastOutSlowIn)));

    trailingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 0.5, curve: Curves.fastOutSlowIn)));

    controller.forward();
    controller.addListener(refresh);
  }

  @override
  void dispose() {
    controller.removeListener(refresh);
    controller.dispose();
    super.dispose();
  }

  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color(0xFF353535),
            Color(0xFF656565),
            Color(0xFF909090),
            Color(0xFFA0A0A0),
            Color(0xFFC2C2C2)
          ],
          stops: [0.2, 0.4, 0.6, 0.8, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: headerAnimation,
              child: const Text("Shade"),
            ),
            const SizedBox(
              height: 500,
            ),
            FadeTransition(
              opacity: trailingAnimation,
              child: const Text("By The Dreamer"),
            )
          ],
        ),
      ),
    );
  }
}
