import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/functions.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/widgets.dart';

class FunctionCreator extends StatefulWidget {
  final bool create;
  final CodeBlockConfig config;

  const FunctionCreator({super.key, this.create = true, required this.config});

  @override
  State<FunctionCreator> createState() => _FunctionCreatorState();
}

class _FunctionCreatorState extends State<FunctionCreator> {
  late TextEditingController nameController, paramController;
  late String initial;
  final GlobalKey<ReturnTypesState> returnKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    paramController = TextEditingController();
    nameController = TextEditingController(text: widget.config.name);
    initial = widget.config.returnType;
  }

  @override
  void dispose() {
    nameController.dispose();
    paramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CodeBlockConfig config = widget.config;

    return Scaffold(
      backgroundColor: mainDark,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: mainDark,
        automaticallyImplyLeading: false,
        title: Text(
          "${widget.create ? "Create New" : "Edit"} Function",
          style: context.textTheme.headlineSmall!.copyWith(color: appYellow),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                Text(
                  "Name",
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: theme, fontWeight: FontWeight.w700),
                ),
                SpecialForm(
                  controller: nameController,
                  width: 250.w,
                  height: 35.h,
                  fillColor: Colors.transparent,
                  borderColor: neutral3,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "Parameters",
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: theme, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 5.h),
                Wrap(
                  spacing: 5.0,
                  children: List.generate(
                    config.parameters.length,
                    (index) => Chip(
                      onDeleted: () =>
                          setState(() => config.parameters.removeAt(index)),
                      deleteIcon:
                          Icon(Boxicons.bx_x, color: headerColor, size: 18.r),
                      label: Text(
                        config.parameters[index].toString(),
                        style: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: mainDark,
                        ),
                      ),
                      elevation: 1,
                      backgroundColor: appYellow,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                SpecialForm(
                  controller: paramController,
                  hint: "Parameter Declaration",
                  width: 170.w,
                  height: 40.h,
                ),
                SizedBox(height: 15.h),
                ElevatedButton(
                  onPressed: () {
                    String text = paramController.text.trim();

                    if (text.isEmpty) {
                      return;
                    }

                    setState(() => widget.config.parameters.add(text));

                    unFocus();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appYellow,
                    minimumSize: Size(60.w, 30.h),
                  ),
                  child: Text(
                    "Add",
                    style: context.textTheme.bodyLarge!
                        .copyWith(color: mainDark, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  "Return Type",
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: theme, fontWeight: FontWeight.w700),
                ),
                ReturnTypes(
                  key: returnKey,
                  initial: initial,
                ),
                SizedBox(height: 100.h),
                ElevatedButton(
                  onPressed: () {
                    config.name = nameController.text;
                    config.returnType = returnKey.currentState!.selected.name;
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appYellow,
                    minimumSize: Size(100.w, 35.h),
                  ),
                  child: Text(
                    widget.create ? "Create" : "Apply",
                    style: context.textTheme.bodyLarge!
                        .copyWith(color: mainDark, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
