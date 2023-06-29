import 'dart:async';
import 'dart:developer' as d;

import 'package:flutter/material.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:flutter_gl/native-array/NativeArray.app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/shader/dream_mesh.dart';
import 'package:shade/shader/dream_shader.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/shader_preview_config.dart';

class ShaderPreview extends ConsumerStatefulWidget {
  const ShaderPreview({Key? key}) : super(key: key);

  @override
  ConsumerState<ShaderPreview> createState() => _ShaderPreviewState();
}

class _ShaderPreviewState extends ConsumerState<ShaderPreview> {
  late FlutterGlPlugin flutterGlPlugin;

  int? fboId;

  late double devicePixelRatio;
  late double width;
  late double height;

  dynamic sourceTexture;

  dynamic defaultFramebuffer;
  dynamic defaultFramebufferTexture;

  bool initialized = false;


  late DreamMesh dreamMesh;
  late Timer timer;

  @override
  void dispose() {
    flutterGlPlugin.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      MediaQueryData query = MediaQuery.of(context);

      width = query.size.width;
      height = query.size.height;
      devicePixelRatio = query.devicePixelRatio;

      flutterGlPlugin = FlutterGlPlugin();

      initPlatformState().then((_) {
        dreamMesh = DreamMesh();
        initialized = true;
      });
    }
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> options = {
      "antialias": true,
      "alpha": false,
      "width": width.toInt(),
      "height": height.toInt(),
      "dpr": devicePixelRatio,
    };

    await flutterGlPlugin.initialize(options: options);

    setState(() {});

    await Future.delayed(const Duration(milliseconds: 100));

    setup();
  }

  Future<void> setup() async {
    await flutterGlPlugin.prepareContext();

    ref.watch(glProvider.notifier).state = flutterGlPlugin.gl;

    setupDefaultFBO();
    sourceTexture = defaultFramebufferTexture;
    setState(() {});
    prepare();
  }

  void setupDefaultFBO() {
    final gl = flutterGlPlugin.gl;
    int glWidth = (width * devicePixelRatio).toInt();
    int glHeight = (height * devicePixelRatio).toInt();

    defaultFramebuffer = gl.createFramebuffer();
    defaultFramebufferTexture = gl.createTexture();
    gl.activeTexture(gl.TEXTURE0);

    gl.bindTexture(gl.TEXTURE_2D, defaultFramebufferTexture);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, glWidth, glHeight, 0, gl.RGBA,
        gl.UNSIGNED_BYTE, null);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);

    gl.bindFramebuffer(gl.FRAMEBUFFER, defaultFramebuffer);
    gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D,
        defaultFramebufferTexture, 0);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(renderProvider);

    return SizedBox(
      child: Center(
        child: SizedBox(
          width: width,
          height: width,
          child: Builder(builder: (context) {
            if(initialized) {
              render();
            }

            return flutterGlPlugin.isInitialized
                ? Texture(
                    textureId: flutterGlPlugin.textureId!,
                    filterQuality: FilterQuality.medium,
                  )
                : const SizedBox();
          }),
        ),
      ),
    );
  }

  void render() {
    if (!flutterGlPlugin.isInitialized || dreamMesh.vertexArrayObject == null) {
      return;
    }

    final gl = ref.watch(glProvider);
    DreamShader shader = ref.watch(shaderProvider);
    PreviewConfigurations config = ref.watch(configurationsProvider);

    gl.viewport(0, 0, (width * devicePixelRatio).toInt(),
        (height * devicePixelRatio).toInt());


    gl.clearColor(config.cR, config.cG, config.cB, config.cA);
    gl.clear(gl.COLOR_BUFFER_BIT);

    gl.bindVertexArray(dreamMesh.vertexArrayObject);

    gl.useProgram(shader.program);

    gl.drawArrays(gl.TRIANGLES, 0, dreamMesh.count);

    gl.bindVertexArray(0);

    gl.finish();

    flutterGlPlugin.updateTexture(sourceTexture);
  }

  void prepare() {
    final gl = ref.watch(glProvider);

    if (!ref.watch(shaderProvider.notifier).state.create(gl, defaultVs, defaultFs)) {
      d.log('Failed to initialize shaders.');
      return;
    }

    if (initVertexBuffers(gl) < 0) {
      d.log('Failed to set the positions of the vertices');
      return;
    }
  }

  int initVertexBuffers(gl) {
    var vertices = NativeFloat32Array.from([
      -0.5,
      -0.5,
      0,
      0.5,
      -0.5,
      0,
      0.5,
      0.5,
      0,
      -0.5,
      -0.5,
      0,
      0.5,
      0.5,
      0,
      -0.5,
      0.5,
      0,
    ]);

    dreamMesh.create(gl, vertices);
    return dreamMesh.count;
  }
}
