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

import 'dart:developer';

class SceneParameters extends ConsumerStatefulWidget {
  const SceneParameters({super.key});

  @override
  ConsumerState<SceneParameters> createState() => _SceneSettingsState();
}

class _SceneSettingsState extends ConsumerState<SceneParameters> {
  @override
  Widget build(BuildContext context) {
    Map<String, Pair<int, dynamic>> uniforms = ref.watch(uniformsProvider);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: createNewUniform,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appYellow,
                        minimumSize: Size(100.w, 30.h),
                      ),
                      child: Text(
                        "New Uniform",
                        style: context.textTheme.bodyLarge!.copyWith(
                            color: mainDark, fontWeight: FontWeight.w500),
                      ),
                    ),
                    ElevatedButton(
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
                        minimumSize: Size(100.w, 30.h),
                      ),
                      child: Text(
                        "Apply Changes",
                        style: context.textTheme.bodyLarge!.copyWith(
                            color: mainDark, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createNewUniform() {
    unFocus();
    showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        //GlobalKey<ComboBoxState> comboKey = GlobalKey();

        return AlertDialog(
          backgroundColor: mainDark,
          elevation: 0.0,
          content: SizedBox(
            width: 250.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "New Uniform?",
                    style: context.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w700, color: theme),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Uniform Name',
                  style: context.textTheme.bodySmall!.copyWith(color: theme),
                ),
                SpecialForm(
                  controller: controller,
                  width: 200.w,
                  height: 40.h,
                  hint: "Uniform Name",
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Uniform Type',
                  style: context.textTheme.bodySmall!.copyWith(color: theme),
                ),
                ComboBox(
                  //key: comboKey,
                  width: 200.w,
                  hint: "Uniform Type",
                  items: const [
                    "float",
                    "int",
                    "vec2",
                    "vec3",
                    "vec4",
                    "sampler2D"
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      String type = "vec2"; // (comboKey.currentState
                      //?.getValue())!;
                      String name = 'resolution';
                      //controller.text.trim();

                      if (type == "vec2") {
                        ref.watch(uniformsProvider)[name] =
                            Pair(k: -1, v: Vector2());
                        setState(() {});
                      } else if (type == "vec3") {
                        ref.watch(uniformsProvider)[name] =
                            Pair(k: -1, v: Vector3());
                        setState(() {});
                      }

                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appYellow,
                      minimumSize: Size(80.w, 30.h),
                    ),
                    child: Text(
                      "Create",
                      style: context.textTheme.bodyLarge!.copyWith(
                          color: mainDark, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
                ref.watch(uniformsProvider).remove(name);
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
                ref.watch(uniformsProvider).remove(name);
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

class UniformContainer extends StatelessWidget {
  const UniformContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
