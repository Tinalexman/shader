import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDark,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: mainDark,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: theme, size: 26.r,),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 0.01,
        ),
        title: Text(
          "Help",
          style: context.textTheme.headlineSmall!.copyWith(color: theme),
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
                        .copyWith(color: theme),
                ),
                Text("what would you like to do today?",
                    style: context.textTheme.bodyLarge!.copyWith(color: theme),
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
