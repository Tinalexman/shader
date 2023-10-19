import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/functions.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/widgets.dart';

class CodeEditor extends ConsumerStatefulWidget {
  const CodeEditor({Key? key}) : super(key: key);

  @override
  ConsumerState<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends ConsumerState<CodeEditor>
    with AutomaticKeepAliveClientMixin {
  late List<CodeBlockConfig> configs = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bool addNewBlock = ref.watch(newCodeBlockProvider);
    if (addNewBlock) {
      setState(() {
        configs.add(
          CodeBlockConfig(name: "SDF ${configs.length - 1}"),
        );
      });

      Future.delayed(const Duration(milliseconds: 100),
          () => ref.watch(newCodeBlockProvider.notifier).state = false);
    }

    // Future.delayed(const Duration(milliseconds: 150), () {
    //   int renderFlag = ref.watch(renderProvider);
    //   if (renderFlag == 1) {
    //     ref.watch(renderStateProvider.notifier).state = "Compiling";
    //     _assembleShader().then((shader) {
    //       ref.watch(fragmentShaderProvider.notifier).state = shader;
    //       ref.watch(renderStateProvider.notifier).state = "Rendering";
    //       ref.watch(renderProvider.notifier).state = 2;
    //     });
    //   }
    // });

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Image.asset(
          "assets/icon.png",
          width: 48.0,
          height: 48.0,
          fit: BoxFit.cover,
        ),
        title: Text(
          "Code Editor",
          style: context.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            iconSize: 26.r,
            splashRadius: 20.r,
            icon: const Icon(Icons.menu_rounded, color: appYellow),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(
                height: 25.h,
              ),
              Expanded(
                child: configs.isEmpty
                    ? Center(
                        child: Text(
                          "No code blocks added",
                          style: context.textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          if (index == configs.length) {
                            return SizedBox(height: 50.h);
                          }

                          return CodeBlock(
                            config: configs[index],
                            onDelete: () => setState(
                              () => configs.removeAt(index),
                            ),
                            onEdit: () => Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => _EditFunction(
                                      config: configs[index],
                                    ),
                                  ),
                                )
                                .then(
                                  (_) => setState(() {}),
                                ),
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(height: 30.h),
                        itemCount: configs.length + 1,
                      ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2.0,
        child: Icon(
          Icons.add_rounded,
          color: mainDark,
          size: 26.r,
        ),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => SizedBox(
            height: 250.h,
            width: 390.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hey, there",
                    style: context.textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 180.h,
                    child: ListView(
                      children: [
                        ListTile(
                            leading: const Icon(
                              Icons.code,
                              color: appYellow,
                            ),
                            title: Text(
                              "Add Code Block",
                              style: context.textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              "Let the fun continue",
                              style: context.textTheme.bodyMedium,
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              size: 26.r,
                              color: appYellow,
                            ),
                            onTap: () {
                              ref.watch(newCodeBlockProvider.notifier).state =
                                  true;
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _EditFunction extends StatefulWidget {
  final CodeBlockConfig config;

  const _EditFunction({Key? key, required this.config}) : super(key: key);

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
