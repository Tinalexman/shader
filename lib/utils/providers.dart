import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shade/components/camera.dart';
import 'package:shade/components/math.dart';
import 'package:shade/components/shader.dart';
import 'package:shade/components/shape_manager.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';

final StateProvider<int> renderProvider = StateProvider((ref) => 0);
final StateProvider<int> tabProvider = StateProvider((ref) => 0);

final StateProvider<List<double>> openGlConfigurationsProvider =
    StateProvider((ref) => []);

final StateProvider<DreamShader> shaderProvider = StateProvider((ref) {
  DreamShader shader = DreamShader();
  String fragment = ref.watch(fragmentShaderProvider);
  dynamic gl = ref.watch(glProvider);
  shader.create(gl, defaultVertexShader, fragment);

  Map<String, Pair<int, dynamic>> uniforms = ref.watch(shaderUniformsProvider);
  for (String key in uniforms.keys) {
    Pair<int, dynamic> pair = uniforms[key]!;
    shader.add(gl, key, pair);
  }

  uniforms = ref.watch(userParameters);
  for (String key in uniforms.keys) {
    Pair<int, dynamic> pair = uniforms[key]!;
    shader.add(gl, key, pair);
  }

  log("Shader Created");

  return shader;
});

final StateProvider<dynamic> glProvider = StateProvider((ref) => null);
final StateProvider<String> fragmentShaderProvider =
    StateProvider((ref) => defaultFs);

final StateProvider<bool> newCodeBlockProvider = StateProvider((ref) => false);
final StateProvider<bool> uniformProvider = StateProvider((ref) => false);
final StateProvider<bool> randomBlockColorProvider =
    StateProvider((ref) => true);
final StateProvider<Color> fixedCodeBlockColorProvider =
    StateProvider((ref) => theme);

final StateProvider<String> renderStateProvider =
    StateProvider((ref) => "Stopped");

final StateProvider<bool> highPrecisionProvider = StateProvider((ref) => true);
final StateProvider<bool> antiAliasProvider = StateProvider((ref) => false);

final StateProvider<Map<String, Pair<int, dynamic>>> shaderUniformsProvider =
    StateProvider((ref) {
  List<double> configs = ref.watch(openGlConfigurationsProvider);
  Pair<int, dynamic> resolution = Pair(
    k: -1,
    v: Vector2(
      x: configs[0],
      y: configs[1],
    ),
  );

  DreamCamera camera = ref.watch(cameraProvider);

  Pair<int, dynamic> mouse = Pair(
    k: -1,
    v: camera.pitchYaw,
  );
  Pair<int, dynamic> cameraPosition = Pair(
    k: -1,
    v: camera.position,
  );
  Pair<int, dynamic> time = Pair(
    k: -1,
    v: DreamDouble(
      value: ref.watch(timeProvider),
    ),
  );

  return {
    'RESOLUTION': resolution,
    'MOUSE': mouse,
    'CAMERA_POS': cameraPosition,
    'TIME': time,
  };
});

final StateProvider<double> timeProvider =
    StateProvider((ref) => DateTime.now().millisecondsSinceEpoch * 1.2);

final StateProvider<DreamCamera> cameraProvider = StateProvider(
  (ref) => DreamCamera(
    Vector3(x: 0.0, y: 0.0, z: -3.0),
    Vector3(),
    Vector2(x: 100.0, y: 50.0),
  ),
);

final StateProvider<Map<String, Pair<int, dynamic>>> userParameters =
    StateProvider((ref) => {});

final StateProvider<String> raytraceStepsProvider =
    StateProvider((ref) => "256");


final StateProvider<ShapeManager> shapesProvider = StateProvider((ref) => ShapeManager());