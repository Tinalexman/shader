import 'dart:developer' as d;
import 'package:shade/components/math.dart';
import 'package:shade/utils/constants.dart';

class DreamShader
{

  dynamic _glProgram;
  dynamic _vertex;
  dynamic _fragment;

  dynamic get program => _glProgram;

  Map<String, Pair<int, dynamic>> uniforms = {};


  dynamic _compileShader(dynamic gl, String src, dynamic type) {
    var shader = gl.createShader(type);
    gl.shaderSource(shader, src);
    gl.compileShader(shader);

    var res = gl.getShaderParameter(shader, gl.COMPILE_STATUS);
    if (res == 0 || res == false) {
      d.log("Error compiling shader: ${gl.getShaderInfoLog(shader)}");
      return null;
    }

    return shader;
  }

  void dispose(dynamic gl) {
    gl.deleteShader(_vertex);
    gl.deleteShader(_fragment);
    gl.deleteProgram(_glProgram);
  }

   bool create(dynamic gl, String vsSource, String fsSource) {
    _vertex = _compileShader(gl, vsSource, gl.VERTEX_SHADER);
    _fragment = _compileShader(gl, fsSource, gl.FRAGMENT_SHADER);

    if(_vertex == null || _fragment == null) {
      return false;
    }

    _glProgram = gl.createProgram();

    gl.attachShader(_glProgram, _vertex);
    gl.attachShader(_glProgram, _fragment);
    gl.linkProgram(_glProgram);
    var res = gl.getProgramParameter(_glProgram, gl.LINK_STATUS);

    if (res == false || res == 0) {
      d.log("Unable to initialize the shader program");
      return false;
    }

    gl.useProgram(_glProgram);

    return true;
  }

  int getLocation(dynamic gl, String name) => gl.getUniformLocation(_glProgram, name);

  void add(dynamic gl, String name, Pair<int, dynamic> pair) {
    int location = gl.getUniformLocation(_glProgram, name);
    pair.k = location;

    dynamic value = pair.v;
    if(value is Vector2) {
      loadVector2(gl, name, value);
      value.hasChanged = false;
    } else if(value is Vector3) {
      loadVector3(gl, name, value);
      value.hasChanged = false;
    } else if(value is Vector4) {
      loadVector4(gl, name, value);
      value.hasChanged = false;
    } else if(value is DreamDouble) {
      loadDouble(gl, name, value);
      value.hasChanged = false;
    } else if(value is DreamInt) {
      loadInt(gl, name, value);
      value.hasChanged = false;
    }
  }

  void loadVector2(dynamic gl, String name, Vector2 vector) {
    Pair<int, dynamic>? variable = uniforms[name];
    if(variable != null) {
      gl.uniform2f(variable.k, vector.x, vector.y);
    }
  }

  void loadVector3(dynamic gl, String name, Vector3 vector) {
    Pair<int, dynamic>? variable = uniforms[name];
    if(variable != null) {
      gl.uniform3f(variable.k, vector.x, vector.y, vector.z);
    }
  }

  void loadVector4(dynamic gl, String name, Vector4 vector) {
    Pair<int, dynamic>? variable = uniforms[name];
    if(variable != null) {
      gl.uniform4f(variable.k, vector.x, vector.y, vector.z, vector.w);
    }
  }

  void loadDouble(dynamic gl, String name, DreamDouble val) {
    Pair<int, dynamic>? variable = uniforms[name];
    if(variable != null) {
      gl.uniform1f(variable.k, val.value);
    }
  }

  void loadInt(dynamic gl, String name, DreamInt val) {
    Pair<int, dynamic>? variable = uniforms[name];
    if(variable != null) {
      gl.uniform1i(variable.k, val.value);
    }
  }
}