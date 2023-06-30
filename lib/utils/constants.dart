import 'package:flutter/material.dart';


extension BuildExtension on BuildContext
{
  TextTheme get textTheme => Theme.of(this).textTheme;

}


const String defaultVs =
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

const double oneOver255 = 0.003921568627450980392;