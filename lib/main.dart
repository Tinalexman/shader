import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/editor/preview.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'editor/shade_maker.dart';

void main() {
  runApp(const ProviderScope(child: Shade()));
}

class Shade extends StatelessWidget {
  const Shade({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        title: 'Shade',
        darkTheme: KdeTheme.dark(),
        theme: KdeTheme.light(),
        debugShowCheckedModeBanner: false,
        home: const Splash(),
      ),
      splitScreenMode: false,
      designSize: const Size(390, 844),
      minTextAdapt: true,
    );
  }
}

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

    headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: const Interval(0.2, 0.5, curve: Curves.easeInOut)));

    trailingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: const Interval(0.7, 1.0, curve: Curves.easeInOutCubic)));

    controller.forward().then(
          (_) => controller.reverse().then(
                (value) => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SceneEditor(),
                  ),
                ),
              ),
        );
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
        width: 390.w,
        color: const Color(0xFF313131),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: headerAnimation,
              child: Text("Shade",
                  style: context.textTheme.headlineLarge!
                      .copyWith(color: appYellow, fontSize: 42.sp)),
            ),
            SizedBox(
              height: 350.h,
            ),
            FadeTransition(
              opacity: trailingAnimation,
              child: Text(
                "By The Dreamer",
                style: context.textTheme.bodyLarge!.copyWith(color: theme),
              ),
            )
          ],
        ),
      ),
    );
  }
}
