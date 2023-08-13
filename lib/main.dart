import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/pages/editor/factory.dart';
import 'package:shade/pages/misc/intro.dart';
import 'package:shade/utils/theme.dart';

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
        darkTheme: ShadeTheme.dark(),
        theme: ShadeTheme.dark(),
        debugShowCheckedModeBanner: false,
        home: const FactoryPage(),
      ),
      splitScreenMode: false,
      designSize: const Size(390, 844),
      minTextAdapt: true,
    );
  }
}
