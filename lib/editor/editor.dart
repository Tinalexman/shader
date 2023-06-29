import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/shader/dream_shader.dart';
import 'package:shade/utils/constants.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/theme.dart';

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

    tabController = TabController(length: 2, vsync: this);
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            TabBar(
              controller: tabController,
              dividerColor: appYellow,
              tabs: [
                Tab(
                  child: Text("Vertex Shader",
                      style:
                          context.textTheme.bodyMedium!.copyWith(color: theme)),
                ),
                Tab(
                  child: Text("Fragment Shader",
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

                          if(ref.read(hotCompileProvider)) {
                            createNewShader(ref);
                          }

                          setState(() {});
                        },
                      )),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
