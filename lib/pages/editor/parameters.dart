import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/components/math.dart';
import 'package:shade/pages/editor/shade.dart';
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const _AddUniform(),
          ),
        );
      });
    }

    Map<String, Pair<int, dynamic>> uniforms =
        ref.watch(shaderUniformsProvider);
    List<String> shaderKeys = uniforms.keys.toList();

    return Scaffold(
      backgroundColor: mainDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    "Shader Uniforms",
                    style:
                        context.textTheme.headlineSmall!.copyWith(color: theme),
                  ),
                ),
                Text(
                  "You need to register your uniforms before it can be loaded into to the shader.",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium!.copyWith(color: theme),
                ),
                SizedBox(height: 50.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(shaderKeys.length, (index) {
                    String name = shaderKeys[index];
                    dynamic value = uniforms[name]!;
                    return determineType(name, value);
                  }),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      unFocus();
                      for (String key in shaderKeys) {
                        dynamic value = uniforms[key]!.v;
                        if (value is Changeable && value.hasChanged) {
                          //value.onChange(ref.read(glProvider), key);
                          value.hasChanged = false;
                        }
                      }
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget determineType(String name, Pair<int, dynamic> pair) {
    dynamic value = pair.v;
    if (value is Vector2) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Vector2Input(vector: value, label: name),
            IconButton(
              onPressed: () {
                ref.watch(shaderUniformsProvider).remove(name);
                setState(() {});
              },
              icon: Icon(
                Boxicons.bx_x,
                color: appYellow,
                size: 20.r,
              ),
              splashRadius: 0.01,
            )
          ],
        ),
      );
    } else if (value is Vector3) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Vector3Input(vector: value, label: name),
            IconButton(
              onPressed: () {
                ref.watch(shaderUniformsProvider).remove(name);
                setState(() {});
              },
              icon: Icon(
                Boxicons.bx_x,
                color: appYellow,
                size: 20.r,
              ),
              splashRadius: 0.01,
            )
          ],
        ),
      );
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
            "Add Uniform",
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
                    'Uniform Name',
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w700),
                  ),
                  SpecialForm(
                    controller: nameController,
                    width: 200.w,
                    height: 40.h,
                    hint: "Uniform Name",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Uniform Type',
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w700),
                  ),
                  ComboBox(
                    width: 200.w,
                    hint: "Uniform Type",
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
                                "You need to choose a uniform type.",
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
