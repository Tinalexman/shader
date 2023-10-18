import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/pages/editor/code_editor.dart';
import 'package:shade/pages/editor/scene_editor.dart';
import 'package:shade/pages/editor/texture_editor.dart';
import 'package:shade/pages/misc/help.dart';
import 'package:shade/pages/misc/intro.dart';
import 'package:shade/pages/editor/explorer.dart';
import 'package:shade/pages/misc/settings.dart';
import 'package:shade/utils/constants.dart';

void main() {
  runApp(const ProviderScope(child: Shade()));
}

class Shade extends StatefulWidget {
  const Shade({Key? key}) : super(key: key);

  @override
  State<Shade> createState() => _ShadeState();
}

class _ShadeState extends State<Shade> {
  late GoRouter router;

  @override
  void initState() {
    super.initState();

    router = GoRouter(
      initialLocation: Pages.splash.path,
      routes: [
        GoRoute(
          name: Pages.splash,
          path: Pages.splash.path,
          builder: (_, __) => const Splash(),
        ),
        GoRoute(
          path: Pages.intro.path,
          name: Pages.intro,
          builder: (_, __) => const OnboardScreen(),
        ),
        GoRoute(
          path: Pages.explorer.path,
          name: Pages.explorer,
          builder: (_, __) => const Explorer(),
        ),
        GoRoute(
          path: Pages.editor.path,
          name: Pages.editor,
          builder: (_, __) => const SceneEditor(),
        ),
        GoRoute(
          path: Pages.texture.path,
          name: Pages.texture,
          builder: (_, __) => const TextureEditor(),
        ),
        GoRoute(
          path: Pages.code.path,
          name: Pages.code,
          builder: (_, __) => const CodeEditor(),
        ),
        GoRoute(
          path: Pages.help.path,
          name: Pages.help,
          builder: (_, __) => const Help(),
        ),
        GoRoute(
          path: Pages.settings.path,
          name: Pages.settings,
          builder: (_, __) => const SettingsPage(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp.router(
        title: 'Shade',
        darkTheme: FlexThemeData.dark(
          fontFamily: "Nunito",
          useMaterial3: true,
          scheme: FlexScheme.amber,
        ),
        theme: FlexThemeData.dark(
          fontFamily: "Nunito",
          useMaterial3: true,
          scheme: FlexScheme.amber,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
      splitScreenMode: false,
      designSize: const Size(390, 844),
      minTextAdapt: true,
    );
  }
}
