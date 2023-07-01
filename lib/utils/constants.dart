import 'package:flutter/material.dart';


extension BuildExtension on BuildContext
{
  TextTheme get textTheme => Theme.of(this).textTheme;

}


const String defaultVertexShader =
"""
#version 300 es
#define attribute in
#define varying out

layout (location = 0) in vec3 a_Position;

void main() 
{
    gl_Position = vec4(a_Position, 1.0);
}
"""
;


const String defaultFs =
"""
#version 300 es
out highp vec4 pc_fragColor;
#define gl_FragColor pc_fragColor

void main() 
{
  gl_FragColor = vec4(1.0);
}
""";


const String defaultBuild =
"""

""";

const String functionInsertionPoint = "// Insert other functions here";




class Holder {
  String name;
  bool selected;

  Holder({this.name = "", this.selected = false});
}


List<Holder> get returnTypes => [
  Holder(name: "float"),
  Holder(name: "int"),
  Holder(name: "vec2"),
  Holder(name: "vec3"),
  Holder(name: "vec4"),
  Holder(name: "void")
];