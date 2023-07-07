import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/components/sdf.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/functions.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/widgets.dart';

class CodeEditor extends ConsumerStatefulWidget {
  const CodeEditor({Key? key}) : super(key: key);

  @override
  ConsumerState<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends ConsumerState<CodeEditor>
    with AutomaticKeepAliveClientMixin {
  late TabController tabController;
  late List<CodeBlockConfig> fragmentConfigs = [];

  int currentTab = 0;

  @override
  void initState() {
    super.initState();

    fragmentConfigs = [
      CodeBlockConfig(
        name: "build",
        returnVariable: "data",
        returnType: "vec2",
        parameters: ["vec3 pos"],
        fixed: true,
        body: """
vec2 res = vec2(sphere(pos, 1.0), 1.0);
data = vec2(plane(pos, vec3(0.0, 1.0, 0.0), 1.0), 2.0);
data = join(res, data);""",
        documentation:
            "This is the method in which your entire scene is built. "
            "This method returns the 'data' which contains the shortest "
            "distance from this position 'pos' to any shape in your scene as well "
            "as the 'ID' needed to color it appropriately in the material function.",
      ),
      CodeBlockConfig(
        name: "material",
        returnVariable: "color",
        returnType: "vec3",
        parameters: ['vec3 pos', 'vec3 normal', 'float ID'],
        fixed: true,
        body: """
switch( int(ID) ) {
  case 1: color = vec3(0.5); break;
  case 2: color = checkerboard(pos); break;
  case 3: color = grid(pos);
}""",
        documentation: "This is the method in which lighting and textures are "
            "applied to your scene. This method should return the final "
            "'color' information calculated for this 'ray' based on the value of 'ID'. ",
      ),
    ];
  }

  Future<String> _assembleShader() async {
    StringBuffer buffer = StringBuffer();
    // bool precisionType = ref.watch(highPrecisionProvider);
    // precision = precisionType ? "highp" : 'mediump';
    //
    // bool aliasType = ref.watch(antiAliasProvider);
    // renderGroup = aliasType
    //     ? "vec3 color = render4XAA()"
    //     : "vec2 uv = getUV(vec2(0.0));\n\tvec3 color = render(uv);";

    buffer.write("$defaultDeclarations \n\n");

    String buildCode = fragmentConfigs[0].getCode();
    String materialCode = fragmentConfigs[1].getCode();
    String importedFunctions = _analyze(buildCode, materialCode);

    buffer.write("$importedFunctions \n\n");
    buffer.write("$buildCode \n\n");
    buffer.write("$materialCode \n\n");
    buffer.write("$rayMarch \n\n");
    buffer.write("$normal \n\n");
    buffer.write("$ambientOcclusion \n\n");
    buffer.write("$shadow \n\n");
    buffer.write("$lighting \n\n");
    buffer.write("$rotate \n\n");
    buffer.write("$mouseUpdate \n\n");
    buffer.write("$camera \n\n");
    buffer.write("$render \n\n");
    buffer.write("$uv \n\n");
    buffer.write("$render4XAA \n\n");
    buffer.write("$mainFragment \n\n");

    log(buffer.toString());

    return buffer.toString();
  }

  String _analyze(String buildCode, String materialCode) {
    List<String> keys = getAllHGKeys();
    Map<String, bool> processed = {};

    for (String key in keys) {
      RegExp pattern = RegExp(key);
      if (pattern.firstMatch(buildCode) != null) {
        processed[key] = true;
      }
    }

    for (String key in keys) {
      RegExp pattern = RegExp(key);
      if (pattern.hasMatch(materialCode)) {
        processed[key] = true;
      }
    }

    StringBuffer buffer = StringBuffer();
    Iterable<String> operators = getOperators();

    for (String key in processed.keys) {
      String code = getHGCode(key);

      for (String operator in operators) {
        RegExp pattern = RegExp(operator);
        if (processed[operator] == null && pattern.hasMatch(code)) {
          processed[operator] = true;
        }
      }
    }

    for (String key in processed.keys) {
      buffer.write("${getHGCode(key)} \n\n");
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bool addNewBlock = ref.watch(newCodeBlockProvider);
    if (addNewBlock) {
      setState(() {
        fragmentConfigs.add(
          CodeBlockConfig(name: "SDF ${fragmentConfigs.length - 1}"),
        );
      });

      Future.delayed(const Duration(milliseconds: 100),
          () => ref.watch(newCodeBlockProvider.notifier).state = false);
    }

    Future.delayed(const Duration(milliseconds: 150), () {
      int renderFlag = ref.watch(renderProvider);
      if (renderFlag == 1) {
        ref.watch(renderStateProvider.notifier).state = "Compiling";

        _assembleShader().then((shader) {
          ref.watch(fragmentShaderProvider.notifier).state = shader;
          ref.watch(renderStateProvider.notifier).state = "Rendering";
          ref.watch(renderProvider.notifier).state = 2;
        });
      }
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 25.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(
                  height: 700.h,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
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
                                builder: (_) => _EditFunction(
                                  config: fragmentConfigs[index],
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _EditFunction extends StatefulWidget {
  final CodeBlockConfig config;

  const _EditFunction({super.key, required this.config});

  @override
  State<_EditFunction> createState() => _EditFunctionState();
}

class _EditFunctionState extends State<_EditFunction> {
  late TextEditingController nameController, paramController;
  late String initial;
  final GlobalKey<ReturnTypesState> returnKey = GlobalKey();

  final List<String> params = [];

  @override
  void initState() {
    super.initState();
    paramController = TextEditingController();
    nameController = TextEditingController(text: widget.config.name);
    initial = widget.config.returnType;
    params.addAll(widget.config.parameters);
  }

  @override
  void dispose() {
    nameController.dispose();
    paramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CodeBlockConfig config = widget.config;

    return Scaffold(
      backgroundColor: mainDark,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: mainDark,
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
          "Edit Code Block",
          style: context.textTheme.headlineSmall!.copyWith(color: theme),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Name",
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: theme, fontWeight: FontWeight.w700),
                ),
                SpecialForm(
                  controller: nameController,
                  width: 250.w,
                  height: 35.h,
                  fillColor: Colors.transparent,
                  borderColor: neutral3,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "Parameters",
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: theme, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 5.h),
                Wrap(
                  spacing: 5.0,
                  children: List.generate(
                    params.length,
                    (index) => Chip(
                      onDeleted: () => setState(() => params.removeAt(index)),
                      deleteIcon:
                          Icon(Boxicons.bx_x, color: headerColor, size: 18.r),
                      label: Text(
                        params[index].toString(),
                        style: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: mainDark,
                        ),
                      ),
                      elevation: 1,
                      backgroundColor: appYellow,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                SpecialForm(
                  controller: paramController,
                  hint: "Parameter Declaration",
                  width: 170.w,
                  height: 40.h,
                ),
                SizedBox(height: 15.h),
                ElevatedButton(
                  onPressed: () {
                    String text = paramController.text.trim();
                    if (text.isEmpty) {
                      return;
                    }

                    setState(() {
                      params.add(text);
                      paramController.clear();
                    });
                    unFocus();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appYellow,
                    minimumSize: Size(60.w, 30.h),
                  ),
                  child: Text(
                    "Add",
                    style: context.textTheme.bodyLarge!
                        .copyWith(color: mainDark, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  "Return Type",
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: theme, fontWeight: FontWeight.w700),
                ),
                ReturnTypes(
                  key: returnKey,
                  initial: initial,
                ),
                SizedBox(height: 100.h),
                ElevatedButton(
                  onPressed: () {
                    config.name = nameController.text;
                    config.returnType = returnKey.currentState!.selected.name;
                    config.parameters = params;
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appYellow,
                    minimumSize: Size(100.w, 35.h),
                  ),
                  child: Text(
                    "Apply",
                    style: context.textTheme.bodyLarge!
                        .copyWith(color: mainDark, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
