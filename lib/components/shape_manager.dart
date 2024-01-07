import 'dart:developer';

import 'package:shade/utils/constants.dart';
import 'drawable.dart';

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
      Plane(materialCode: 1),
      Sphere(),
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
    switch (type) {
      case ShapeType.plane:
        add(Plane());
        return;
      case ShapeType.sphere:
        add(Sphere());
        return;
      case ShapeType.torus:
        add(Torus());
        return;
      case ShapeType.cylinder:
        add(Cylinder());
        return;
      case ShapeType.cone:
        add(Cone());
        return;
      case ShapeType.capsule:
        add(Capsule());
        return;
      case ShapeType.cube:
        add(Cube());
        return;
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

class ShapeFormat {
  static String generateBuildCode(List<Drawable> drawables) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("vec2 build(vec3 pos) {");
    buffer.writeln("\tvec2 data = vec2(0.0);");
    for (Drawable drawable in drawables) {
      buffer.writeln("\t${_getShapeCode(drawable)}");
    }
    for (Drawable drawable in drawables) {
      if (drawable is! Group) {
        buffer.writeln("\tdata = join(data, ${drawable.name});");
      }
    }
    buffer.writeln("\treturn data;\n}");
    return buffer.toString();
  }

  static String _getShapeCode(Drawable drawable) {
    if (drawable is Sphere) {
      return _sphere(drawable);
    } else if (drawable is Plane) {
      return _plane(drawable);
    } else if (drawable is Cube) {
      return _cube(drawable);
    } else if (drawable is Capsule) {
      return _capsule(drawable);
    } else if(drawable is Cylinder) {
      return _cylinder(drawable);
    } else if(drawable is Cone) {
      return _cone(drawable);
    } else if(drawable is Torus) {
      return _torus(drawable);
    } else if (drawable is Group) {
      return _group(drawable);
    }
    return "";
  }

  static String _operation(Operation operation) {
    switch(operation) {
      case Operation.join: return "join";
      case Operation.remove: return "remove";
      case Operation.intersect: return "intersect";
    }
  }

  static String _group(Group group) {
    String operation = _operation(group.operation);
    String previousCode =
        "${_getShapeCode(group.first)}\n${_getShapeCode(group.second)}\n";
    return "$previousCode\ndata = $operation(${group.first.name}, ${group.second.name});";
  }

  static String _sphere(Sphere sphere) =>
      "vec2 ${sphere.name} = vec2(sphere(pos + ${sphere.position}, "
      "${sphere.radius}), ${sphere.material});";

  static String _plane(Plane plane) =>
      "vec2 ${plane.name} = vec2(plane(pos + ${plane.position}, ${plane.normal}, "
      "${plane.distance}), ${plane.material});";

  static String _cube(Cube cube) =>
    "vec2 ${cube.name} = vec2(cube(pos + ${cube.position}, ${cube.size}), ${cube.material});";

  static String _cylinder(Cylinder cylinder) =>
      "vec2 ${cylinder.name} = vec2(cylinder(pos + ${cylinder.position}, ${cylinder.radius}, "
          "${cylinder.height}), ${cylinder.material});";

  static String _cone(Cone cone) =>
      "vec2 ${cone.name} = vec2(cone(pos + ${cone.position}, ${cone.radius}, "
          "${cone.height}), ${cone.material});";

  static String _torus(Torus torus) =>
      "vec2 ${torus.name} = vec2(cone(pos + ${torus.position}, ${torus.innerRadius}, "
          "${torus.outerRadius}), ${torus.material});";

  static String _capsule(Capsule capsule) =>
      "vec2 ${capsule.name} = vec2(cone(pos + ${capsule.position}, ${capsule.radius}, "
          "${capsule.capHeight}), ${capsule.material});";

  static String generateMaterialCode(List<Material> materials) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("vec3 material(vec3 pos, vec3 normal, float ID) {");
    buffer.writeln("\tvec3 color = vec3(0.0);\n\tswitch( int(ID) ) {");
    for (Material material in materials) {
      buffer
          .writeln("\t\tcase ${material.index}: ${material.definition} break;");
    }
    buffer.writeln("\n\t}\n\treturn color;\n}");
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
