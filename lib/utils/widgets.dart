import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/functions.dart';
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
  State<ComboBox> createState() => ComboBoxState();
}

class ComboBoxState extends State<ComboBox> {
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
            setState(() => _selection = item);
          }
        },
      ),
    );
  }
}

class CodeBlockConfig {
  String name;
  String body;
  List<String> parameters;
  String returnType;
  bool transparent;

  final Function onCodeChange;

  CodeBlockConfig({
    required this.name,
    required this.onCodeChange,
    this.body = "",
    this.transparent = false,
    this.parameters = const [],
    this.returnType = "void",
  });
}

class CodeBlock extends StatefulWidget {
  final CodeBlockConfig config;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CodeBlock({
    super.key,
    required this.config,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  late TextEditingController controller;
  late Color color;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.config.body);
    color = randomColor();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color, width: 2.0),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.config.name}: ${widget.config.returnType}",
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w700, color: color),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: widget.onEdit,
                          child: Icon(Icons.edit_rounded, color: color, size: 16.r),
                        ),
                        SizedBox(width: 15.w,),
                        GestureDetector(
                          onTap: widget.onDelete,
                          child: Icon(Boxicons.bx_x, color: color, size: 20.r),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                  "Parameters",
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: color, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 2.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.config.parameters.length,
                    (index) => Text(
                      "- ${widget.config.parameters[index]}",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: color, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Text(
              "Code",
              style: context.textTheme.bodyMedium!
                  .copyWith(color: color, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 2.h),
          CodeFragment(
            numberWidth: 25.w,
            controller: controller,
            onChanged: (val) {
              widget.config.onCodeChange(val);
              setState(() {});
            },
            transparent: widget.config.transparent,
          )
        ],
      ),
    );
  }
}

class MainCodeBlock extends StatefulWidget {
  final CodeBlockConfig config;
  final TextEditingController controller;

  const MainCodeBlock({
    super.key,
    required this.config,
    required this.controller,
  });

  @override
  State<MainCodeBlock> createState() => MainCodeBlockState();
}

class MainCodeBlockState extends State<MainCodeBlock> {
  late Color color;
  late TextEditingController local;

  @override
  void initState() {
    super.initState();
    color = randomColor();

    String code = widget.controller.text;
    int mainIndex = code.indexOf("void main()");
    String declaration = code.substring(0, mainIndex);
    local = TextEditingController(text: declaration);

    int start = code.indexOf("{", mainIndex);
    int end = code.lastIndexOf("}");
    String content = code.substring(start + 1, end);
    widget.controller.text = content;
  }

  String getFullCode() => "${local.text}\n\n {\n\t${widget.controller.text}}";

  @override
  void dispose() {
    local.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color, width: 2.0),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "${widget.config.name}: ${widget.config.returnType}",
                    style: context.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w700, color: color),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Declarations",
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: color, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: CodeFragment(
              disableNumbering: true,
              onChanged: (val) => widget.config.onCodeChange(val),
              transparent: widget.config.transparent,
              controller: local,
            ),
          ),
          SizedBox(height: 20.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: Text(
                  "Code",
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: color, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 2.h),
              CodeFragment(
                numberWidth: 25.w,
                controller: widget.controller,
                onChanged: (val) => widget.config.onCodeChange(val),
                transparent: widget.config.transparent,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CodeFragment extends StatefulWidget {
  final double? numberWidth;
  final TextEditingController controller;
  final Function onChanged;
  final bool transparent;

  final bool disableNumbering;

  const CodeFragment({
    super.key,
    this.disableNumbering = false,
    this.transparent = false,
    this.numberWidth,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<CodeFragment> createState() => _CodeFragmentState();
}

class _CodeFragmentState extends State<CodeFragment> {
  @override
  Widget build(BuildContext context) {
    int numLines = widget.controller.text.split("\n").length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.disableNumbering)
          SizedBox(
            width: widget.numberWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: numLines > 1 ? 5.h : 10.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: lineNumbers(
                  context,
                  widget.controller,
                  style: context.textTheme.bodyMedium!.copyWith(color: theme),
                ),
              ),
            ),
          ),
        _Fragment(
          controller: widget.controller,
          transparent: widget.transparent,
          onChanged: (val) {
            widget.onChanged(val);
            setState(() {});
          },
        )
      ],
    );
  }
}

class _Fragment extends StatefulWidget {
  final TextEditingController controller;
  final bool transparent;
  final Function onChanged;

  const _Fragment({
    super.key,
    required this.controller,
    required this.transparent,
    required this.onChanged,
  });

  @override
  State<_Fragment> createState() => _FragmentState();
}

class _FragmentState extends State<_Fragment> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 5.w),
        child: TextField(
          controller: widget.controller,
          keyboardType: TextInputType.multiline,
          minLines: null,
          maxLines: null,
          cursorColor: appYellow,
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.top,
          textCapitalization: TextCapitalization.none,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          textInputAction: TextInputAction.newline,
          style: context.textTheme.bodyMedium!.copyWith(color: theme),
          decoration: InputDecoration(
            fillColor: widget.transparent
                ? Colors.transparent
                : search.withOpacity(0.1),
            filled: true,
            contentPadding: EdgeInsets.all(5.r),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onChanged: (val) => widget.onChanged(val),
        ),
      ),
    );
  }
}

class SpecialForm extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final String? hint;
  final Color? fillColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final bool obscure;
  final bool autoValidate;
  final FocusNode? focus;
  final bool autoFocus;
  final Function? onChange;
  final Function? onActionPressed;
  final Function? onValidate;
  final Function? onSave;
  final BorderRadius? radius;
  final TextEditingController controller;
  final TextInputType type;
  final TextInputAction action;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final bool readOnly;
  final int maxLines;
  final double width;
  final double height;

  const SpecialForm({
    Key? key,
    required this.controller,
    required this.width,
    required this.height,
    this.fillColor,
    this.borderColor,
    this.padding,
    this.hintStyle,
    this.focus,
    this.autoFocus = false,
    this.readOnly = false,
    this.obscure = false,
    this.autoValidate = false,
    this.type = TextInputType.text,
    this.action = TextInputAction.none,
    this.onActionPressed,
    this.onChange,
    this.onValidate,
    this.style,
    this.onSave,
    this.radius,
    this.hint,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        style: style ?? context.textTheme.bodyMedium!.copyWith(color: theme),
        autovalidateMode:
        autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        maxLines: maxLines,
        focusNode: focus,
        autofocus: autoFocus,
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        textInputAction: action,
        readOnly: readOnly,
        onEditingComplete: () => onActionPressed!(controller.text),
        cursorColor: appYellow,
        decoration: InputDecoration(
          errorMaxLines: 1,
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          fillColor: fillColor ?? Colors.transparent,
          filled: true,
          contentPadding:
          padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          prefixIcon: prefix,
          suffixIcon: suffix,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? border,
              )),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? border,
              )),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? border,
              )),
          hintText: hint,
          hintStyle: hintStyle ??
              Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(fontWeight: FontWeight.w200, color: theme),
        ),
        onChanged: (value) {
          if (onChange == null) return;
          onChange!(value);
        },
        validator: (value) {
          if (onValidate == null) return null;
          return onValidate!(value);
        },
        onSaved: (value) {
          if (onSave == null) return;
          onSave!(value);
        },
      ),
    );
  }
}


class ReturnTypes extends StatefulWidget {
  final Holder? initial;

  const ReturnTypes({super.key, this.initial});

  @override
  State<ReturnTypes> createState() => ReturnTypesState();
}

class ReturnTypesState extends State<ReturnTypes> {

  late Holder selected;
  late List<Holder> types;

  @override
  void initState() {
    super.initState();
    types = returnTypes;
    selected = widget.initial ?? types[0];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: List.generate(
        types.length,
            (index) => GestureDetector(
          onTap: () => setState(() => selected = types[index]),
          child: Chip(
            label: Text(types[index].name,
                style: context.textTheme.bodySmall!.copyWith(
                    fontSize: 10.sp,
                    color: types[index].selected
                        ? headerColor
                        : neutral3),
            ),
            elevation: types[index].selected ? 1 : 0,
            backgroundColor:
            types[index].selected ? appYellow : mainDark,
          ),
        ),
      ),
    );
  }
}
