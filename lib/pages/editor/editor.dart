import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/widgets.dart';
import 'function_tool.dart';

class CodeEditor extends ConsumerStatefulWidget {
  const CodeEditor({Key? key}) : super(key: key);

  @override
  ConsumerState<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends ConsumerState<CodeEditor>
    with AutomaticKeepAliveClientMixin {
  late TabController tabController;
  late TextEditingController fragmentController;
  late List<CodeBlockConfig> fragmentConfigs = [];

  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    fragmentController = TextEditingController();

    fragmentConfigs = [
      CodeBlockConfig(
        name: "build",
        returnType: "float",
        documentation: "This is the method in which your entire scene is built. "
            "This is where you apply all the creativity and with the us of signed distance functions, "
            "make something very wonderful. "
            "This function should return the shortest distance to any shape in your scene.",
        isMain: true,
        body: ref.read(fragmentShaderProvider),
        onCodeChange: (val) {
          ref.watch(fragmentShaderProvider.notifier).state =
              fragmentController.text;
          if (ref.read(hotCompileProvider)) {
            createNewShader(ref);
          }
          setState(() {});
        },
      )
    ];
  }

  String _assembleShader() {
    StringBuffer buffer = StringBuffer();

    String mainCode = fragmentConfigs[0].getCode();

    int insertionPoint = mainCode.indexOf(functionInsertionPoint);

    buffer.write(mainCode.substring(0, insertionPoint));
    buffer.write("\n");

    for (int i = 1; i < fragmentConfigs.length; ++i) {
      buffer.write(fragmentConfigs[i].getCode());
      buffer.write("\n\n");
    }

    buffer.write(mainCode
        .substring(insertionPoint + (functionInsertionPoint.length + 1)));

    return buffer.toString();
  }

  @override
  void dispose() {
    fragmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool addNewBlock = ref.watch(newCodeBlockProvider);
    if (addNewBlock) {
      setState(() {
        fragmentConfigs.add(
          CodeBlockConfig(name: "empty ${fragmentConfigs.length}"),
        );
      });

      Future.delayed(const Duration(milliseconds: 100),
          () => ref.watch(newCodeBlockProvider.notifier).state = false);
    }

    Future.delayed(const Duration(milliseconds: 150), () {
      int renderFlag = ref.watch(renderProvider);
      if (renderFlag == 1) {
        ref.watch(renderStateProvider.notifier).state = "Compiling";
        ref.watch(fragmentShaderProvider.notifier).state = _assembleShader();
        ref.watch(renderStateProvider.notifier).state = "Rendering";
        ref.watch(renderProvider.notifier).state = 2;
      }
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    ref.watch(newCodeBlockProvider.notifier).state = true;
                  },
                  icon: Icon(Icons.add_rounded, color: appYellow, size: 18.r),
                  splashRadius: 0.01,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            KeepAlive(
              keepAlive: true,
              child: Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
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
              ),
            )
          ],
        ),
      ),
    );
  }

  void showDocumentation(CodeBlockConfig config) {
    showModalBottomSheet(
      context: context,
      backgroundColor: mainDark,
      builder: (_) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Text(
              config.name,
              style: context.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.w700, color: theme),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "${config.parameters.isEmpty ? "" : "${config.parameters.length} parameters : "}"
              "Return type of ${config.returnType}",
              style: context.textTheme.bodyMedium!.copyWith(color: theme),
            ),
            SizedBox(height: 50.h),
            Text(
              config.documentation,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium!.copyWith(color: theme),
            ),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
