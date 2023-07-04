import 'package:shade/utils/widgets.dart';

class Scene {
  final String name;
  final List<CodeBlockConfig> configs;

  Scene({
    required this.name,
    this.configs = const [],
  });

  Map<String, dynamic> toJson() => {
    "name" : name,
    "configs" : configs
  };

  factory Scene.fromJson(Map<String, dynamic> map) => Scene(name: map["name"], configs: map["configs"]);
}
