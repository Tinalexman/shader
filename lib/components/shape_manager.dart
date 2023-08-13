import 'package:shade/components/math.dart';


mixin Drawable {
  int getId();
  String getName();
  String getBuildCode();
}


class ShapeManager {
  final List<Drawable> _shapes = [];
  int _index = -1;


  ShapeManager() {
    _shapes.add(Sphere());
    _index = 0;
  }

  String getBuild() {
    StringBuffer buffer = StringBuffer();
    for(Drawable drawable in _shapes) {
      buffer.writeln(drawable.getBuildCode());
    }
    return buffer.toString();
  }

  void select(int index) => _index = index;

  Drawable get shape => _shapes[_index];

  String getMaterial() {
    return "";
  }

  void add(Drawable shape) => _shapes.add(shape);
}

abstract class Shape with Drawable {
  static int numberOfShapes = 0;

  late int id;

  Shape() {
    id = ++numberOfShapes;
  }

  @override
  int getId() => id;
}

class Sphere extends Shape {
  double radius;

  Sphere({this.radius = 1.0});

  @override
  String getName() => "sphere$id";

  @override
  String getBuildCode() {
    return "vec2 ${getName()} = vec2(sphere(pos, $radius), $id);";
  }
}

class Plane extends Shape {
  late Vector3 normal;
  double distanceToOrigin;

  Plane({this.distanceToOrigin = 0.0}) {
    normal = Vector3(x: 0.0, y: 1.0, z: 0.0);
  }

  @override
  String getName() => "plane$id";

  @override
  String getBuildCode() {
    return "vec2 ${getName()} = vec2(plane(pos, $normal, $distanceToOrigin), $id);";
  }
}

enum ShapeOperation { join, remove, intersect }

class ShapeGroup with Drawable {
  ShapeOperation operation;
  Shape firstShape, secondShape;

  ShapeGroup({
    required this.operation,
    required this.firstShape,
    required this.secondShape,
  });

  @override
  String getName() => "";

  @override
  int getId() => -1;

  @override
  String getBuildCode() {
    String op = "";
    switch(operation) {
      case ShapeOperation.join: op = "join"; break;
      case ShapeOperation.intersect: op = "intersect"; break;
      case ShapeOperation.remove: op = "remove";
    }

    return "\n${firstShape.getBuildCode()}\n"
        "${secondShape.getBuildCode()}\n"
        "data = join(data, ${firstShape.getName()});\n"
        "data = $op(${secondShape.getName()});\n"
    ;
  }
}

