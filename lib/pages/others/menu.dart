import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/pages/others/settings.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';

import '../editor/shade_maker.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDark,
      appBar: AppBar(
        backgroundColor: mainDark,
        elevation: 0.0,
        title: Image.asset(
          'assets/icon.png',
          width: 50.r,
          height: 50.r,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Text("Hi,",
                    style: context.textTheme.headlineLarge!
                        .copyWith(color: theme)),
                Text("what would you like to do today?",
                    style: context.textTheme.bodyLarge!.copyWith(color: theme)),
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShadeAction(
                      icon:
                          Icon(Icons.add_rounded, color: appYellow, size: 24.r),
                      text: "New Scene",
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SceneEditor()),
                      ),
                    ),
                    ShadeAction(
                      icon: Icon(Icons.folder_open_rounded,
                          color: appYellow, size: 24.r),
                      text: "Open Scene",
                      onTap: () {},
                    ),
                    ShadeAction(
                      icon: Icon(Icons.settings_rounded,
                          color: appYellow, size: 24.r),
                      text: "Settings",
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsPage(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShadeAction extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onTap;

  const ShadeAction({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
            color: neutral2,
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: const [
              BoxShadow(
                color: Colors.white12,
                blurRadius: 0.4,
                spreadRadius: 1.0,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.h,
            ),
            icon,
            SizedBox(
              height: 15.h,
            ),
            Text(
              text,
              style: context.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.w600, color: theme),
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }
}
