import 'dart:developer' as d;
import 'package:shade/components/math.dart';
import 'package:shade/utils/constants.dart';

class DreamShader {
  dynamic _glProgram;
  dynamic _vertex;
  dynamic _fragment;

  dynamic get program => _glProgram;

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

    if (_vertex == null || _fragment == null) {
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

  int getLocation(dynamic gl, String name) =>
      gl.getUniformLocation(_glProgram, name);

  void add(dynamic gl, String name, Pair<int, dynamic> pair) {
    int location = gl.getUniformLocation(_glProgram, name);
    pair.k = location;
    dynamic value = pair.v;
    load(gl, location, value);
  }

  void load(dynamic gl, int location, dynamic value) {
    if (value is Vector2) {
      loadVector2(gl, location, value);
    } else if (value is Vector3) {
      loadVector3(gl, location, value);
    } else if (value is Vector4) {
      loadVector4(gl, location, value);
    } else if (value is DreamDouble) {
      loadDouble(gl, location, value);
    } else if (value is DreamInt) {
      loadInt(gl, location, value);
    }
  }

  void loadVector2(dynamic gl, int location, Vector2 vector) =>
      gl.uniform2f(location, vector.x, vector.y);

  void loadVector3(dynamic gl, int location, Vector3 vector) =>
      gl.uniform3f(location, vector.x, vector.y, vector.z);

  void loadVector4(dynamic gl, int location, Vector4 vector) =>
      gl.uniform4f(location, vector.x, vector.y, vector.z, vector.w);

  void loadDouble(dynamic gl, int location, DreamDouble val) =>
      gl.uniform1f(location, val.value);

  void loadInt(dynamic gl, int location, DreamInt val) =>
      gl.uniform1i(location, val.value);
}
