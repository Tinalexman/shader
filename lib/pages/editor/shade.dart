import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/pages/misc/help.dart';
import 'package:shade/pages/editor/editor.dart';
import 'package:shade/pages/editor/preview.dart';
import 'package:shade/pages/editor/parameters.dart';
import 'package:shade/pages/misc/settings.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/functions.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/widgets.dart';

const List<Widget> pages = [CodeEditor(), ShaderPreview(), SceneParameters()];

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
      backgroundColor: mainDark,
      endDrawer: SafeArea(
        child: Drawer(
          backgroundColor: mainDark,
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Row(
                children: [
                  Image.asset('assets/icon.png'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shade",
                        style: context.textTheme.headlineSmall!
                            .copyWith(color: theme),
                      ),
                      Text(
                        "Turn your ideas into reality",
                        style: context.textTheme.bodyMedium!
                            .copyWith(color: theme),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              const Divider(
                color: neutral3,
              ),
              ListTile(
                  leading: SizedBox(
                    width: 30.w,
                    child: Center(
                      child: Icon(
                        Icons.help,
                        color: appYellow,
                        size: 18.r,
                      ),
                    ),
                  ),
                  title: Text(
                    "Help",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Everything you need to know",
                    style: context.textTheme.bodySmall!.copyWith(color: theme),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const Help(),
                    ));
                  }),
              ListTile(
                  leading: SizedBox(
                    width: 30.w,
                    child: Center(
                      child: Icon(
                        Icons.settings,
                        color: appYellow,
                        size: 18.r,
                      ),
                    ),
                  ),
                  title: Text(
                    "Settings",
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: theme, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Tweak and customize Shade",
                    style: context.textTheme.bodySmall!.copyWith(color: theme),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SettingsPage(),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainDark,
        elevation: 0.0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              width: 50.r,
              height: 50.r,
            ),
            Text(
              "Shade",
              style: context.textTheme.headlineSmall!.copyWith(color: theme),
            )
          ],
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: appYellow,
                size: 26.r,
              ),
              onPressed: () {
                unFocus();
                scaffoldKey.currentState?.openEndDrawer();
              },
              splashRadius: 0.01,
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
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_rounded,
              size: 20.r,
            ),
            label: "Options",
          ),
        ],
        onTap: (index) => ref.watch(tabProvider.notifier).state = index,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2.0,
        child: Icon(
          (page == 0 || page == 2) ? Icons.add_rounded :
          (ref.watch(renderProvider) == 2
              ? Icons.stop_rounded
              : ref.watch(renderProvider) == 1
              ? Boxicons.bx_loader
              : Icons.play_arrow_rounded),
          color: mainDark,
          size: 26.r,
        ),
        onPressed: () {
          unFocus();

          if(page == 0) {
            ref.watch(newCodeBlockProvider.notifier).state = true;
          }
          else if (page == 1) {
            int lastState = ref.watch(renderProvider.notifier).state;
            int newState = lastState == 0 ? 1 : 0;
            ref.watch(renderProvider.notifier).state = newState;

            if (newState == 0) {
              ref.watch(renderStateProvider.notifier).state = "Stopped";
            }
          } else {
            ref.watch(uniformProvider.notifier).state = true;
          }
        },
      ),
    );
  }
}
