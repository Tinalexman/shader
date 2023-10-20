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

class ShapeManager {
  static int drawablesCount = 0;
  static const int groupIDMultiplier = 1000;
  static const double defaultMaterial = 0.0;

  late List<Drawable> _root;
  late List<Material> _materials;

  List<Drawable> get root => _root;

  List<Material> get materials => _materials;

  ShapeManager() {
    _root = [

      Group(
        first: Sphere(),
        second: Plane(materialCode: 1),
        operation: Operation.join,
      ),
    ];

    _materials = [
      Material(
        index: 0,
        definition: "color = vec3(0.5);",
      ),
      Material(
        index: 1,
        definition: "color = checkerboard(pos);",
      ),
      Material(
        index: 2,
        definition: "color = lattice(pos, vec3(0.53, 0.12, 0.74));",
      )
    ];
  }

  void create(ShapeType type) {
    switch(type) {
      case ShapeType.plane: add(Plane()); break;
      case ShapeType.sphere: add(Sphere()); break;
      default: break;
    }
  }

  void add(Drawable drawable) => _root.add(drawable);

  void remove(Drawable drawable) => _root.remove(drawable);

  void group(Drawable first, Drawable second, Operation operation) {
    int firstIndex = _root.indexOf(first), secondIndex = _root.indexOf(second);
    int index = firstIndex < secondIndex ? firstIndex : secondIndex;
    Group group = Group(first: first, second: second, operation: operation);
    _root.remove(first);
    _root.remove(second);
    _root.insert(index, group);
  }
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

class ShapeFormat {
  static String generateBuildCode(List<Drawable> drawables) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("vec2 build(vec3 pos) {\n");
    buffer.writeln("\tvec2 data = vec2(0.0);\n");
    for (Drawable drawable in drawables) {
      buffer.writeln("\t${_getShapeCode(drawable)}");
    }
    buffer.writeln("\treturn data;\n}");
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
    String operation = group.operation == Operation.join
        ? "join"
        : group.operation == Operation.remove
            ? "remove"
            : "intersect";
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

  static String generateMaterialCode(List<Material> materials) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("vec3 material(vec3 pos, vec3 normal, float ID) {\n");
    buffer.writeln("\tvec3 color = vec3(0.0);\n\tswitch( int(ID) ) {");
    for (Material material in materials) {
      buffer.writeln("\t\tcase ${material.index}: ${material.definition} break;");
    }

    buffer.writeln("\n}\n\treturn color;\n}");
    return buffer.toString();
  }
}

class Material {
  int index;
  String definition;

  Material({
    required this.index,
    required this.definition,
  });
}
