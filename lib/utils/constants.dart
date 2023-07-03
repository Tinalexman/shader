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

String get defaultFs =>
    "$defaultDeclarations \n\n"
    "$join \n\n"
    "$buildScene \n\n"
    "$material \n\n"
    "$rayMarch \n\n"
    "$normal \n\n"
    "$lighting \n\n"
    "$render \n\n"
    "$uv \n\n"
    "$mainFragment \n\n"
;

const String defaultDeclarations = """
#version 300 es
#define gl_FragColor pc_fragColor

precision mediump float;
precision mediump int;
// precision mediump vec2;
// precision mediump vec3;
// precision mediump vec4;



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
  vec2 data = vec2(0.0);
  
  float sD = length(ray) - 1.0;
  float sID = 1.0;
  vec2 s = vec2(sD, sID);
 
  float pD = dot(ray, vec3(0.0, 1.0, 0.0)) + 1.0;
  float pID = 2.0;
  vec2 p = vec2(pD, pID);
  
  data = join(p, s);
  
  return data;
}
""";

const String lighting = """
vec3 light(vec3 ray, vec3 rayDirection, vec3 color) {
  vec3 lightPosition = vec3(20.0, 40.0, -30.0);
  vec3 L = normalize(lightPosition - ray);
  vec3 N = normal(ray); 
  vec3 R = reflect(-L, N);
  
  vec3 specular = vec3(0.5) * pow(clamp(dot(R, -rayDirection), 0.0, 1.0), 10.0);
  vec3 diffuse = color * clamp(dot(L, N), 0.0, 1.0);
  vec3 ambient = color * 0.05;
  
  float d = rayMarch(ray + (N * 0.02), normalize(lightPosition)).x;
  if(d < length(lightPosition - ray)) return ambient;
  
  return ambient + diffuse + specular;
} 
""";

const String normal = """
vec3 normal(vec3 ray) {
  vec2 e = vec2(EPSILON, 0.0);
  vec3 n = vec3(build(ray).x) - vec3(build(ray - e.xyy).x, build(ray - e.yxy).x, build(ray - e.yxx).x);
  return normalize(n);
}
""";

const String material = """
vec3 material(vec3 ray, float ID) {
  vec3 color = vec3(0.0);
  
  // switch(int(ID)) {
  //   case 1: color = vec3(0.9, 0.9, 0.0); break; // PLANE CHECKERBOARD
  //   case 2: color = vec3(0.0, 0.5, 0.5); break;
  // }
  //
  
  if(ID == 1.0) {
    color = vec3(0.9, 0.9, 0.0);
  } else if(ID == 2.0) {
    color = vec3(0.0, 0.5, 0.5);
  }

  return color;
}
""";

const String shadow = """

""";

const String join = """
vec2 join(vec2 first, vec2 second) {
  return (first.x < second.x) ? first : second;
}
""";

const String intersect = """
vec2 intersect(vec2 first, vec2 second) {
  return (first.x > second.x) ? first : second;
}
""";

const String remove = """
vec2 remove(vec2 first, vec2 second) {
  return (first.x > -second.x) ? first : vec2(second.x, second.y);
}
""";

const String rayMarch = """
vec2 rayMarch(vec3 rayOrigin, vec3 rayDirection) {
  vec2 hit = vec2(0.0);
  vec2 object = vec2(0.0);
  
  for(int i = 0; i < MAXIMUM_STEPS; ++i) {
    vec3 ray = rayOrigin + (rayDirection * object.x);
    hit = build(ray);
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
  vec3 background = vec3(0.5, 0.8, 0.9);
  
  if(object.x < MAXIMUM_DISTANCE) {
    vec3 ray = rayOrigin + (rayDirection * object.x);
    vec3 m = material(ray, object.y);
    color = light(ray, rayDirection, m);
    color = mix(color, background, 1.0 - exp(-0.00008 * object.x * object.x));
  } else {
    color.xyz = background - max((rayDirection.y * 0.95), 0.0);
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
  
  color = pow(color, vec3(0.4545));
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
