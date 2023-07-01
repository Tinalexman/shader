import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/providers.dart';

class SceneSettings extends ConsumerStatefulWidget {
  const SceneSettings({super.key});

  @override
  ConsumerState<SceneSettings> createState() => _SceneSettingsState();
}

class _SceneSettingsState extends ConsumerState<SceneSettings> {

  Future<bool> colorPickerDialog(Color defaultColor) async {
    return ColorPicker(
      color: defaultColor,
      onColorChanged: (Color color) => ref.watch(fixedCodeBlockColorProvider.notifier).state = color,
      width: 80,
      height: 50,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 200,
      showMaterialName: true,
      showColorName: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: context.textTheme.bodySmall,
      colorNameTextStyle: context.textTheme.bodySmall,
      colorCodeTextStyle: context.textTheme.bodySmall,
      pickersEnabled: const {
        ColorPickerType.wheel: true,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      transitionBuilder: (context, a1, a2, widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Global Shade Settings",
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600, color: theme),
                ),
                SizedBox(height: 10.h),
                ListTile(
                  title: Text("Hot Recompile (Buggy)",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: theme, fontWeight: FontWeight.w600)),
                  subtitle: Text("Recompile shader on source change",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: theme, fontWeight: FontWeight.w300)),
                  trailing: Checkbox(
                    value: ref.watch(hotCompileProvider),
                    onChanged: (val) =>
                        ref.watch(hotCompileProvider.notifier).state = val!,
                    checkColor: mainDark,
                    fillColor: MaterialStateProperty.all(appYellow),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  "Editor Settings",
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600, color: theme),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ListTile(
                  title: Text("Use Random Colors for Code Blocks",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: theme, fontWeight: FontWeight.w600)),
                  subtitle: Text("This will only affect newly added blocks",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: theme, fontWeight: FontWeight.w300)),
                  trailing: Checkbox(
                    value: ref.watch(randomBlockColorProvider),
                    onChanged: (val) => ref
                        .watch(randomBlockColorProvider.notifier)
                        .state = val!,
                    checkColor: mainDark,
                    fillColor: MaterialStateProperty.all(appYellow),
                  ),
                ),
                ListTile(
                  enabled: ref.watch(randomBlockColorProvider),
                  title: Text("Fixed Code Blocks Color",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: theme, fontWeight: FontWeight.w600)),
                  subtitle: Text("This will only affect newly added blocks",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: theme, fontWeight: FontWeight.w300)),
                  trailing: ColorIndicator(
                    color: ref.watch(fixedCodeBlockColorProvider),
                    onSelect: () => colorPickerDialog(ref.read(fixedCodeBlockColorProvider)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
