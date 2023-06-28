import 'package:flutter/material.dart';
import 'package:shade/editor/splash.dart';

import 'package:shade/utils/theme.dart';


void main() {
  runApp(const Shade());
}



class Shade extends StatelessWidget
{
  const Shade({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: materialColor,
        fontFamily: "Nunito"
      ),
      home: const Splash(),
    );
  }
}

