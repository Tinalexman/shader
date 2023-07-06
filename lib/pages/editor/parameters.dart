import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/components/math.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/functions.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/widgets.dart';

class SceneParameters extends ConsumerStatefulWidget {
  const SceneParameters({super.key});

  @override
  ConsumerState<SceneParameters> createState() => _SceneSettingsState();
}

class _SceneSettingsState extends ConsumerState<SceneParameters> {
  @override
  Widget build(BuildContext context) {
    bool addNewUniform = ref.watch(uniformProvider);
    if (addNewUniform) {
      Future.delayed(const Duration(milliseconds: 100), () {
        ref.watch(uniformProvider.notifier).state = false;
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => const _AddUniform(),
              ),
            )
            .then((_) => setState(() {}));
      });
    }

    Map<String, Pair<int, dynamic>> uniforms =
        ref.watch(shaderUniformsProvider);
    List<String> shaderKeys = uniforms.keys.toList();

    return Scaffold(
      backgroundColor: mainDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "Shader Parameters",
                  style:
                      context.textTheme.headlineSmall!.copyWith(color: theme),
                ),
              ),
              Text(
                "You need to create new shader parameters if you want to load textures or other "
                "values into your scene.",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium!.copyWith(color: theme),
              ),
              SizedBox(height: 50.h),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    if (index == shaderKeys.length) {
                      return Center(
                        child: ElevatedButton(
                          onPressed: () {
                            unFocus();
                            ref.watch(renderProvider.notifier).state = 1;
                            ref.watch(tabProvider.notifier).state = 1;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appYellow,
                            minimumSize: Size(80.w, 30.h),
                          ),
                          child: Text(
                            "Apply",
                            style: context.textTheme.bodyLarge!.copyWith(
                                color: mainDark, fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    }

                    String name = shaderKeys[index];
                    dynamic value = uniforms[name]!;
                    return determineType(name, value);
                  },
                  separatorBuilder: (_, __) => SizedBox(
                    height: 30.h,
                  ),
                  itemCount: shaderKeys.isEmpty ? 0 : shaderKeys.length + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget determineType(String name, Pair<int, dynamic> pair) {
    dynamic value = pair.v;
    if (value is Vector2) {
      return Vector2Input(
          vector: value,
          label: name,
          onDelete: () {
            ref.watch(shaderUniformsProvider).remove(name);
            setState(() {});
          });
    }
    return const SizedBox();
  }
}

class _AddUniform extends ConsumerStatefulWidget {
  const _AddUniform({super.key});

  @override
  ConsumerState<_AddUniform> createState() => _AddUniformState();
}

class _AddUniformState extends ConsumerState<_AddUniform> {
  final TextEditingController nameController = TextEditingController();

  String? type;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            "Add Shader Parameter",
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
                    'Parameter Name',
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w700),
                  ),
                  SpecialForm(
                    controller: nameController,
                    width: 200.w,
                    height: 40.h,
                    hint: "Parameter Name",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Parameter Type',
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w700),
                  ),
                  ComboBox(
                    width: 200.w,
                    hint: "Parameter Type",
                    initial: type,
                    items: const [
                      "float",
                      "int",
                      "vec2",
                      "vec3",
                      "vec4",
                      "sampler2D"
                    ],
                    onChanged: (val) => setState(() => type = val),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(height: 100.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (type == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: mainDark,
                              content: Text(
                                "You need to choose a parameter type.",
                                style: context.textTheme.bodyMedium!
                                    .copyWith(color: theme),
                              ),
                              dismissDirection: DismissDirection.vertical,
                            ),
                          );
                        }

                        String name = nameController.text.trim();
                        if (type == "vec2") {
                          ref
                              .watch(shaderUniformsProvider.notifier)
                              .state
                              .putIfAbsent(
                                  name, () => Pair(k: -1, v: Vector2()));
                        } else if (type == "vec3") {
                          ref
                              .watch(shaderUniformsProvider.notifier)
                              .state
                              .putIfAbsent(
                                  name, () => Pair(k: -1, v: Vector3()));
                        }

                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appYellow,
                        minimumSize: Size(100.w, 35.h),
                      ),
                      child: Text(
                        "Add",
                        style: context.textTheme.bodyLarge!.copyWith(
                            color: mainDark, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
