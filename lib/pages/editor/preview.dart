import 'dart:async';
import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:flutter_gl/native-array/NativeArray.app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/components/math.dart';
import 'package:shade/components/mesh.dart';
import 'package:shade/components/shader.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/theme.dart';

class ShaderPreview extends ConsumerStatefulWidget {
  const ShaderPreview({Key? key}) : super(key: key);

  @override
  ConsumerState<ShaderPreview> createState() => _ShaderPreviewState();
}

class _ShaderPreviewState extends ConsumerState<ShaderPreview> {
  late FlutterGlPlugin flutterGlPlugin;

  late double devicePixelRatio;
  late double width;
  late double height;

  dynamic sourceTexture;
  dynamic defaultFramebuffer;
  dynamic defaultFramebufferTexture;

  bool initialized = false;

  final double delta = 0.035;

  late DreamMesh dreamMesh;
  Timer? timer;

  @override
  void dispose() {
    flutterGlPlugin.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      List<double> query = ref.read(openGlConfigurationsProvider);

      width = query[0];
      height = query[1];
      devicePixelRatio = query[2];

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
    int renderState = ref.watch(renderProvider);

    return SizedBox(
      height: width * 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ref.read(renderStateProvider),
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: renderState == 2 ? appYellow : theme,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: width,
            height: width,
            child: Builder(builder: (_) {
              if (initialized) {
                if (renderState == 2 && timer == null) {
                  timer =
                      Timer.periodic(const Duration(milliseconds: 16), animate);
                } else {
                  clear(ref.read(glProvider), stop: true);
                  timer?.cancel();
                  timer = null;
                }
              }

              return flutterGlPlugin.isInitialized
                  ? RotatedBox(
                      quarterTurns: 0, // or 3 for other landscape mode,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          uploadToShader(x: min(max(details.localPosition.dx, 0.0), width));
                        },
                        onVerticalDragUpdate: (details) {
                          uploadToShader(y: min(max(details.localPosition.dy, 0.0), height));
                        },
                        child: Texture(
                          textureId: flutterGlPlugin.textureId!,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    )
                  : const SizedBox();
            }),
          ),
        ],
      ),
    );
  }

  void uploadToShader({double x = -1.0, double y = -1.0}) {
    Map<String, Pair<int, dynamic>> uniforms = ref.read(shaderUniformsProvider);
    Pair<int, dynamic> pair = uniforms['mouse']!;
    Vector2 mouse = pair.v as Vector2;
    mouse.x = x > -1.0 ? x : mouse.x;
    mouse.y = y > -1.0 ? y : mouse.y;
  }

  void loadUniforms(DreamShader shader, dynamic gl) {
    Map<String, Pair<int, dynamic>> uniforms = ref.watch(shaderUniformsProvider.notifier).state;
    for(String key in uniforms.keys) {
      Pair<int, dynamic> pair = uniforms[key]!;
      shader.load(gl, pair.k, pair.v);
    }
  }

  void animate(timer) => render();

  void clear(dynamic gl, {bool stop = false}) {
    gl.viewport(0, 0, (width * devicePixelRatio).toInt(),
        (height * devicePixelRatio).toInt());
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(gl.COLOR_BUFFER_BIT);

    if (stop) {
      gl.finish();
      flutterGlPlugin.updateTexture(sourceTexture);
    }
  }

  void render() {
    if (!flutterGlPlugin.isInitialized || dreamMesh.vertexArrayObject == null) {
      return;
    }

    final gl = ref.watch(glProvider);
    DreamShader shader = ref.watch(shaderProvider);
    clear(gl);

    gl.bindVertexArray(dreamMesh.vertexArrayObject);
    gl.useProgram(shader.program);
    loadUniforms(shader, gl);
    gl.drawArrays(gl.TRIANGLES, 0, dreamMesh.count);
    gl.bindVertexArray(0);
    gl.useProgram(0);
    gl.finish();

    flutterGlPlugin.updateTexture(sourceTexture);
  }

  void prepare() {
    final gl = ref.watch(glProvider);

    if (!ref
        .watch(shaderProvider.notifier)
        .state
        .create(gl, defaultVertexShader, defaultFs)) {
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
      -1,
      -1,
      0,
      1,
      -1,
      0,
      1,
      1,
      0,
      -1,
      -1,
      0,
      1,
      1,
      0,
      -1,
      1,
      0,
    ]);

    dreamMesh.create(gl, vertices);
    return dreamMesh.count;
  }
}
