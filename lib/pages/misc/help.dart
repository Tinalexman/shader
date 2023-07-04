import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/functions.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/widgets.dart';

class HelpContent {
  final String header;
  final String description;
  final VoidCallback onClick;

  const HelpContent({
    required this.header,
    required this.description,
    required this.onClick,
  });
}

List<HelpContent> _contents = [
  HelpContent(header: "Editor", description: "This is the editor", onClick: () {}),
  HelpContent(header: "Preview", description: "preview", onClick: () {}),
];

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  int current = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDark,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: mainDark,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            color: theme,
            size: 26.r,
          ),
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
                SizedBox(
                  height: 650.h,
                  child: PageView.builder(
                    controller: controller,
                    onPageChanged: (index) => setState(() => current = index),
                    itemBuilder: (context, index) {
                      Color color = randomColor();
                      return Container(
                        height: 650.h,
                        width: 390.w,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: color, width: 2.0),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _contents[index].header,
                              style: context.textTheme.headlineLarge!
                                  .copyWith(color: color),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              _contents[index].description,
                              style: context.textTheme.bodyLarge!
                                  .copyWith(color: color),
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                iconSize: 36.r,
                                icon: Icon(Icons.chevron_right_rounded,
                                    color: color),
                                onPressed: _contents[index].onClick,
                                splashColor: color.withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: _contents.length,
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Wrap(
                    spacing: 20.0,
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      2,
                      (index) =>
                          Bullet(color: current == index ? theme : neutral3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
