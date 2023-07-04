import 'package:shade/utils/widgets.dart';

Map<String, CodeBlockConfig> hgPrimitives = {
  "sphere": CodeBlockConfig(
    name: "sphere",
    returnType: "float",
    parameters: ['vec3 pos', 'float r'],
    body: """
float sphere(vec3 pos, float r) {
  return length(pos) - r;
}
  """,
    documentation:
        "Create a sphere at 'pos' in your scene with a radius of 'r'.",
  ),
  "plane": CodeBlockConfig(
    name: "plane",
    returnType: "float",
    parameters: ['vec3 pos', 'vec3 n', 'float d'],
    body: """
float plane(vec3 pos, vec3 n, float d) {
  return dot(pos, n) + d;
}
  """,
    documentation:
        "Create a plane at 'pos' of your scene with a normal vector of 'n' and 'd' distance from the origin.",
  ),
  "cube": CodeBlockConfig(
    name: "cube",
    returnType: "float",
    parameters: ["vec3 pos", 'float b'],
    body: """
float cube(vec3 pos, float b) {
  vec3 d = abs(pos) - b;
  return length(max(d, vec3(0.0))) + vmax(min(d, vec3(0.0)));
}
  """,
    documentation:
        "Create a cube at 'pos' of your scene with the distance 'b' to the corners.",
  ),
  "cylinder": CodeBlockConfig(
    name: "cylinder",
    returnType: "float",
    parameters: ["vec3 pos", 'float r', 'float h'],
    body: """
float cylinder(vec3 pos, float r, float h) {
  float d = length(pos.xz) - r;
  return max(d, abs(pos.y) - h);
}
  """,
    documentation:
        "Create a cylinder at 'pos' of your scene standing upright in the xz plane with a radius of 'r' and a height of 'h'.",
  ),
  "capsule": CodeBlockConfig(
    name: "capsule",
    returnType: "float",
    parameters: ["vec3 pos", 'float r', 'float c'],
    body: """
float capsule(vec3 pos, float r, float c) {
  return mix(length(pos.xz) - r, length(vec3(pos.x, abs(pos.y) - c, pos.z)) - r, step(c, abs(pos.y)));
}
  """,
    documentation:
        "Create a capsule at 'pos' of your scene standing upright in the xz plane with a radius of 'r' and a cap height of 'c'.",
  ),
  "torus": CodeBlockConfig(
    name: "torus",
    returnType: "float",
    parameters: ["vec3 pos", 'float s', 'float l'],
    body: """
float torus(vec3 pos, float s, float l) {
  return length(vec2(length(pos.xz) - l, pos.y)) - s;
}
  """,
    documentation:
        "Create a torus at 'pos' of your scene in the xz plane with outer radius of 'l' and inner radius of 's'.",
  ),
  "cone": CodeBlockConfig(
    name: "cone",
    returnType: "float",
    parameters: ["vec3 pos", 'float r', 'float h'],
    body: """
float cone(vec3 pos, float r, float h) {
  vec2 q = vec2(length(pos.xz), pos.y);
  vec2 tip = q - vec2(0, h);
  vec2 mantleDir = normalize(vec2(h, r));
  float mantle = dot(tip, mantleDir);
  float d = max(mantle, -q.y);
  float projected = dot(tip, vec2(mantleDir.y, -mantleDir.x));
  
  // distance to tip
  if ((q.y > h) && (projected < 0)) {
    d = max(d, length(tip));
  }
  
  // distance to base ring
  if ((q.x > r) && (projected > length(vec2(h, r)))) {
    d = max(d, length(q - vec2(r, 0)));
  }
  return d;
} 
  """,
    documentation:
        "Create a cone at 'pos' of your scene in the xz plane with base radius of 'r' and height of 'h'.",
  ),
};

Map<String, CodeBlockConfig> hgOperators = {
  "join": CodeBlockConfig(
    name: "join",
    parameters: ["vec2 first, vec2 second"],
    returnType: "vec2",
    body: """
vec2 join(vec2 first, vec2 second) {
  return (first.x < second.x) ? first : second;
}
""",
    documentation: "Joins two SDF shapes: 'first' and 'second' together.",
  ),
  "remove": CodeBlockConfig(
    name: "remove",
    parameters: ["vec2 first, vec2 second"],
    returnType: "vec2",
    body: """
vec2 remove(vec2 first, vec2 second) {
  return (first.x > -second.x) ? first : vec2(second.x, second.y);
}
      """,
    documentation: "Removes one SDF shape 'second' from the other 'first'.",
  ),
  "intersect": CodeBlockConfig(
    name: "intersect",
    parameters: ["vec2 first, vec2 second"],
    returnType: "vec2",
    body: """
vec2 intersect(vec2 first, vec2 second) {
  return (first.x > second.x) ? first : second;
}
      """,
    documentation:
        "Returns the intersection of two SDF shapes: 'first' and 'second'.",
  ),
  "sign": CodeBlockConfig(
    name: "sign",
    parameters: ["float x"],
    returnType: "float",
    body: """
float sign(float x) {
  return (x < 0) ? -1.0 : 1.0;
}
      """,
    documentation: "Returns a non zero float.",
  ),
  "sign2": CodeBlockConfig(
    name: "sign2",
    parameters: ["vec2 v"],
    returnType: "vec2",
    body: """
vec2 sign2(vec2 v) {
  return vec2( (v.x < 0.0) ? -1.0 : 1.0, (v.y < 0.0) ? -1.0 : 1.0);
}
      """,
    documentation: "Returns a non zero vector.",
  ),
  "vmax2": CodeBlockConfig(
    name: "vmax2",
    parameters: ["vec2 v"],
    returnType: "float",
    body: """
float vmax2(vec2 v) {
  return max(v.x, v.y);
}
      """,
    documentation: "Return the maximum component of a vector2.",
  ),
  "vmax3": CodeBlockConfig(
    name: "vmax3",
    parameters: ["vec3 v"],
    returnType: "float",
    body: """
float vmax3(vec3 v) {
  return max(max(v.x, v.y), v.z);
}
      """,
    documentation: "Return the maximum component of a vector3.",
  ),
  "vmin2": CodeBlockConfig(
    name: "vmin2",
    parameters: ["vec2 v"],
    returnType: "float",
    body: """
float vmin2(vec2 v) {
  return min(v.x, v.y);
}
      """,
    documentation: "Return the minimum component of a vector2.",
  ),
  "vmin3": CodeBlockConfig(
    name: "vmin3",
    parameters: ["vec3 v"],
    returnType: "float",
    body: """
float vmin3(vec3 v) {
  return min(min(v.x, v.y), v.z);
}
      """,
    documentation: "Return the minimum component of a vector3.",
  ),
};

Map<String, CodeBlockConfig> hgManipulators = {
  "rotate": CodeBlockConfig(
    name: "rotate",
    parameters: ["vec2 pos", "float a"],
    body: """
void rotate(inout vec2 pos, float a) {
  pos = (cos(a) * pos) + (sin(a) * vec2(pos.y, -pos.x));
}""",
    documentation:
        "Rotates a value 'pos' by a angle of 'a' about a coordinate axis. "
        "Note that the value 'pos' is modified immediately. Normally, your position is a vector3, "
        "but you need to pass in the axis you want to start from, and the axis you're rotating to. "
        "For example: if r = vec3(1.0, 2.0, 3.0), calling rotate(r.xz) means we're rotating about the "
        "y axis but we're starting from the x-axis and rotating towards the z-axis. Similarly, rotate(r.zx)"
        " would start from the z axis towards the x axis about the y-axis.",
  ),
  "mod1": CodeBlockConfig(
    name: "mod1",
    parameters: ["float pos", "float size"],
    returnType: "float",
    body: """
float mod1(inout float pos, float size) {
  float halfSize = size * 0.5;
  float c = floor((pos + halfSize) / size);
  pos = mod(pos + halfSize, size) - halfSize;
  return c;
}
      """,
    documentation:
        "Repeats space along a specified axis. For example, if r = vec3(1.0, 2.0, 3.0), calling "
        "mod1(r.x) will repeat the space along the x-axis. Similarly, mod1(r.y) and mod1(r.z) will repeat space "
        "in the y and z axes respectively. ",
  ),
  "mod2": CodeBlockConfig(
    name: "mod2",
    parameters: ["vec2 pos", "vec2 size"],
    returnType: "vec2",
    body: """
vec2 mod2(inout vec2 pos, vec2 size) {
  vec2 c = floor((pos + (size * 0.5)) / size);
  pos = mod(pos + (size * 0.5), size) - (size * 0.5);
  return c;
}
      """,
    documentation:
        "Repeats space in two dimensions. For example, if r = vec3(1.0, 2.0, 3.0), calling "
        "mod2(r.xy) will repeat the space along the x and y axes at the same time. This also "
        "applies to other combination of axes.",
  ),
  "mod3": CodeBlockConfig(
    name: "mod3",
    parameters: ["vec3 pos", "vec3 size"],
    returnType: "vec3",
    body: """
vec3 mod3(inout vec3 pos, vec3 size) {
  vec3 c = floor((pos + (size * 0.5)) / size);
  pos = mod(pos + (size * 0.5), size) - (size * 0.5);
  return c;
}
      """,
    documentation:
        "Repeats space in all three dimensions. For example, if r = vec3(1.0, 2.0, 3.0), calling "
        "mod3(r) will repeat the space along the x, y and z axes at the same time.",
  ),
  "mirror": CodeBlockConfig(
    name: "mirror",
    parameters: ["float pos", "float d"],
    returnType: "float",
    body: """
float mirror(inout float pos, float d) {
  float s = sign(pos);
  pos = abs(pos) - d;
  return s;
}
      """,
    documentation:
        "Mirror at an axis-aligned plane which is at a specified distance 'd' from the origin.",
  ),
};

Map<String, CodeBlockConfig> hgMaterials = {
  "checkerboard": CodeBlockConfig(
    name: "checkerboard",
    parameters: ["vec3 pos"],
    returnType: "vec3",
    body: """
vec3 checkerboard(vec3 pos) {
  return vec3(0.2 + 0.4 * mod(floor(pos.x) + floor(pos.z), 2.0));
}""",
    documentation: "Returns a checkerboard pattern.",
  ),
};

List<String> allHGKeys = [];

List<String> getAllHGKeys() {
  if (allHGKeys.isEmpty) {
    allHGKeys.addAll(hgOperators.keys);
    allHGKeys.addAll(hgManipulators.keys);
    allHGKeys.addAll(hgPrimitives.keys);
    allHGKeys.addAll(hgMaterials.keys);
  }

  return allHGKeys;
}

Iterable<String> getOperators() => hgOperators.keys;

String getHGCode(String key) {
  if (hgOperators.containsKey(key)) {
    return hgOperators[key]!.body;
  } else if (hgManipulators.containsKey(key)) {
    return hgManipulators[key]!.body;
  } else if (hgPrimitives.containsKey(key)) {
    return hgPrimitives[key]!.body;
  } else if (hgMaterials.containsKey(key)) {
    return hgMaterials[key]!.body;
  }
  return "";
}

CodeBlockConfig? getBlock(String key) {
  if (hgOperators.containsKey(key)) {
    return hgOperators[key];
  } else if (hgManipulators.containsKey(key)) {
    return hgManipulators[key];
  } else if (hgPrimitives.containsKey(key)) {
    return hgPrimitives[key];
  } else if (hgMaterials.containsKey(key)) {
    return hgMaterials[key];
  }
  return null;
}
