import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/functions.dart';
import 'package:shade/utils/widgets.dart';



class Explorer extends ConsumerStatefulWidget {
  const Explorer({super.key});

  @override
  ConsumerState<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends ConsumerState<Explorer> {

  final List<List<String>> _options = [
    [Pages.editor, "Scene", "Create beautiful scenes"],
    [Pages.texture, "Texture", "Create beautiful textures"],
    [Pages.code, "Code", "Do it yourself"],
  ];


  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: SafeArea(
        child: Drawer(
          width: 300.w,
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
                    context.router.pushNamed(Pages.help);
                  },
              ),
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
                    context.router.pushNamed(Pages.settings);
                  },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Image.asset(
          'assets/icon.png',
          width: 50.r,
          height: 50.r,
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
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
        ]
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                "Hey there, 🥳",
                style: context.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5.h),
              Text(
                'What masterpiece would you be creating today?',
                style: context.textTheme.bodyMedium,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 250.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => SizedBox(width: 20.w),
                  itemBuilder: (_, index) => ExplorerChoice(
                    options: _options[index],
                  ),
                  itemCount: _options.length,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
