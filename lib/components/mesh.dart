import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_gl/native-array/NativeArray.app.dart';


class DreamMesh
{

  dynamic _vertexArrayObject;
  late int count;



  DreamMesh();

  dynamic get vertexArrayObject => _vertexArrayObject;


  void create(dynamic gl, NativeFloat32Array vertices) {

    // var vertices = NativeFloat32Array.from([
    //   -0.5, -0.5, 0, // Vertex #2
    //   0.5, -0.5, 0, // Vertex #3
    //   0, 0.5, 0, // Vertex #1
    // ]);

    _vertexArrayObject = gl.createVertexArray();
    gl.bindVertexArray(_vertexArrayObject);

    _createBuffer(gl, 0, 3, vertices);

    count = vertices.length ~/ 3;
  }


  void _createBuffer(dynamic gl, int location, int size, NativeFloat32Array data) {
    var vertexBuffer = gl.createBuffer();
    if (vertexBuffer == null) {
      log('Failed to create a buffer object');
      return;
    }

    gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, data.lengthInBytes, data, gl.STATIC_DRAW);

    gl.vertexAttribPointer(location, size, gl.FLOAT, false, Float32List.bytesPerElement * size, 0);
    gl.enableVertexAttribArray(location);
  }


}