class Vector2 extends Changeable {
  double x;
  double y;

  Vector2({
    this.x = 0.0,
    this.y = 0.0,
  });

  @override
  String toString() => "Vector( x : $x, y : $y )";
}

class Vector3 extends Changeable {
  double x;
  double y;
  double z;

  Vector3({
    this.x = 0.0,
    this.y = 0.0,
    this.z = 0.0,
  });

  @override
  String toString() => "Vector( x : $x, y : $y, z : $z )";
}

class Changeable {
  late Function onChange;
  bool hasChanged = true;
}
