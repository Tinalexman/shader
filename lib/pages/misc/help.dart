import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/components/sdf.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';
import 'package:shade/utils/widgets.dart';

class HelpContent {
  final String header;
  final String description;
  final List<String> contents;
  final VoidCallback onClick;

  const HelpContent({
    required this.header,
    required this.contents,
    required this.description,
    required this.onClick,
  });
}

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  int current = 0;

  late List<HelpContent> _contents;

  @override
  void initState() {
    super.initState();
    _contents = [
      HelpContent(
        header: "Editor",
        description: "Learn all about Shade's code editor.",
        contents: ["Scene", "Code Blocks", "Basic Building Blocks: SDFs"],
        onClick: () =>
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const _EditorHelp(),
              ),
            ),
      ),
      HelpContent(
        header: "Preview",
        description: "Watch your shadings come to life in Shade's preview.",
        contents: ['Moving Around'],
        onClick: () =>
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const _PreviewHelp(),
              ),
            ),
      ),
    ];
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
                    onPageChanged: (index) => setState(() => current = index),
                    itemBuilder: (context, index) {
                      return Container(
                        height: 650.h,
                        width: 390.w,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: appYellow, width: 2.0),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _contents[index].header,
                              style: context.textTheme.headlineLarge!
                                  .copyWith(color: appYellow),
                            ),
                            Text(
                              _contents[index].description,
                              style: context.textTheme.bodyLarge!
                                  .copyWith(color: appYellow),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                _contents[index].contents.length,
                                    (pos) =>
                                    Text(
                                      "- ${_contents[index].contents[pos]}",
                                      style: context.textTheme.bodyMedium!
                                          .copyWith(color: appYellow),
                                    ),
                              ),
                            ),
                            SizedBox(height: 50.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                iconSize: 36.r,
                                icon: const Icon(Icons.chevron_right_rounded,
                                    color: appYellow),
                                onPressed: _contents[index].onClick,
                                splashColor: appYellow.withOpacity(0.5),
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
                          Bullet(
                              color: current == index ? appYellow : neutral3),
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

class _EditorHelp extends StatefulWidget {
  const _EditorHelp({super.key});

  @override
  State<_EditorHelp> createState() => _EditorHelpState();
}

class _EditorHelpState extends State<_EditorHelp> {
  late List<String> primitives;

  @override
  void initState() {
    super.initState();
    primitives = hgPrimitives.keys.toList();
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
          "Editor",
          style: context.textTheme.headlineSmall!.copyWith(color: theme),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "The Shade Code Editor is a versatile tool that will significantly make your 'Shade-ing' "
                      "adventure easier. So just sit back and have fun.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  "Scene",
                  style: context.textTheme.bodyLarge!
                      .copyWith(color: theme, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "A scene file is a configuration file that configures Shade and initializes "
                      "all necessary things. Unless explicitly specified in the settings, a new scene "
                      "file will be created whenever your open Shade. You can choose to auto-save your scene "
                      "after a certain duration. You can also instruct Shade to always load up the last scene"
                      " instead of creating a new scene each time.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Bullet(color: neutral4),
                    SizedBox(
                      width: 20.w,
                    ),
                    const Bullet(color: neutral4),
                    SizedBox(
                      width: 20.w,
                    ),
                    const Bullet(color: neutral4)
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Code Blocks",
                  style: context.textTheme.bodyLarge!
                      .copyWith(color: theme, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Code Blocks are simple, modular blocks of code. They remove distractions from the "
                      "other parts of your code and allow you to focus solely "
                      "on writing a single piece of code at a time. \n\nFor example, here is a function 'max' "
                      "that finds the maximum of two integers.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 30.h,
                ),
                CodeBlock(
                  color: appYellow,
                  config: CodeBlockConfig(
                      name: "getMax",
                      returnType: "int",
                      returnVariable: "max",
                      parameters: ["int first", "int second"],
                      body: "max = first > second ? first : second;",
                      documentation:
                      "Return the maximum between 'first' and 'second'."),
                  disable: true,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "Every code block looks distinct and makes your code look clean and portable.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "A code block can be broken down into several individual components. \n\n"
                      "In the top left corner is the name of the function and the type of data it "
                      "returns separated by a colon. The name of a code block and its return type must "
                      "be unique so as not to cause compile errors.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Wrap(
                  spacing: 5.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "The",
                      style: context.textTheme.bodyLarge!
                          .copyWith(color: theme, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.question_mark_rounded,
                        color: appYellow, size: 16.r),
                    Text(
                      "icon",
                      style: context.textTheme.bodyLarge!
                          .copyWith(color: theme, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "It is used to check the documentation of a function. By default, it returns "
                      "the documentation attached to this code block if defined. However, it can also return "
                      "documentation of another function on which the cursor is located if defined also.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Wrap(
                  spacing: 5.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "The",
                      style: context.textTheme.bodyLarge!
                          .copyWith(color: theme, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.edit_rounded, color: appYellow, size: 16.r),
                    Text(
                      "icon",
                      style: context.textTheme.bodyLarge!
                          .copyWith(color: theme, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "It is used to edit the name, parameters, return type or documentation of a function.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Wrap(
                  spacing: 5.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "The",
                      style: context.textTheme.bodyLarge!
                          .copyWith(color: theme, fontWeight: FontWeight.w600),
                    ),
                    Icon(Boxicons.bx_x, color: appYellow, size: 20.r),
                    Text(
                      "icon",
                      style: context.textTheme.bodyLarge!
                          .copyWith(color: theme, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "Obviously, this deletes a code block  :)",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Below the action icons are the list of parameters this function accepts and the value it returns. "
                      "The return value should be assigned a value otherwise, the function would return a "
                      "default value. If the return type of the function is 'void', then assigning a value to "
                      "the return value is not required.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Finally, we have the code section. This is where you write the actual contents of your function."
                      " Line numbers are automatically generated as you type unless disabled. The background color of "
                      "the code section can turned transparent if desired. \n\nFor example, this is a code block with"
                      " no parameters, no documentation and a transparent code background.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 20.h,
                ),
                CodeBlock(
                  color: appYellow,
                  config: CodeBlockConfig(name: "empty", transparent: true),
                  disable: true,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Lastly, every code block has a random color but a unique "
                      "color can be specified in the global settings.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Bullet(color: neutral4),
                    SizedBox(
                      width: 20.w,
                    ),
                    const Bullet(color: neutral4),
                    SizedBox(
                      width: 20.w,
                    ),
                    const Bullet(color: neutral4)
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Basic Building Blocks: SDFs",
                  style: context.textTheme.bodyLarge!
                      .copyWith(color: theme, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Signed Distance Functions, also called SDFs, are the main building blocks of Shade."
                      " They allow you to represent simple shapes as just pure functions. To "
                      "create any shape in Shade, you need tp have an SDF for it. SDFs are very "
                      "easy to make. Similar to Lego pieces, you can combine multiple SDFs together to "
                      "create another SDF.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(height: 15.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    primitives.length,
                        (index) =>
                        Text(
                          "- ${primitives[index]}",
                          style: context.textTheme.bodyLarge!
                              .copyWith(
                              color: theme, fontWeight: FontWeight.w700),
                        ),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Each of these SDFs can be combined in various ways, either by the 'join', 'remove' or "
                      "difference operators. In addition, they can also be rotated, translated, mirrored and repeated"
                      " in any of the three axes.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Inorder to create anything in Shade, you need to define two functions: 'build' and 'material'. "
                      "The build function is where your whole scene is constructed. This function takes in the current "
                      "position of the ray into consideration and it returns the smallest distance to the nearest object "
                      "in your scene. You also need to assign an ID to each shape in your scene as this would be needed "
                      "in the material function. Let us define our first SDF that joins a sphere and a plane.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 20.h,
                ),
                CodeBlock(
                  color: appYellow,
                  config: CodeBlockConfig(
                    name: "build",
                    returnVariable: 'data',
                    returnType: 'vec2',
                    parameters: ["vec3 pos"],
                    body: """
vec2 res = vec2(sphere(pos, 1.0), 1.0);
data = vec2(plane(pos, vec3(0.0, 1.0, 0.0), 1.0), 2.0);
data = join(res, data);""",
                    documentation:
                    "Construct a sphere of radius 1.0 and a plane and join them together.",
                  ),
                  disable: true,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Rendering any shape in Shade requires you to define two main functions: 'build' "
                      "and 'material'. If either or both functions are not defined, you will get a black "
                      "screen in your preview. Since we have defined the build function above, let's go "
                      "ahead and define the material function.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),

                SizedBox(
                  height: 20.h,
                ),
                CodeBlock(
                  color: appYellow,
                  config: CodeBlockConfig(
                    name: "material",
                    returnVariable: "color",
                    returnType: "vec3",
                    parameters: ['vec3 pos', 'float ID'],
                    body: """
switch( int(ID) ) {
  case 1: color = vec3(0.5); break;
  case 2: color = checkerboard(pos); break;
}""",
                    documentation:
                    "Gives the sphere a gray color and the plane, a checkerboard pattern.",
                  ),
                  disable: true,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "The material function takes in two parameters: the current 'position' of the ray and the 'ID' of "
                      "the object it intersected. The color of the object is then assigned based on its ID. Similarly, "
                      "texturing an object also happens in the material function.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "As you can see, SDFs are very powerful and simple to use. Feel free to try out various combinations"
                  " of SDFs. Your imagination is your only limit.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),


                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Bullet(color: neutral4),
                    SizedBox(
                      width: 20.w,
                    ),
                    const Bullet(color: neutral4),
                    SizedBox(
                      width: 20.w,
                    ),
                    const Bullet(color: neutral4)
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewHelp extends StatelessWidget {
  const _PreviewHelp({super.key});

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
          "Preview",
          style: context.textTheme.headlineSmall!.copyWith(color: theme),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Shade's Preview is where all your creativity gets showcased. So what are you waiting for? "
                      "Start Shading.",
                  style: context.textTheme.bodyLarge!.copyWith(color: theme),
                ),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
