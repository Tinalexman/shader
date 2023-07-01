import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shade/shader/shader.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';

final StateProvider<int> renderProvider = StateProvider((ref) => 0);
final StateProvider<int> tabProvider = StateProvider((ref) => 0);

final StateProvider<DreamShader> shaderProvider = StateProvider((ref) {
  DreamShader shader = DreamShader();
  if (ref.watch(hotCompileProvider)) {
    String fragment = ref.watch(fragmentShaderProvider);
    dynamic gl = ref.watch(glProvider);
    shader.create(gl, defaultVertexShader, fragment);
  }
  return shader;
});

final StateProvider<dynamic> glProvider = StateProvider((ref) => null);
final StateProvider<String> fragmentShaderProvider =
    StateProvider((ref) => defaultFs);

final StateProvider<bool> hotCompileProvider = StateProvider((ref) => false);
final StateProvider<bool> newCodeBlockProvider = StateProvider((ref) => false);
final StateProvider<bool> randomBlockColorProvider =
    StateProvider((ref) => true);
final StateProvider<Color> fixedCodeBlockColorProvider =
    StateProvider((ref) => theme);

final StateProvider<String> renderStateProvider =
    StateProvider((ref) => "Stopped");

void createNewShader(WidgetRef ref) {
  DreamShader shader = ref.watch(shaderProvider.notifier).state;
  final gl = ref.watch(glProvider);
  shader.dispose(gl);
  shader.create(gl, defaultVertexShader, ref.read(fragmentShaderProvider));
}
