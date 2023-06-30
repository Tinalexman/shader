import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';

import 'editor/shade_maker.dart';

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
        title: Text("Shade",
            style: context.textTheme.headlineSmall!.copyWith(color: appYellow)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Text("data",
                    style: context.textTheme.bodyLarge!.copyWith(color: theme)),
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      onTap: () {},
                    ),
                  ],
                ),
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
            borderRadius: BorderRadius.circular(6.r),
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
