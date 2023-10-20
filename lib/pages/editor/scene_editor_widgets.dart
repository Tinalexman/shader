import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/components/shape_manager.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/providers.dart';

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
                itemBuilder: (_, index) => _ShapeContainer(type: shapes[index]),
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
          color: appYellow.withOpacity(0.2)),
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

class EditShape extends StatelessWidget {
  const EditShape({super.key});

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
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 50.h,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemBuilder: (_, index) => _ShapeContainer(type: shapes[index]),
                itemCount: shapes.length,
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

  const _TreeValue({
    super.key,
    required this.onTap,
    required this.drawable,
    required this.selected,
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
