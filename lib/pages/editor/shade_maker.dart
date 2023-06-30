import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/pages/editor/editor.dart';
import 'package:shade/pages/editor/preview.dart';
import 'package:shade/utils/constants.dart';

import 'package:shade/utils/providers.dart';

import '../../utils/theme.dart';

const List<Widget> pages = [CodeEditor(), ShaderPreview()];

void unFocus() => FocusManager.instance.primaryFocus?.unfocus();

class SceneEditor extends ConsumerStatefulWidget {
  const SceneEditor({Key? key}) : super(key: key);

  @override
  ConsumerState<SceneEditor> createState() => _SceneEditorState();
}

class _SceneEditorState extends ConsumerState<SceneEditor> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    int page = ref.watch(tabProvider);

    return Scaffold(
      key: scaffoldKey,
      endDrawer: SizedBox(
        width: 290.w,
        child: Drawer(
          backgroundColor: mainDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.h),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text("Shade",
                          style: context.textTheme.headlineSmall!
                              .copyWith(color: appYellow)),
                      Text("Your imagination is your limit",
                          style: context.textTheme.bodyLarge!
                              .copyWith(color: theme))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              const Divider(
                color: neutral3,
              ),
              Expanded(
                child: ListView(
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
            ],
          ),
        ),
      ),
      backgroundColor: mainDark,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainDark,
        elevation: 0.0,
        title: Text("Shade",
            style: context.textTheme.headlineSmall!.copyWith(color: appYellow)),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.settings,
                color: appYellow,
                size: 20.r,
              ),
              onPressed: () {
                unFocus();
                scaffoldKey.currentState?.openEndDrawer();
              },
              splashRadius: 0.1,
            ),
          )
        ],
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

                if(ref.read(renderProvider)) {
                  ref.watch(tabProvider.notifier).state = 1;
                }

                createNewShader(ref);
              },
            )
          : null,
    );
  }
}
