import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shade/components/shader.dart';
import 'package:shade/components/math.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';

import 'dart:developer';

final StateProvider<int> renderProvider = StateProvider((ref) => 0);
final StateProvider<int> tabProvider = StateProvider((ref) => 0);

final StateProvider<List<double>> openGlConfigurationsProvider =
    StateProvider((ref) => []);

final StateProvider<DreamShader> shaderProvider = StateProvider((ref) {
  DreamShader shader = DreamShader();
  String fragment = ref.watch(fragmentShaderProvider);
  dynamic gl = ref.watch(glProvider);
  shader.create(gl, defaultVertexShader, fragment);

  Map<String, Pair<int, dynamic>> uniforms = ref.watch(uniformsProvider);
  shader.uniforms = uniforms;
  for (String key in uniforms.keys) {
    Pair<int, dynamic> pair = uniforms[key]!;
    shader.add(gl, key, pair);
  }

  log("Updating shader");

  return shader;
});

final StateProvider<dynamic> glProvider = StateProvider((ref) => null);
final StateProvider<String> fragmentShaderProvider =
    StateProvider((ref) => defaultFs);

final StateProvider<bool> newCodeBlockProvider = StateProvider((ref) => false);
final StateProvider<bool> randomBlockColorProvider =
    StateProvider((ref) => true);
final StateProvider<Color> fixedCodeBlockColorProvider =
    StateProvider((ref) => theme);

final StateProvider<String> renderStateProvider =
    StateProvider((ref) => "Stopped");

final StateProvider<bool> highPrecisionProvider = StateProvider((ref) => true);

final StateProvider<Vector2> mouseProvider = StateProvider((ref) {
  List<double> configs = ref.watch(openGlConfigurationsProvider);
  return Vector2(x: configs[0] * 0.5, y: configs[1] * 0.5);
});

final StateProvider<Map<String, Pair<int, dynamic>>> uniformsProvider =
    StateProvider((ref) {
  List<double> configs = ref.watch(openGlConfigurationsProvider);
  Pair<int, dynamic> resolution = Pair(k: -1, v: Vector2(x: configs[0], y: configs[1]));
  Pair<int, dynamic> mouse = Pair(k: -1, v: ref.watch(mouseProvider));
  log("Updating uniforms");
  return {
    "resolution": resolution,
    "mouse": mouse,
  };
});
