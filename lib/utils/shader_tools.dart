import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shade/components/math.dart';
import 'package:shade/components/sdf.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/widgets.dart';

import 'constants.dart';



class ShaderTools {


  static Future<String> assembleShader(WidgetRef ref, String buildCode, String materialCode) async {
    StringBuffer buffer = StringBuffer();
    String precisionType = ref.watch(highPrecisionProvider)
        ? 'precision highp float;'
        : 'precision mediump float;';

    buffer.write("$definitions \n\n");
    buffer.write('$precisionType \n\n');
    buffer.write("$defaultDeclarations \n\n");
    buffer.write("${_getUniforms(ref)} \n\n");

    String importedFunctions = _analyze(buildCode, materialCode);

    buffer.write("$importedFunctions \n\n");
    buffer.write("$buildCode \n\n");


    buffer.write("$materialCode \n\n");
    buffer.write("$rayMarch \n\n");
    buffer.write("$normal \n\n");
    buffer.write("$ambientOcclusion \n\n");
    buffer.write("$shadow \n\n");
    buffer.write("$lighting \n\n");
    buffer.write("$rotate \n\n");
    buffer.write("$mouseUpdate \n\n");
    buffer.write("$camera \n\n");
    buffer.write("$render \n\n");
    buffer.write("$uv \n\n");
    buffer.write("$render4XAA \n\n");

    bool aliasType = ref.watch(antiAliasProvider);
    String mode = aliasType
        ? "vec3 color = render4XAA();"
        : "vec2 uv = getUV(vec2(0.0));\n\tvec3 color = render(uv);\n\t";

    buffer.write(beginMain);
    buffer.write(mode);
    buffer.write(endMain);

    //log(buffer.toString());

    return buffer.toString();
  }

  static String _getUniforms(WidgetRef ref) {
    StringBuffer buffer = StringBuffer();

    Map<String, Pair<int, dynamic>> parameters =
        ref.watch(shaderUniformsProvider.notifier).state;
    for (String key in parameters.keys) {
      Pair<int, dynamic> pair = parameters[key]!;
      String type = "";
      if (pair.v is Vector2) {
        type = "vec2";
      } else if (pair.v is Vector3) {
        type = "vec3";
      } else if (pair.v is Vector4) {
        type = "vec4";
      } else if (pair.v is DreamInt) {
        type = "int";
      } else if (pair.v is DreamDouble) {
        type = "float";
      } else if(pair.v is DreamTexture) {
        type = 'sampler2D';
      }

      buffer.write('uniform $type $key; \n');
    }

    parameters = ref.watch(userParameters.notifier).state;
    for (String key in parameters.keys) {
      Pair<int, dynamic> pair = parameters[key]!;
      String type = "";
      if (pair.v is Vector2) {
        type = "vec2";
      } else if (pair.v is Vector3) {
        type = "vec3";
      } else if (pair.v is Vector4) {
        type = "vec4";
      } else if (pair.v is DreamInt) {
        type = "int";
      } else if (pair.v is DreamDouble) {
        type = "float";
      } else if(pair.v is DreamTexture) {
        type = 'sampler2D';
      }

      buffer.write('uniform $type $key; \n');
    }

    return buffer.toString();
  }



  static String _analyze(String buildCode, String materialCode) {
    List<String> keys = getAllHGKeys();
    Map<String, bool> processed = {};

    for (String key in keys) {
      RegExp pattern = RegExp(key);
      if (pattern.firstMatch(buildCode) != null) {
        processed[key] = true;
      }
    }

    for (String key in keys) {
      RegExp pattern = RegExp(key);
      if (pattern.hasMatch(materialCode)) {
        processed[key] = true;
      }
    }

    StringBuffer buffer = StringBuffer();
    Iterable<String> operators = getOperators();

    for (String key in processed.keys) {
      String code = getHGCode(key);

      for (String operator in operators) {
        RegExp pattern = RegExp(operator);
        if (processed[operator] == null && pattern.hasMatch(code)) {
          processed[operator] = true;
        }
      }
    }

    for (String key in processed.keys) {
      buffer.write("${getHGCode(key)} \n\n");
    }

    return buffer.toString();
  }

}