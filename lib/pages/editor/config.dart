import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/providers.dart';


class SceneSettings extends ConsumerStatefulWidget {
  const SceneSettings({super.key});

  @override
  ConsumerState<SceneSettings> createState() => _SceneSettingsState();
}

class _SceneSettingsState extends ConsumerState<SceneSettings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text("Hot Recompile (Buggy)",
                  style: context.textTheme.bodyMedium!.copyWith(
                      color: theme, fontWeight: FontWeight.w600)),
              subtitle: Text("Recompile shader on source change",
                  style: context.textTheme.bodyMedium!.copyWith(
                      color: theme, fontWeight: FontWeight.w300)),
              trailing: Checkbox(
                value: ref.watch(hotCompileProvider),
                onChanged: (val) =>
                ref.watch(hotCompileProvider.notifier).state = val!,
                activeColor: appYellow,
                checkColor: mainDark,
                fillColor: MaterialStateProperty.all(theme),
              ),
            ),
            ListTile(
              title: Text("Landscape Mode",
                  style: context.textTheme.bodyMedium!.copyWith(
                      color: theme, fontWeight: FontWeight.w600)),
              subtitle: Text("Rotate the shader output",
                  style: context.textTheme.bodyMedium!.copyWith(
                      color: theme, fontWeight: FontWeight.w300)),
              trailing: Checkbox(
                value: true,
                onChanged: (val) {},
                activeColor: appYellow,
                checkColor: mainDark,
                fillColor: MaterialStateProperty.all(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
