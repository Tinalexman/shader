import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/components/drawable.dart';
import 'package:shade/components/shape_manager.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/widgets.dart';

class SceneTool {
  final IconData data;
  final Color color;
  final String name;
  final VoidCallback onTap;

  const SceneTool({
    required this.data,
    required this.color,
    required this.name,
    required this.onTap,
  });
}

class BottomItem extends ConsumerStatefulWidget {
  final SceneTool tool;
  final int index;

  const BottomItem({
    super.key,
    required this.tool,
    required this.index,
  });

  @override
  ConsumerState<BottomItem> createState() => _BottomItemState();
}

class _BottomItemState extends ConsumerState<BottomItem>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController controller;
  late Animation<Offset> textSlide;
  late Animation<double> iconScale;
  late Animation<Color?> colorTween;

  bool selected = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    iconScale = Tween<double>(end: 1.5, begin: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    textSlide = Tween<Offset>(
      end: const Offset(0.0, 2.5),
      begin: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    colorTween = ColorTween(
      end: Colors.transparent,
      begin: appYellow.withOpacity(0.2),
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bool selected = ref.watch(activeSceneEditorToolIndex) == widget.index;
    if (selected) {
      controller.forward();
    } else {
      controller.reverse();
    }

    return GestureDetector(
      onTap: widget.tool.onTap,
      child: AnimatedBuilder(
        builder: (context, child) => Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: colorTween.value,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.scale(
                scale: iconScale.value,
                child: Icon(
                  widget.tool.data,
                  size: 20.r,
                  color: widget.tool.color,
                ),
              ),
              SlideTransition(
                position: textSlide,
                child: Text(
                  widget.tool.name,
                  style: context.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        animation: controller,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AddShape extends StatelessWidget {
  final Function onAdd;

  const AddShape({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    List<ShapeType> shapes = ShapeType.values;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Add Shape",
              style: context.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5.h),
            Text(
              'Add a new shape to your masterpiece',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            SizedBox(height: 50.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 50.h,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () {
                    onAdd(shapes[index]);
                    Navigator.pop(context);
                  },
                  child: _ShapeContainer(type: shapes[index]),
                ),
                itemCount: shapes.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ShapeContainer extends StatelessWidget {
  final ShapeType type;

  const _ShapeContainer({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        color: appYellow.withOpacity(0.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            type.name.capitalized,
            style: context.textTheme.bodySmall!.copyWith(
              color: theme,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

class EditShape extends ConsumerStatefulWidget {
  final VoidCallback onEdit;

  const EditShape({
    super.key,
    required this.onEdit,
  });

  @override
  ConsumerState<EditShape> createState() => _EditShapeState();
}

class _EditShapeState extends ConsumerState<EditShape> {
  final TextEditingController one = TextEditingController(),
      two = TextEditingController();

  late Drawable activeDrawable;

  @override
  void initState() {
    super.initState();

    int active = ref.read(activeShapeIndex);
    if (active == -1) return;
    Drawable drawable = ref.read(shapeManagerProvider).root[active];

    if (drawable is Sphere) {
      one.text = drawable.radius.toString();
    } else if (drawable is Cube) {
      one.text = drawable.size.toString();
    } else if (drawable is Plane) {
      one.text = drawable.distance.toString();
    } else if (drawable is Cylinder) {
      one.text = drawable.radius.toString();
      two.text = drawable.height.toString();
    } else if (drawable is Capsule) {
      one.text = drawable.radius.toString();
      two.text = drawable.capHeight.toString();
    } else if (drawable is Torus) {
      one.text = drawable.innerRadius.toString();
      two.text = drawable.outerRadius.toString();
    } else if (drawable is Cone) {
      one.text = drawable.radius.toString();
      two.text = drawable.height.toString();
    }

    activeDrawable = drawable;
  }

  @override
  void dispose() {
    one.dispose();
    two.dispose();
    super.dispose();
  }

  Widget get child {
    if (activeDrawable is Sphere ||
        activeDrawable is Plane ||
        activeDrawable is Cube) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Value",
            style: context.textTheme.bodySmall,
          ),
          SizedBox(height: 5.h),
          SpecialForm(
            controller: one,
            width: 60.w,
            height: 40.h,
          ),
        ],
      );
    } else if (activeDrawable is Cylinder ||
        activeDrawable is Cone ||
        activeDrawable is Torus ||
        activeDrawable is Capsule) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Value 1",
            style: context.textTheme.bodySmall,
          ),
          SizedBox(height: 5.h),
          SpecialForm(
            controller: one,
            width: 60.w,
            height: 40.h,
          ),
          SizedBox(height: 10.h),
          Text(
            "Value 2",
            style: context.textTheme.bodySmall,
          ),
          SizedBox(height: 5.h),
          SpecialForm(
            controller: two,
            width: 60.w,
            height: 40.h,
          ),
        ],
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Edit Shape",
              style: context.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5.h),
            Text(
              'Edit a drawable from your masterpiece',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            SizedBox(height: 50.h),
            Text(
              "Name: ${activeDrawable.name}",
              style: context.textTheme.bodyLarge,
            ),
            SizedBox(height: 5.h),
            Text(
              "ID: ${activeDrawable.id}",
              style: context.textTheme.bodyLarge,
            ),
            SizedBox(height: 10.h),
            child,
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                widget.onEdit();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appYellow,
                minimumSize: Size(100.w, 40.h),
                maximumSize: Size(100.w, 40.h),
                elevation: 1.0,
              ),
              child: Text(
                "Apply",
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: headerColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShapeTree extends ConsumerWidget {
  const ShapeTree({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Drawable> drawables = ref.read(shapeManagerProvider).root;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Shape Tree",
              style: context.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5.h),
            Text(
              'View all your current drawables',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            SizedBox(height: 50.h),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, __) => SizedBox(height: 20.h),
                itemBuilder: (_, index) => _TreeValue(
                  drawable: drawables[index],
                  selected: ref.watch(activeShapeIndex) == index,
                  onDelete: () => drawables.removeAt(index),
                  onTap: () =>
                      ref.watch(activeShapeIndex.notifier).state = index,
                ),
                itemCount: drawables.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TreeValue extends StatelessWidget {
  final Drawable drawable;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TreeValue({
    super.key,
    required this.onTap,
    required this.drawable,
    required this.selected,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 390.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: selected ? appYellow : appYellow.withOpacity(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name:",
              style: context.textTheme.bodySmall!
                  .copyWith(color: selected ? headerColor : null),
            ),
            Text(
              drawable.name,
              style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected ? headerColor : null),
            ),
            SizedBox(height: 10.h),
            Text(
              "ID: ${drawable.id}",
              style: context.textTheme.bodyMedium!
                  .copyWith(color: selected ? headerColor : null),
            ),
          ],
        ),
      ),
    );
  }
}
