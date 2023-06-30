import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/shader/shader.dart';
import 'package:shade/utils/constants.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shade/utils/shader_preview_config.dart';

import '../../utils/theme.dart';
import '../../utils/widgets.dart';

class CodeEditor extends ConsumerStatefulWidget {
  const CodeEditor({Key? key}) : super(key: key);

  @override
  ConsumerState<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends ConsumerState<CodeEditor> {
  late TextEditingController codeController;

  final List<String> shaders = ["Vertex Shader", "Fragment Shader"];

  late String initial;

  @override
  void initState() {
    super.initState();
    codeController =
        TextEditingController(text: ref.read(vertexShaderProvider));
    initial = shaders[0];
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  List<Widget> lineNumbers(BuildContext context) {
    int count = codeController.text.split('\n').length;
    return List.generate(
      count,
      (index) => Text(
        "${index + 1}",
        style: context.textTheme.bodyMedium!.copyWith(color: theme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PreviewConfigurations configs = ref.watch(configurationsProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            Center(
              child: ComboBox(
                height: 45.h,
                width: 150.w,
                items: shaders,
                initial: initial,
                hint: "Choose Shader",
                onChanged: (val) => setState(() {
                  initial = val;
                  codeController.text = (initial == shaders[0])
                      ? ref.read(vertexShaderProvider)
                      : ref.read(fragmentShaderProvider);
                }),
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              height: 600.h,
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 30.w,
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: lineNumbers(context),
                      ),
                    ),
                    Expanded(
                        child: TextField(
                      controller: codeController,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      maxLines: null,
                      cursorColor: appYellow,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      textCapitalization: TextCapitalization.none,
                      scrollPhysics: const NeverScrollableScrollPhysics(),
                      textInputAction: TextInputAction.newline,
                      style: context.textTheme.bodyMedium!.copyWith(color: theme),
                      decoration: InputDecoration(
                        fillColor: search.withOpacity(0.1),
                        filled: true,
                        contentPadding: EdgeInsets.all(5.r),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: (val) {
                        if (initial == shaders[0]) {
                          ref.watch(vertexShaderProvider.notifier).state =
                              codeController.text;
                        } else {
                          ref.watch(fragmentShaderProvider.notifier).state =
                              codeController.text;
                        }

                        if (ref.read(hotCompileProvider)) {
                          createNewShader(ref);
                        }

                        setState(() {});
                      },
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> colorPickerDialog(BuildContext context) async {
    PreviewConfigurations configs = ref.watch(configurationsProvider);
    return ColorPicker(
      color: configs.clearColor,
      onColorChanged: (Color color) =>
          ref.watch(configurationsProvider.notifier).state.clearColor = color,
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
}
