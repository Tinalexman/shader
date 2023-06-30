import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';

class Slide extends StatefulWidget {
  final Widget content;
  final String header;

  const Slide({
    Key? key,
    required this.content,
    required this.header,
  }) : super(key: key);

  @override
  State<Slide> createState() => _SlideState();
}

class _SlideState extends State<Slide> with SingleTickerProviderStateMixin {
  bool expanded = false;
  late Animation<double> sizeAnimation;
  late AnimationController sizeController;

  @override
  void initState() {
    super.initState();
    sizeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500));
    sizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: sizeController,
        curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));
  }

  @override
  void dispose() {
    sizeController.dispose();
    super.dispose();
  }

  void refresh() => setState(() {
        expanded = !expanded;
        if (expanded) {
          sizeController.forward();
        } else {
          sizeController.reverse();
        }
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: refresh,
      child: SizedBox(
        width: 390.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.header,
                    style: context.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600, color: theme),
                  ),
                  Icon(
                    expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 24.r,
                    color: appYellow,
                  )
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              SizeTransition(
                sizeFactor: sizeAnimation,
                child: widget.content,
              )
            ],
          ),
        ),
      ),
    );
  }
}
