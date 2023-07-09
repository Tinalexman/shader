import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/widgets.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Future<bool> colorPickerDialog(Color defaultColor) async {
    return ColorPicker(
      color: defaultColor,
      onColorChanged: (Color color) =>
          ref.watch(fixedCodeBlockColorProvider.notifier).state = color,
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            color: theme,
            size: 26.r,
          ),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 0.01,
        ),
        title: Text(
          "Global Settings",
          style: context.textTheme.headlineSmall!.copyWith(color: theme),
        ),
        elevation: 0.0,
        backgroundColor: mainDark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text("Use Random Colors for Code Blocks",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w600)),
                subtitle: Text("This will affect all visible blocks",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w300)),
                trailing: Checkbox(
                  value: ref.watch(randomBlockColorProvider),
                  onChanged: (val) =>
                      ref.watch(randomBlockColorProvider.notifier).state = val!,
                  checkColor: mainDark,
                  fillColor: MaterialStateProperty.all(appYellow),
                ),
              ),
              ListTile(
                enabled: ref.watch(randomBlockColorProvider),
                title: Text("Fixed Code Blocks Color",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w600)),
                subtitle: Text("This will affect all visible blocks",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w300)),
                trailing: ColorIndicator(
                  color: ref.watch(fixedCodeBlockColorProvider),
                  onSelect: () =>
                      colorPickerDialog(ref.read(fixedCodeBlockColorProvider)),
                ),
              ),

              // Font Size

              const Divider(
                color: neutral3,
              ),
              ListTile(
                title: Text("Enable High Precision",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w600)),
                subtitle: Text(
                    "Better render quality at the cost of performance",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w300)),
                trailing: Checkbox(
                  value: ref.watch(highPrecisionProvider),
                  onChanged: (val) =>
                      ref.watch(highPrecisionProvider.notifier).state = val!,
                  checkColor: mainDark,
                  fillColor: MaterialStateProperty.all(appYellow),
                ),
              ),
              ListTile(
                title: Text("Enable 4xAA Rendering",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w600)),
                subtitle: Text(
                    "Reduce antialiasing at the heavy of performance",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w300)),
                trailing: Checkbox(
                  value: ref.watch(antiAliasProvider),
                  onChanged: (val) =>
                      ref.watch(antiAliasProvider.notifier).state = val!,
                  checkColor: mainDark,
                  fillColor: MaterialStateProperty.all(appYellow),
                ),
              ),
              ListTile(
                  title: Text("Raytracing Steps",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: theme, fontWeight: FontWeight.w600)),
                  subtitle: Text("Large steps reduces performance",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: theme, fontWeight: FontWeight.w300)),
                  trailing: ComboBox(
                    width: 70.w,
                    height: 40.h,
                    initial: ref.watch(raytraceStepsProvider),
                    items: const ['128', '256', '512', '1024'],
                    onChanged: (val) =>
                        ref.watch(raytraceStepsProvider.notifier).state = val,
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
