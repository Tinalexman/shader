import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/pages/editor/editor.dart';
import 'package:shade/pages/editor/preview.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/functions.dart';

import 'package:shade/utils/providers.dart';

import '../../utils/theme.dart';
import 'config.dart';

const List<Widget> pages = [CodeEditor(), ShaderPreview(), SceneSettings()];

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
      floatingActionButton: page != 2
          ? FloatingActionButton(
              elevation: 2.0,
              tooltip: 'Start/Stop Render',
              child: Icon(
                page == 0
                    ? Icons.add_rounded
                    : (ref.watch(renderProvider) == 2
                        ? Icons.stop_rounded
                        : ref.watch(renderProvider) == 1
                            ? Icons.work_rounded
                            : Icons.play_arrow_rounded),
                color: mainDark,
                size: 26.r,
              ),
              onPressed: () {
                unFocus();

                if (page == 0) {
                  ref.watch(newCodeBlockProvider.notifier).state = true;
                  ref.watch(newCodeBlockProvider.notifier).state = false;
                }

                if (page == 1) {
                  int lastState = ref.watch(renderProvider.notifier).state;
                  int newState = lastState == 0 ? 1 : 0;
                  ref.watch(renderProvider.notifier).state = newState;

                  if (newState == 1) {
                    createNewShader(ref);
                  }
                }
              },
            )
          : null,
    );
  }
}
