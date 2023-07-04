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


class Vector4 extends Changeable {
  double x;
  double y;
  double z;
  double w;

  Vector4({
    this.x = 0.0,
    this.y = 0.0,
    this.z = 0.0,
    this.w = 0.0,
  });

  @override
  String toString() => "Vector( x : $x, y : $y, z : $z, w : $w )";
}

class DreamDouble extends Changeable {
  double value;

  DreamDouble({this.value = 0.0});
}

class DreamInt extends Changeable {
  int value;

  DreamInt({this.value = 0});
}



class Changeable {
  bool hasChanged = true;
}
