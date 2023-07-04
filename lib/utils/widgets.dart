import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/components/math.dart';
import 'package:shade/components/sdf.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/functions.dart';
import 'package:shade/utils/providers.dart';
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

  String? getValue() => _selection;

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
  String documentation;
  String declaration;
  List<String> parameters;
  String returnType;
  String returnVariable;
  bool transparent;

  final bool fixed;

  final Function? onCodeChange;

  CodeBlockConfig({
    this.name = "new",
    this.onCodeChange,
    this.documentation = "",
    this.declaration = "",
    this.body = "",
    this.returnVariable = "",
    this.fixed = false,
    this.transparent = false,
    this.parameters = const [],
    this.returnType = "void",
  });

  factory CodeBlockConfig.fromJson(Map<String, dynamic> map) => CodeBlockConfig(
        name: map['name'],
        returnVariable: map['returnVariable'],
        parameters: map["parameters"],
        returnType: map['returnType'],
        body: map['body'],
        transparent: map['transparent'],
        declaration: map['declaration'],
        documentation: map['documentation'],
        fixed: map['fixed'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'returnVariable': returnVariable,
        'returnType': returnType,
        'parameters': parameters,
        'body': body,
        'transparent': transparent,
        'fixed': fixed,
        'declaration': declaration,
        'documentation': documentation,
      };

  String getCode() => _functionCode();

  String _functionCode() {
    StringBuffer buffer = StringBuffer();

    buffer.write("$returnType $name(");

    for (int i = 0; i < parameters.length; ++i) {
      buffer.write(parameters[i]);
      if (i != parameters.length - 1) {
        buffer.write(", ");
      }
    }

    buffer.write(")\n{\n");

    if (returnType != 'void') {
      String expression = "";
      if (returnType == "float") {
        expression = "\tfloat $returnVariable = 0.0;\n";
      } else if (returnType == "vec2") {
        expression = "\tvec2 $returnVariable = vec2(0.0);\n";
      } else if (returnType == "vec3") {
        expression = "\tvec3 $returnVariable = vec3(0.0);\n";
      } else if (returnType == "vec4") {
        expression = "\tvec4 $returnVariable = vec4(0.0);\n";
      } else if (returnType == "int") {
        expression = "\tint $returnVariable = 0;\n";
      }

      buffer.write(expression);
    }

    List<String> lines = body.split('\n');
    for (String line in lines) {
      buffer.write("\t$line\n");
    }

    if (returnType != "void" && returnVariable.isNotEmpty) {
      buffer.write("\treturn $returnVariable;");
    }

    buffer.write("\n}");

    return buffer.toString();
  }
}

class CodeBlock extends ConsumerStatefulWidget {
  final CodeBlockConfig config;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final Color? color;
  final bool disable;

  const CodeBlock({
    super.key,
    this.disable = false,
    required this.config,
    this.color,
    this.onDelete,
    this.onEdit,
  });

  @override
  ConsumerState<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends ConsumerState<CodeBlock> {
  late TextEditingController _controller;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.config.body);
    _color = widget.color ??
        (ref.read(randomBlockColorProvider)
            ? randomColor()
            : ref.read(fixedCodeBlockColorProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getCurrentWord() {
    String text = _controller.text;
    int cursor = _controller.selection.baseOffset;

    RegExp wordMatcher = RegExp(r'\w+');
    List<String?> words =
        wordMatcher.allMatches(text).map((e) => e.group(0)).toList();

    for (String? word in words) {
      if (cursor >= text.indexOf(word!) &&
          cursor <= text.indexOf(word) + word.length) {
        return word;
      }
    }

    return '';
  }

  void showDocumentation(CodeBlockConfig config) {
    unFocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: mainDark,
      builder: (context) => SizedBox(
        height: 250.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Text(
                config.name,
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w700, color: theme),
              ),
              Text(
                config.parameters.isEmpty
                    ? ""
                    : "Parameter${config.parameters.length == 1 ? "" : "s"}: ${config.parameters}",
                style: context.textTheme.bodyMedium!.copyWith(color: theme),
              ),
              if (config.returnType != "void" &&
                  config.returnVariable.isNotEmpty)
                Text(
                  "Return: ${config.returnType} ${config.returnVariable}",
                  style: context.textTheme.bodyMedium!.copyWith(color: theme),
                ),
              SizedBox(height: 50.h),
              Text(
                config.documentation,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium!.copyWith(color: theme),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      padding: EdgeInsets.only(right: 10.w, top: 5.h, bottom: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _color, width: 2.0),
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
                    SizedBox(
                      width: 180.w,
                      child: Text(
                        "${widget.config.name}: ${widget.config.returnType}",
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w700, color: _color),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            String word = getCurrentWord();
                            CodeBlockConfig config =
                                getBlock(word) ?? widget.config;
                            showDocumentation(config);
                          },
                          splashRadius: 0.01,
                          icon: Icon(Icons.question_mark_rounded,
                              color: _color, size: 16.r),
                        ),
                        if (!widget.config.fixed)
                          IconButton(
                            onPressed: widget.onEdit,
                            splashRadius: 0.01,
                            icon: Icon(Icons.edit_rounded,
                                color: _color, size: 16.r),
                          ),
                        if (!widget.config.fixed)
                          IconButton(
                            onPressed: widget.onDelete,
                            splashRadius: 0.01,
                            icon:
                                Icon(Boxicons.bx_x, color: _color, size: 20.r),
                          ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        if (widget.config.parameters.isNotEmpty)
                          Text(
                            "Parameters",
                            style: context.textTheme.bodyMedium!.copyWith(
                                color: _color, fontWeight: FontWeight.w600),
                          ),
                        if (widget.config.parameters.isNotEmpty)
                          SizedBox(height: 2.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.config.parameters.length,
                            (index) => Text(
                              "- ${widget.config.parameters[index]}",
                              style: context.textTheme.bodyMedium!.copyWith(
                                  color: _color, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.config.returnType != 'void')
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Return Value",
                            style: context.textTheme.bodyMedium!.copyWith(
                                color: _color, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${widget.config.returnType} ${widget.config.returnVariable}",
                            style: context.textTheme.bodyMedium!.copyWith(
                                color: _color, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Text(
              "Code",
              style: context.textTheme.bodyMedium!
                  .copyWith(color: _color, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 2.h),
          CodeFragment(
            numberWidth: 25.w,
            controller: _controller,
            disabled: widget.disable,
            onChanged: (val) {
              widget.config.body = val;
              setState(() {});
            },
            transparent: widget.config.transparent,
          )
        ],
      ),
    );
  }
}

class MainCodeBlock extends ConsumerStatefulWidget {
  final CodeBlockConfig config;
  final TextEditingController controller;

  const MainCodeBlock({
    super.key,
    required this.config,
    required this.controller,
  });

  @override
  ConsumerState<MainCodeBlock> createState() => _MainCodeBlockState();
}

class _MainCodeBlockState extends ConsumerState<MainCodeBlock> {
  late Color color;
  late TextEditingController local;

  @override
  void initState() {
    super.initState();
    color = ref.read(randomBlockColorProvider)
        ? randomColor()
        : ref.read(fixedCodeBlockColorProvider);

    String code = widget.controller.text;
    int mainIndex = code.indexOf("void main()");
    String declaration = code.substring(0, mainIndex - 2);
    local = TextEditingController(text: declaration);
    widget.config.declaration = declaration;

    int start = code.indexOf("{", mainIndex);
    int end = code.lastIndexOf("}");
    String content = code.substring(start + 6, end - 1);
    widget.controller.text = content;
    widget.config.body = content;
  }

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
              disabled: false,
              onChanged: (val) {
                widget.config.declaration = val;
                setState(() {});
              },
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
                disabled: false,
                controller: widget.controller,
                onChanged: (val) {
                  widget.config.onCodeChange!(val);
                  setState(() {});
                },
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
  final bool disabled;
  final bool disableNumbering;

  const CodeFragment({
    super.key,
    this.disableNumbering = false,
    this.transparent = false,
    this.numberWidth,
    required this.disabled,
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
          disabled: widget.disabled,
          onChanged: (val) {
            widget.onChanged(val);
            setState(() {});
          },
        )
      ],
    );
  }
}

class _Fragment extends StatelessWidget {
  final TextEditingController controller;
  final bool transparent;
  final bool disabled;
  final Function onChanged;

  const _Fragment({
    Key? key,
    required this.disabled,
    required this.controller,
    required this.transparent,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 5.w),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.multiline,
          minLines: null,
          maxLines: null,
          readOnly: disabled,
          cursorColor: appYellow,
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.top,
          textCapitalization: TextCapitalization.none,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          textInputAction: TextInputAction.newline,
          style: context.textTheme.bodyMedium!.copyWith(color: theme),
          decoration: InputDecoration(
            fillColor:
                transparent ? Colors.transparent : search.withOpacity(0.1),
            filled: true,
            contentPadding: EdgeInsets.all(5.r),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onChanged: (val) => onChanged(val),
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
  final String? initial;

  const ReturnTypes({super.key, this.initial});

  @override
  State<ReturnTypes> createState() => ReturnTypesState();
}

class ReturnTypesState extends State<ReturnTypes> {
  late Holder selected;
  late List<Holder> _types;

  @override
  void initState() {
    super.initState();
    _types = returnTypes;
    selected = _search(widget.initial) ?? _types[0];
    selected.selected = true;
  }

  Holder? _search(String? name) {
    if (name == null) {
      return null;
    }

    for (Holder holder in _types) {
      if (holder.name == name) {
        return holder;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 5.h,
      children: List.generate(
        _types.length,
        (index) => GestureDetector(
          onTap: () => setState(() {
            selected.selected = false;
            selected = _types[index];
            selected.selected = true;
          }),
          child: Chip(
            label: Text(
              _types[index].name,
              style: context.textTheme.bodyMedium!.copyWith(
                  color: _types[index].selected ? headerColor : neutral3),
            ),
            elevation: _types[index].selected ? 1 : 0,
            backgroundColor: _types[index].selected ? appYellow : mainDark,
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

class Vector2Input extends StatefulWidget {
  final String label;
  final bool fixed;
  final Vector2 vector;
  final double minValue;
  final double maxValue;

  const Vector2Input({
    super.key,
    this.fixed = false,
    this.minValue = -100.0,
    this.maxValue = 100.0,
    required this.vector,
    required this.label,
  });

  @override
  State<Vector2Input> createState() => _Vector2InputState();
}

class _Vector2InputState extends State<Vector2Input> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers.add(TextEditingController(text: "${widget.vector.x}"));
    _controllers.add(TextEditingController(text: "${widget.vector.y}"));
  }

  @override
  void dispose() {
    _controllers[1].dispose();
    _controllers[0].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${widget.label}:",
          style: context.textTheme.bodyMedium!.copyWith(color: theme),
        ),
        SizedBox(
          width: 20.w,
        ),
        SizedBox(
          width: 200.w,
          height: 30.h,
          child: ListView.separated(
            itemBuilder: (_, index) => Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  index == 0 ? 'X' : "Y",
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: index == 0 ? percentRed : percentGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                SpecialForm(
                  controller: _controllers[index],
                  width: 70.w,
                  height: 30.h,
                  readOnly: widget.fixed,
                  type: TextInputType.number,
                  onChange: (val) {
                    Vector2 vector = widget.vector;
                    double number = double.parse(val);

                    if (number < widget.minValue) {
                      number = widget.minValue;
                    } else if (number > widget.maxValue) {
                      number = widget.maxValue;
                    }

                    if (index == 0) {
                      vector.x = number;
                    } else {
                      vector.y = number;
                    }

                    vector.hasChanged = true;
                  },
                ),
              ],
            ),
            separatorBuilder: (_, __) => SizedBox(
              width: 30.w,
            ),
            itemCount: 2,
            scrollDirection: Axis.horizontal,
          ),
        )
      ],
    );
  }
}

class Vector3Input extends StatefulWidget {
  final String label;
  final bool fixed;
  final Vector3 vector;
  final double minValue;
  final double maxValue;

  const Vector3Input({
    super.key,
    this.fixed = false,
    this.minValue = -100.0,
    this.maxValue = 100.0,
    required this.vector,
    required this.label,
  });

  @override
  State<Vector3Input> createState() => _Vector3InputState();
}

class _Vector3InputState extends State<Vector3Input> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers.add(TextEditingController(text: "${widget.vector.x}"));
    _controllers.add(TextEditingController(text: "${widget.vector.y}"));
    _controllers.add(TextEditingController(text: "${widget.vector.z}"));
  }

  @override
  void dispose() {
    _controllers[2].dispose();
    _controllers[1].dispose();
    _controllers[0].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${widget.label}:",
          style: context.textTheme.bodyMedium!.copyWith(color: theme),
        ),
        SizedBox(
          width: 20.w,
        ),
        SizedBox(
          width: 290.w,
          height: 30.h,
          child: ListView.separated(
            itemBuilder: (_, index) => Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  index == 0
                      ? 'X'
                      : (index == 1)
                          ? "Y"
                          : "Z",
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: index == 0
                        ? percentRed
                        : (index == 1)
                            ? percentGreen
                            : headerBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                SpecialForm(
                  controller: _controllers[index],
                  width: 70.w,
                  height: 30.h,
                  readOnly: widget.fixed,
                  type: TextInputType.number,
                  onChange: (val) {
                    Vector3 vector = widget.vector;
                    double number = double.parse(val);

                    if (number < widget.minValue) {
                      number = widget.minValue;
                    } else if (number > widget.maxValue) {
                      number = widget.maxValue;
                    }

                    if (index == 0) {
                      vector.x = number;
                    } else if (index == 1) {
                      vector.y = number;
                    } else {
                      vector.z = number;
                    }

                    vector.hasChanged = true;
                  },
                ),
              ],
            ),
            separatorBuilder: (_, __) => SizedBox(
              width: 20.w,
            ),
            itemCount: 3,
            scrollDirection: Axis.horizontal,
          ),
        )
      ],
    );
  }
}

class CodeView extends StatelessWidget {
  const CodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return HighlightView(
      "",
      language: 'glsl',
      theme: githubTheme,
      textStyle: context.textTheme.bodyMedium!.copyWith(color: theme),
    );
  }
}

class Bullet extends StatelessWidget {
  final Color color;

  const Bullet({Key? key, this.color = neu}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: 5.r,
        height: 5.r,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
