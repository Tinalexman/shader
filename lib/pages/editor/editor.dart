import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/shader_preview_config.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/widgets.dart';

import 'function_tool.dart';

class CodeEditor extends ConsumerStatefulWidget {
  const CodeEditor({Key? key}) : super(key: key);

  @override
  ConsumerState<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends ConsumerState<CodeEditor> {
  late TextEditingController codeController;
  final List<String> shaders = ["Vertex Shader", "Fragment Shader"];
  late String initial;

  late List<CodeBlockConfig> configs = [];

  @override
  void initState() {
    super.initState();
    codeController =
        TextEditingController(text: ref.read(vertexShaderProvider));
    initial = shaders[0];
    configs = [
      CodeBlockConfig(
        name: "main",
        onCodeChange: (val) {
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
      ),
      CodeBlockConfig(
        name: 'test',
        returnType: 'int',
        parameters: ["int time", "float e", "bool th"],
        onCodeChange: (val) {},
      ),
    ];
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Vertex",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme)),
              Checkbox(
                checkColor: mainDark,
                fillColor: MaterialStateProperty.all(appYellow),
                value: initial == shaders[0],
                onChanged: (val) => setState(() {
                  if (initial != shaders[0]) {
                    initial = shaders[0];
                    codeController.text =
                        ref.watch(vertexShaderProvider.notifier).state;
                  }
                }),
              ),
              Text("Fragment",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme)),
              Checkbox(
                checkColor: mainDark,
                fillColor: MaterialStateProperty.all(appYellow),
                value: initial == shaders[1],
                onChanged: (val) => setState(() {
                  if (initial != shaders[1]) {
                    initial = shaders[1];
                    codeController.text =
                        ref.watch(fragmentShaderProvider.notifier).state;
                  }
                }),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return MainCodeBlock(
                    config: configs[index],
                    controller: codeController,
                  );
                }

                return CodeBlock(
                  config: configs[index],
                  onDelete: () => setState(
                    () => configs.removeAt(index),
                  ),
                  onEdit: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FunctionCreator(
                        config: configs[index],
                        create: false,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 30.h),
              itemCount: configs.length,
            ),
          )
        ],
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
