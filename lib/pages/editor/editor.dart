import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/shader/dream_shader.dart';
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

class _CodeEditorState extends ConsumerState<CodeEditor>
    with SingleTickerProviderStateMixin {
  late TextEditingController vertexController, fragmentController;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    vertexController = TextEditingController();
    fragmentController = TextEditingController();

    vertexController.text = ref.read(vertexShaderProvider);
    fragmentController.text = ref.read(fragmentShaderProvider);

    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    fragmentController.dispose();
    vertexController.dispose();
    super.dispose();
  }

  List<Widget> lineNumbers(BuildContext context) {
    int count = vertexController.text.split('\n').length;
    return List.generate(
        count,
        (index) => Text(
              "${index + 1}",
              style: context.textTheme.bodyMedium!.copyWith(color: theme),
            ));
  }

  @override
  Widget build(BuildContext context) {
    PreviewConfigurations configs = ref.watch(configurationsProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              dividerColor: appYellow,
              tabs: [
                Tab(
                  child: Text("Vertex",
                      style:
                          context.textTheme.bodyMedium!.copyWith(color: theme)),
                ),
                Tab(
                  child: Text("Fragment",
                      style:
                          context.textTheme.bodyMedium!.copyWith(color: theme)),
                ),
                Tab(
                  child: Text("Scene",
                      style:
                          context.textTheme.bodyMedium!.copyWith(color: theme)),
                ),
              ],
            ),
            SizedBox(
              height: 600.h,
              child: TabBarView(controller: tabController, children: [
                SizedBox(
                  height: 600.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: lineNumbers(context),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                        controller: vertexController,
                        keyboardType: TextInputType.multiline,
                        minLines: null,
                        maxLines: null,
                        cursorColor: appYellow,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.top,
                        textCapitalization: TextCapitalization.none,
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        textInputAction: TextInputAction.newline,
                        style: context.textTheme.bodyMedium!
                            .copyWith(color: theme),
                        decoration: InputDecoration(
                          fillColor: search,
                          filled: true,
                          contentPadding: EdgeInsets.all(5.r),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (val) {
                          ref.watch(vertexShaderProvider.notifier).state =
                              vertexController.text;

                          if (ref.read(hotCompileProvider)) {
                            createNewShader(ref);
                          }

                          setState(() {});
                        },
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 600.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: lineNumbers(context),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                        controller: fragmentController,
                        keyboardType: TextInputType.multiline,
                        minLines: null,
                        maxLines: null,
                        cursorColor: appYellow,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.top,
                        textCapitalization: TextCapitalization.none,
                        //expands: true,
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        //maxLengthEnforcement: MaxLengthEnforcement.none,
                        textInputAction: TextInputAction.newline,
                        style: context.textTheme.bodyMedium!
                            .copyWith(color: theme),
                        decoration: InputDecoration(
                          fillColor: search,
                          filled: true,
                          contentPadding: EdgeInsets.all(5.r),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (val) {
                          ref.watch(fragmentShaderProvider.notifier).state =
                              fragmentController.text;

                          if (ref.read(hotCompileProvider)) {
                            createNewShader(ref);
                          }

                          setState(() {});
                        },
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 600.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          Wrap(
                            spacing: 5.w,
                            children: [
                              Text('Scene Name:',
                                  style: context.textTheme.bodyMedium!
                                      .copyWith(color: theme),
                              ),
                              Text('testScene',
                                style: context.textTheme.bodyMedium!
                                    .copyWith(color: theme, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 5.w,
                            children: [
                              Text('Scene Size:',
                                style: context.textTheme.bodyMedium!
                                    .copyWith(color: theme),
                              ),
                              Text('2.7 kilobytes',
                                style: context.textTheme.bodyMedium!
                                    .copyWith(color: theme, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ListTile(
                            title: Text(
                              "Clear Color",
                              style: context.textTheme.bodyMedium!.copyWith(
                                  color: theme, fontWeight: FontWeight.w600),
                            ),
                            onTap: () async => colorPickerDialog(context),
                            subtitle: Text(
                                "Background Color for shader preview",
                                style: context.textTheme.bodyMedium!.copyWith(
                                    color: theme, fontWeight: FontWeight.w300)),
                            trailing: ColorIndicator(
                              color: configs.clearColor,
                              onSelectFocus: false,
                            ),
                          ),
                          Slide(
                            header: "Meshes",
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello",
                                  style: context.textTheme.bodyMedium!
                                      .copyWith(color: theme),
                                ),
                                Text("Here",
                                    style: context.textTheme.bodyMedium!
                                        .copyWith(color: theme))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ]),
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
