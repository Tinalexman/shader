import 'package:flutter/material.dart';

extension BuildExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

const String defaultVertexShader = """
#version 300 es
#define attribute in
#define varying out

layout (location = 0) in vec3 a_Position;

void main() 
{
    gl_Position = vec4(a_Position, 1.0);
}
""";

String get defaultFs => "$defaultDeclarations \n\n"
    "$buildScene \n\n "
    "$rayMarch \n\n "
    "$render \n\n "
    "$uv \n\n "
    "$mainFragment";

const String defaultDeclarations = """
#version 300 es
#define gl_FragColor pc_fragColor

precision mediump float;
precision mediump int;
precision mediump vec2;
precision mediump vec3;
precision mediump vec4;



out highp vec4 pc_fragColor;


const float FIELD_OF_VIEW = 1.0;
const int MAXIMUM_STEPS = 256;
const float MAXIMUM_DISTANCE = 500.0;
const float EPSILON = 0.001;

uniform vec2 resolution;
//uniform vec2 mouse;
//uniform time;
""";

const String buildScene = """
vec2 build(mediump vec3 ray) {
  float sD = length(ray) - 1.0;
  float sID = 1.0;
  
  vec2 s = vec2(sD, sID);
  
  
  vec2 res = s;
  return res;
}
""";

const String lighting = """

""";

const String shadow = """

""";

const String join = """

""";

const String intersect = """

""";

const String diff = """

""";

const String rayMarch = """
vec2 rayMarch(vec3 rayOrigin, vec3 rayDirection) {
  vec2 hit = vec2(0.0);
  vec2 object = vec2(0.0);
  
  for(int i = 0; i < MAXIMUM_STEPS; ++i) {
    vec3 p = rayOrigin + (rayDirection * object.x);
    hit = build(p);
    object.x += hit.x;
    object.y = hit.y;
    if (abs(hit.x) < EPSILON || object.x > MAXIMUM_DISTANCE) break;
  }
  
  return object;
}
""";

const String render = """
vec3 render(vec2 uv) {
  vec3 rayOrigin = vec3(0.0, 0.0, -3.0);
  vec3 rayDirection = normalize(vec3(uv, FIELD_OF_VIEW));
  
  vec2 object = rayMarch(rayOrigin, rayDirection);
  vec3 color = vec3(0.0);
  
  if(object.x < MAXIMUM_DISTANCE) {
    color.xyz = vec3(3.0 / object.x);
  }
  
  return color;
}
""";

const String uv = """
vec2 getUV(vec2 offset) {
  return (2.0 * (gl_FragCoord.xy + offset) - resolution.xy) / resolution.y;
}
""";

const String mainFragment = """
void main() {
  vec2 uv = getUV(vec2(0.0));
  vec3 color = render(uv);
  gl_FragColor = vec4(color, 1.0);
}
""";

const String functionInsertionPoint = "// Insert other functions here";

class Holder {
  String name;
  bool selected;

  Holder({this.name = "", this.selected = false});
}

class Pair<K, V> {
  late K k;
  late V v;

  Pair({required this.k, required this.v});

  @override
  String toString() => "Pair( k : $k, v : $v )";
}

List<Holder> get returnTypes => [
      Holder(name: "float"),
      Holder(name: "int"),
      Holder(name: "vec2"),
      Holder(name: "vec3"),
      Holder(name: "vec4"),
      Holder(name: "void")
    ];
