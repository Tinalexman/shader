import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/components/shape_manager.dart' show Sphere, Plane, Shape;
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/theme.dart';

class FactoryPage extends ConsumerStatefulWidget {
  const FactoryPage({super.key});

  @override
  ConsumerState<FactoryPage> createState() => _FactoryPageState();
}

class _FactoryPageState extends ConsumerState<FactoryPage>
    with TickerProviderStateMixin {
  late AnimationController _toolBarController, _propertiesController;
  late Animation<double> _toolBarAnimation, _propertiesAnimation;
  bool _expandedToolbar = false,
      _expandedProperties = false;

  int toolBarContentIndex = 0,
      propertiesContentIndex = 0;
  final Map<int, Widget> toolbarContents = {},
      propertiesContent = {};

  @override
  void initState() {
    super.initState();

    _toolBarController =
        AnimationController(
            vsync: this, duration: const Duration(milliseconds: 500));
    _toolBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _toolBarController, curve: Curves.easeIn));

    _propertiesController =
        AnimationController(
            vsync: this, duration: const Duration(milliseconds: 500));
    _propertiesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _propertiesController, curve: Curves.easeIn));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (toolbarContents.isEmpty) {
      toolbarContents.addAll({
        0: Container(
          width: 200.h,
          height: 390.w,
          color: Colors.black45,
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Text(
                "Toolbar",
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20.h),
              ListTile(
                onTap: () => setState(() => toolBarContentIndex = 1),
                leading: const Icon(Icons.format_shapes_rounded),
                title: Text(
                  "Add Shape",
                  style: context.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
              )
            ],
          ),
        ),
        1: Container(
          width: 200.h,
          height: 390.w,
          color: Colors.black45,
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(5.r),
                  child: GestureDetector(
                    onTap: () => setState(() => toolBarContentIndex = 0),
                    child: const Icon(Icons.chevron_left_rounded),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    toolBarContentIndex = 0;
                    _expandedToolbar = false;
                  });
                  ref
                      .watch(shapesProvider.notifier)
                      .state
                      .add(Sphere());
                  _toolBarController.reverse();
                },
                title: Text(
                  "Sphere",
                  style: context.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    toolBarContentIndex = 0;
                    _expandedToolbar = false;
                  });
                  ref
                      .watch(shapesProvider.notifier)
                      .state
                      .add(Plane());
                  _toolBarController.reverse();
                },
                title: Text(
                  "Plane",
                  style: context.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        )
      });
    }

    // if(propertiesContent.isEmpty) {
    //   propertiesContent.addAll({
    //     0: Container(
    //       width: 300.h,
    //       height: 390.w,
    //       color: Colors.black45,
    //       child: Column(
    //         children: [
    //           SizedBox(height: 15.h),
    //           Text(
    //             "Properties",
    //             style: context.textTheme.bodyLarge!
    //                 .copyWith(fontWeight: FontWeight.w600),
    //           ),
    //           SizedBox(height: 20.h),
    //
    //         ],
    //       ),
    //     ),
    //   });
    // }
  }

  @override
  void dispose() {
    _propertiesController.dispose();
    _toolBarController.dispose();
    super.dispose();
  }


  Widget getSphereProperties() {
    Sphere sphere = ref
        .watch(shapesProvider)
        .shape as Sphere;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name: ${sphere.getName()}"),
        Text("Radius: ${sphere.radius}", style: context.textTheme.bodyMedium)
      ],
    );
  }


  Widget getShape() {
    //return getSphereProperties();
    return InputKeypad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 815.h,
          width: 390.w,
          child: Stack(
            children: [
              GestureDetector(
                child: Container(
                  color: appYellow,
                  height: 815.h,
                  width: 390.w,
                ),
              ),
              SizedBox(
                height: 815.h,
                width: 390.w,
                child: Stack(
                  children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: SizeTransition(
                        sizeFactor: _toolBarAnimation,
                        child: toolbarContents[toolBarContentIndex],
                      ),
                    ),
                    Visibility(
                      visible: toolBarContentIndex == 0,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Padding(
                            padding: EdgeInsets.all(5.r),
                            child: GestureDetector(
                              onTap: () {
                                setState(
                                        () =>
                                    _expandedToolbar = !_expandedToolbar);
                                if (_expandedToolbar) {
                                  _toolBarController.forward();
                                } else {
                                  _toolBarController.reverse();
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.r),
                                child: ColoredBox(
                                  color: Colors.redAccent,
                                  child: Icon(
                                    !_expandedToolbar
                                        ? Icons.expand_less_rounded
                                        : Icons.expand_more_rounded,
                                    size: 32.r,
                                    color: mainDark,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: SizeTransition(
                          sizeFactor: _propertiesAnimation,
                          //child: propertiesContent[propertiesContentIndex],
                          child: Container(
                            width: 300.h,
                            height: 390.w,
                            color: Colors.black45,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15.h),
                                  Center(
                                    child: Text(
                                      "Properties",
                                      style: context.textTheme.bodyLarge!
                                          .copyWith(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  getShape()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5.r,
                      right: 5.r,
                      child: Visibility(
                        visible: propertiesContentIndex == 0,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Padding(
                              padding: EdgeInsets.all(5.r),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() =>
                                  _expandedProperties =
                                  !_expandedProperties);
                                  if (_expandedProperties) {
                                    _propertiesController.forward();
                                  } else {
                                    _propertiesController.reverse();
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.r),
                                  child: ColoredBox(
                                    color: Colors.redAccent,
                                    child: Icon(
                                      _expandedProperties
                                          ? Icons.expand_less_rounded
                                          : Icons.expand_more_rounded,
                                      size: 32.r,
                                      color: mainDark,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class InputKeypad extends StatelessWidget {
  const InputKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.h,
      height: 290.w,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 30),
        itemBuilder: (_, index) {
          return GestureDetector(
            child: SizedBox(
              width: 50.h,
              // height: 10.w,
              child: Center(
                child: Text("${index + 1}", style: context.textTheme.bodyMedium),
              ),
            ),
          );
        },
        itemCount: 12,),
    );
  }
}
