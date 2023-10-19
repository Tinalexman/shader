import 'package:shade/utils/constants.dart';
import 'package:shade/components/math.dart';

mixin Drawable {
  String get name;

  int get id;
}

class ShapeManager {
  static int drawablesCount = 0;
  static const int groupIDMultiplier = 1000;
  static const int defaultMaterial = -1;

  late List<Drawable> _root;

  List<Drawable> get root => _root;

  ShapeManager() {
    _root = [
      Group(
        first: Sphere(materialCode: 1),
        second: Plane(materialCode: 2),
        operation: Operation.join,
      ),
    ];
  }


  void add(Drawable drawable) => _root.add(drawable);
  void remove(Drawable drawable) => _root.remove(drawable);
}

abstract class Shape with Drawable {
  @override
  late int id;

  late int material;

  late Vector3 position, rotation, scale;

  @override
  late String name;

  Shape({
    required String shapeName,
    int? materialCode
  }) {
    id = ShapeManager.drawablesCount++;
    material = materialCode ?? ShapeManager.defaultMaterial;
    name = "$shapeName$id";
    position = Vector3();
    rotation = Vector3();
    scale = Vector3.value(1);
  }
}

class Group with Drawable {
  late Drawable first, second;
  late Operation operation;

  Group({
    required this.first,
    required this.second,
    required this.operation,
  });

  @override
  int get id => first.id * ShapeManager.groupIDMultiplier + second.id;

  @override
  String get name => "${first.name}${first.id}${second.name}${second.id}";
}

class Sphere extends Shape {
  double radius;

  Sphere({
    this.radius = 1.0,
    super.shapeName = "Sphere",
    super.materialCode,
  });
}

class Plane extends Shape {
  late Vector3 normal;
  double distance;

  Plane({
    super.shapeName = "Plane",
    this.distance = 1.0,
    super.materialCode,
  }) {
    normal = Vector3();
  }
}

class ShapeFormat {
  static String generateBuildCode(List<Drawable> drawables) {
    StringBuffer buffer = StringBuffer();
    for (Drawable drawable in drawables) {
      buffer.writeln(_getShapeCode(drawable));
    }
    return buffer.toString();
  }

  static String _getShapeCode(Drawable drawable) {
    if (drawable is Sphere) {
      return _sphere(drawable);
    } else if (drawable is Plane) {
      return _plane(drawable);
    } else if (drawable is Group) {
      return _group(drawable);
    }
    return "";
  }

  static String _group(Group group) {
    String operation = group.operation.toString();
    String previousCode =
        "${_getShapeCode(group.first)}\n${_getShapeCode(group.second)}\n";
    return "$previousCode\ndata = $operation(${group.first.name}, ${group.second.name});";
  }

  static String _sphere(Sphere sphere) =>
      "vec2 sphere${sphere.id} = vec2(sphere(pos + ${sphere.position}, "
      "${sphere.radius}), ${sphere.material});";

  static String _plane(Plane plane) =>
      "vec2 plane${plane.id} = vec2(plane(pos + ${plane.position}, ${plane.normal}, "
      "${plane.distance}), ${plane.material});";
}
