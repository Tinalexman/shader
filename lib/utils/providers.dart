import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shade/shader/dream_shader.dart';
import 'package:shade/utils/constants.dart';

import 'package:shade/utils/shader_preview_config.dart';


// FOR EDITOR
final StateProvider<bool> renderProvider = StateProvider((ref) => false);
final StateProvider<int> tabProvider = StateProvider((ref) => 0);




final StateProvider<DreamShader> shaderProvider = StateProvider((ref) {
  DreamShader shader = DreamShader();
  if(ref.watch(hotCompileProvider)) {
    String vertex = ref.watch(vertexShaderProvider);
    String fragment = ref.watch(fragmentShaderProvider);
    dynamic gl = ref.watch(glProvider);
    shader.create(gl, vertex, fragment);
  }
  return shader;
});

final StateProvider<dynamic> glProvider = StateProvider((ref) => null);
final StateProvider<String> vertexShaderProvider =
StateProvider((ref) => defaultVs);
final StateProvider<String> fragmentShaderProvider =
StateProvider((ref) => defaultFs);

final StateProvider<PreviewConfigurations> configurationsProvider =
StateProvider((ref) => PreviewConfigurations());


final StateProvider<bool> hotCompileProvider = StateProvider((ref) => false);

void createNewShader(WidgetRef ref) {
  DreamShader shader = ref.watch(shaderProvider.notifier).state;
  final gl = ref.watch(glProvider);
  shader.dispose(gl);
  shader.create(
      gl, ref.read(vertexShaderProvider), ref.read(fragmentShaderProvider));
}