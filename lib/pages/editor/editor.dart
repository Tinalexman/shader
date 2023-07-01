import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/widgets.dart';
import 'dart:developer';
import 'function_tool.dart';

class CodeEditor extends ConsumerStatefulWidget {
  const CodeEditor({Key? key}) : super(key: key);

  @override
  ConsumerState<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends ConsumerState<CodeEditor>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late TextEditingController vertexController, fragmentController;

  late List<CodeBlockConfig> vertexConfigs = [], fragmentConfigs = [];

  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    vertexController =
        TextEditingController(text: ref.read(vertexShaderProvider));
    fragmentController =
        TextEditingController(text: ref.read(fragmentShaderProvider));

    vertexConfigs = [
      CodeBlockConfig(
        name: "main",
        isMain: true,
        onCodeChange: (val) {
          ref.watch(vertexShaderProvider.notifier).state =
              vertexController.text;
          if (ref.read(hotCompileProvider)) {
            createNewShader(ref);
          }
          setState(() {});
        },
      ),
      CodeBlockConfig(),
    ];

    fragmentConfigs = [
      CodeBlockConfig(
        name: "main",
        isMain: true,
        onCodeChange: (val) {
          ref.watch(fragmentShaderProvider.notifier).state =
              fragmentController.text;
          if (ref.read(hotCompileProvider)) {
            createNewShader(ref);
          }
          setState(() {});
        },
      ),
      CodeBlockConfig(),
    ];
  }

  String _assembleShader(int index) {
    StringBuffer buffer = StringBuffer();
    List<CodeBlockConfig> configs = (index == 0) ? vertexConfigs : fragmentConfigs;

    String mainCode = configs[0].getCode();
    int insertionPoint = mainCode.indexOf(functionInsertionPoint);

    buffer.write(mainCode.substring(0, insertionPoint));
    buffer.write("\n");

    for(int i = 1; i < configs.length; ++i) {
      buffer.write(configs[i].getCode());
      buffer.write("\n\n");
    }

    buffer.write(mainCode.substring(insertionPoint + (functionInsertionPoint.length + 1)));

    return buffer.toString();
  }

  @override
  void dispose() {
    tabController.dispose();
    fragmentController.dispose();
    vertexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool addNewBlock = ref.watch(newCodeBlockProvider);

    if (addNewBlock) {
      setState(() {
        if (currentTab == 0) {
          vertexConfigs.add(
            CodeBlockConfig(),
          );
        } else {
          fragmentConfigs.add(
            CodeBlockConfig(),
          );
        }
      });
    }

    int renderFlag = ref.watch(renderProvider.notifier).state;
    if(renderFlag == 1) {
      ref.watch(renderStateProvider.notifier).state = "Compiling";
      ref.watch(vertexShaderProvider.notifier).state = _assembleShader(0);
      ref.watch(fragmentShaderProvider.notifier).state = _assembleShader(1);
      ref.watch(renderStateProvider.notifier).state = "Rendering";
      ref.watch(renderProvider.notifier).state = 2;
    }



    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            TabBar(
              onTap: (index) => setState(() => currentTab = 0),
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: appYellow,
              tabs: [
                Tab(
                  child: Text(
                    "Vertex",
                    style: context.textTheme.bodyMedium!.copyWith(color: theme),
                  ),
                ),
                Tab(
                  child: Text(
                    "Fragment",
                    style: context.textTheme.bodyMedium!.copyWith(color: theme),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: 390.w,
              height: 600.h,
              child: TabBarView(controller: tabController, children: [
                SizedBox(
                  width: 390.w,
                  height: 600.h,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      log("Vertex configs: ${vertexConfigs.length}");
                      log("Index: $index");
                      if (index == 0) {
                        return MainCodeBlock(
                          config: vertexConfigs[index],
                          controller: vertexController,
                        );
                      }

                      if (index == vertexConfigs.length) {
                        return SizedBox(height: 50.h);
                      }

                      return CodeBlock(
                        config: vertexConfigs[index],
                        onDelete: () => setState(
                          () => vertexConfigs.removeAt(index),
                        ),
                        onEdit: () => Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (_) => FunctionCreator(
                                  config: vertexConfigs[index],
                                  create: false,
                                ),
                              ),
                            )
                            .then(
                              (_) => setState(() {}),
                            ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 30.h),
                    itemCount: vertexConfigs.length + 1,
                  ),
                ),
                SizedBox(
                  width: 390.w,
                  height: 600.h,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      log("Fragment configs: ${fragmentConfigs.length}");
                      log("Index: $index");
                      if (index == 0) {
                        return MainCodeBlock(
                          config: fragmentConfigs[index],
                          controller: fragmentController,
                        );
                      }

                      if (index == fragmentConfigs.length) {
                        return SizedBox(height: 50.h);
                      }

                      return CodeBlock(
                        config: fragmentConfigs[index],
                        onDelete: () => setState(
                          () => fragmentConfigs.removeAt(index),
                        ),
                        onEdit: () => Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (_) => FunctionCreator(
                                  config: fragmentConfigs[index],
                                  create: false,
                                ),
                              ),
                            )
                            .then(
                              (_) => setState(() {}),
                            ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 30.h),
                    itemCount: fragmentConfigs.length + 1,
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
