import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:shade/pages/others/help.dart';
import 'package:shade/pages/editor/shade.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';

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
      duration: const Duration(milliseconds: 1500),
      reverseDuration: const Duration(milliseconds: 1500),
    );

    headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeInOut),
      ),
    );

    trailingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 0.9, curve: Curves.fastOutSlowIn),
      ),
    );

    controller.forward().then(
          (_) => controller.reverse().then(
            (__) {
              IsFirstRun.isFirstCall().then(
                (first) => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        first ? _OnboardScreen() : const SceneEditor(),
                  ),
                ),
              );
            },
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
      backgroundColor: mainDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: headerAnimation,
              child: Image.asset('assets/icon.png'),
            ),
            FadeTransition(
              opacity: trailingAnimation,
              child: Text(
                "Shade",
                style: context.textTheme.headlineMedium!.copyWith(color: theme),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OnboardScreen extends StatefulWidget {
  @override
  State<_OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<_OnboardScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDark,
      appBar: AppBar(
        backgroundColor: mainDark,
        elevation: 0.0,
      ),
      body: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: mainDark,
        pages: [
          PageViewModel(
            decoration: const PageDecoration(
              pageColor: mainDark,
            ),
            titleWidget: Text('Procedural Worlds',
                style: context.textTheme.headlineSmall!.copyWith(color: theme)),
            image: Image.asset('assets/explore.png'),
            bodyWidget: Text("Create and explore amazing procedural worlds.",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge!.copyWith(color: theme)),
          ),
          PageViewModel(
            decoration: const PageDecoration(
              pageColor: mainDark,
            ),
            titleWidget: Text('Your Inner Artist',
                style: context.textTheme.headlineSmall!.copyWith(color: theme)),
            image: Image.asset('assets/sculpt.png'),
            bodyWidget: Text(
                "Let out that artistic spirit and create wonderful shapes.",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge!.copyWith(color: theme)),
          ),
          PageViewModel(
            decoration: const PageDecoration(
              pageColor: mainDark,
            ),
            titleWidget: Text('Easy As ABC',
                style: context.textTheme.headlineSmall!.copyWith(color: theme)),
            image: Image.asset('assets/app.png'),
            bodyWidget: Text(
                "All you need is just your phone and a little knowledge of computer graphics.",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge!.copyWith(color: theme)),
          ),
        ],
        showNextButton: true,
        showDoneButton: true,
        done: Text(
          "Done",
          style: context.textTheme.bodyLarge!
              .copyWith(color: theme, fontWeight: FontWeight.w500),
        ),
        next: Text(
          "Next",
          style: context.textTheme.bodyLarge!
              .copyWith(color: theme, fontWeight: FontWeight.w500),
        ),
        onDone: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const Help(),
          ),
        ),
        dotsContainerDecorator: const BoxDecoration(color: mainDark),
      ),
    );
  }
}
