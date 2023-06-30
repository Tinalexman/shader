import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/pages/editor/editor.dart';
import 'package:shade/pages/editor/preview.dart';
import 'package:shade/utils/constants.dart';

import 'package:shade/utils/providers.dart';

import '../../utils/theme.dart';
import 'config.dart';

const List<Widget> pages = [CodeEditor(), SceneSettings(), ShaderPreview()];

void unFocus() => FocusManager.instance.primaryFocus?.unfocus();

class SceneEditor extends ConsumerStatefulWidget {
  const SceneEditor({Key? key}) : super(key: key);

  @override
  ConsumerState<SceneEditor> createState() => _SceneEditorState();
}

class _SceneEditorState extends ConsumerState<SceneEditor> {
  @override
  Widget build(BuildContext context) {
    int page = ref.watch(tabProvider);

    return Scaffold(
      backgroundColor: mainDark,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainDark,
        elevation: 0.0,
        title: Text(
          "Shade",
          style: context.textTheme.headlineSmall!.copyWith(color: appYellow),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: page,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mainDark,
        currentIndex: page,
        unselectedItemColor: neutral4,
        selectedFontSize: 14.r,
        unselectedFontSize: 14.r,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.code_rounded,
              size: 20.r,
            ),
            label: "Editor",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_rounded,
              size: 20.r,
            ),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.image_rounded,
              size: 20.r,
            ),
            label: "Preview",
          ),
        ],
        onTap: (index) => ref.watch(tabProvider.notifier).state = index,
      ),
      floatingActionButton: page == 0
          ? FloatingActionButton(
              elevation: 2.0,
              tooltip: 'Start/Stop Render',
              child: Icon(
                ref.watch(renderProvider)
                    ? Icons.stop_rounded
                    : Icons.play_arrow_rounded,
                color: mainDark,
                size: 26.r,
              ),
              onPressed: () {
                unFocus();
                bool lastState = ref.watch(renderProvider.notifier).state;
                ref.watch(renderProvider.notifier).state = !lastState;

                if (ref.read(renderProvider)) {
                  ref.watch(tabProvider.notifier).state = 2;
                }

                createNewShader(ref);
              },
            )
          : null,
    );
  }
}
