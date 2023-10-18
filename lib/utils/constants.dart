import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export 'shader.dart';
export 'theme.dart';


extension BuildExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  GoRouter get router => GoRouter.of(this);
}




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


extension PathExtension on String {
  String get path => "/$this";
}

class Pages {
  static const String splash = "splash";
  static const String intro = "intro";
  static const String explorer = "explorer";
  static const String editor = "editor";
  static const String texture = "texture";
  static const String code = "code";
  static const String help = "help";
  static const String settings = "settings";
}