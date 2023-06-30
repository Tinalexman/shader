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

class ComboBox extends StatefulWidget {
  final String hint;
  final List<String>? items;
  final Widget? prefix;
  final Function? onChanged;
  final double width;
  final double height;
  final Function? onValidate;
  final String? initial;

  const ComboBox(
      {Key? key,
      this.hint = "",
      this.items,
      required this.height,
      required this.width,
      this.onValidate,
      this.prefix,
      this.initial,
      this.onChanged})
      : super(key: key);

  @override
  State<ComboBox> createState() => _ComboBoxState();
}

class _ComboBoxState extends State<ComboBox> {
  String? _selection;

  @override
  void initState() {
    super.initState();
    _selection = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: DropdownButtonFormField<String>(
        style: context.textTheme.bodyMedium!.copyWith(color: theme),
        hint: Text(widget.hint,
            style: context.textTheme.labelMedium!.copyWith(color: theme)),
        value: _selection,
        dropdownColor: mainDark,
        decoration: InputDecoration(
          prefixIcon: widget.prefix,
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: neutral3),
            borderRadius: BorderRadius.circular(5.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: neutral3),
            borderRadius: BorderRadius.circular(5.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: neutral3),
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
        validator: (val) {
          if (widget.onValidate == null) return null;
          return widget.onValidate!(val);
        },
        items: widget.items
            ?.map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: context.textTheme.bodyMedium!.copyWith(color: theme),
                ),
              ),
            )
            .toList(),
        onChanged: (item) {
          if (widget.onChanged != null) {
            widget.onChanged!(item);
          }
        },
      ),
    );
  }
}
