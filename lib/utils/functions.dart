import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';

final List<Color> _randomColors = [
  appYellow,
  containerRed,
  containerGreen,
  selectedWhite,
  theme,
];

Color randomColor() => _randomColors[Random().nextInt(_randomColors.length)];

List<Widget> lineNumbers(BuildContext context, TextEditingController controller,
    {TextStyle? style}) {
  int count = controller.text.split('\n').length;
  return List.generate(
    count,
        (index) => Text(
      "${index + 1}",
      style: style ?? context.textTheme.bodyMedium!.copyWith(color: theme),
    ),
  );
}


void unFocus() => FocusManager.instance.primaryFocus?.unfocus();