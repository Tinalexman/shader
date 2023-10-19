class Vector2 {
  late double x;
  late double y;

  Vector2({
    this.x = 0.0,
    this.y = 0.0,
  });

  Vector2.value(double d) {
    x = y = d;
  }

  @override
  String toString() => "vec2($x, $y)";
}

class Vector3 {
  late double x;
  late double y;
  late double z;

  Vector3({
    this.x = 0.0,
    this.y = 0.0,
    this.z = 0.0,
  });

  Vector3.value(double d) {
    x = y = z = d;
  }

  @override
  String toString() => "vec3($x, $y, $z)";
}


class Vector4 {
  late double x;
  late double y;
  late double z;
  late double w;

  Vector4({
    this.x = 0.0,
    this.y = 0.0,
    this.z = 0.0,
    this.w = 0.0,
  });

  Vector4.value(d) {
    x = y = z = w = d;
  }

  @override
  String toString() => "vec4($x, $y, $z, $w)";
}

class DreamDouble {
  double value;

  DreamDouble({this.value = 0.0});
}

class DreamInt {
  int value;

  DreamInt({this.value = 0});
}

class DreamTexture {
  String path;
  bool loaded;
  dynamic id;

  DreamTexture({this.path = "", this.loaded = false});
}

