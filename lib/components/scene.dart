import 'package:shade/utils/widgets.dart';

class Scene {
  final String name;
  final List<CodeBlockConfig> configs;

  Scene({
    required this.name,
    this.configs = const [],
  });

}
