import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
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
  late TextEditingController nameController;
  late Holder initial;
  final GlobalKey<ReturnTypesState> returnKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.config.name);
    initial = Holder(name: widget.config.returnType);
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              Text(
                "Name",
                style: context.textTheme.bodyMedium!.copyWith(color: theme),
              ),
              SpecialForm(
                controller: nameController,
                width: 250.w,
                height: 35.h,
                fillColor: Colors.transparent,
                borderColor: neutral3,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Return Type",
                style: context.textTheme.bodySmall!.copyWith(color: theme),
              ),
              ReturnTypes(
                key: returnKey,
                initial: initial,
              )
            ],
          ),
        ),
      ),
    );
  }
}
