import 'dart:developer' as d;


class DreamShader
{

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
}