import 'package:shade/components/shape_manager.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/components/math.dart';

abstract class Drawable {
  String get name;

  int get id;

  @override
  bool operator ==(Object other) {
    if (other is! Drawable) return false;
    if (other == this) return true;

    return id == other.id;
  }

  @override
  int get hashCode => id * 256 + 3869;
}

abstract class Shape with Drawable {
  @override
  late int id;

  late double material;

  late Vector3 position, rotation, scale;

  @override
  late String name;

  Shape({required String shapeName, double materialCode = 0.0}) {
    id = ShapeManager.drawablesCount++;
    material = materialCode;
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
  String get name => "group${first.name}${first.id}${second.name}${second.id}";
}

class Sphere extends Shape {
  double radius;

  Sphere({
    this.radius = 1.0,
    super.shapeName = "sphere",
    super.materialCode,
  });
}

class Plane extends Shape {
  late Vector3 normal;
  double distance;

  Plane({
    super.shapeName = "plane",
    this.distance = 1.0,
    super.materialCode,
  }) {
    normal = Vector3(x: 0.0, y: 1.0, z: 0.0);
  }
}

class Cube extends Shape {
  late double size;

  Cube({
    this.size = 1.0,
    super.shapeName = "cube",
    super.materialCode,
  });
}

class Capsule extends Shape {
  double radius, capHeight;

  Capsule({
    this.radius = 1.0,
    this.capHeight = 0.5,
    super.shapeName = "capsule",
    super.materialCode,
  });
}

class Cylinder extends Shape {
  double radius, height;

  Cylinder({
    this.height = 1.5,
    this.radius = 1.0,
    super.shapeName = "cylinder",
    super.materialCode,
  });
}

class Cone extends Shape {
  double radius, height;
  Cone({
    this.height = 1.0,
    this.radius = 1.0,
    super.shapeName = "cone",
    super.materialCode,
  });
}

class Torus extends Shape {
  double innerRadius, outerRadius;

  Torus({
    this.innerRadius = 1.0,
    this.outerRadius = 2.0,
    super.shapeName = "torus",
    super.materialCode,
  });
}