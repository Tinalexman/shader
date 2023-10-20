import 'dart:async';
import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:flutter_gl/native-array/NativeArray.app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/components/math.dart';
import 'package:shade/components/mesh.dart';
import 'package:shade/components/shader.dart';
import 'package:shade/components/shape_manager.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/shader_tools.dart';
import 'package:shade/utils/widgets.dart';

import 'scene_editor_widgets.dart';

class SceneEditor extends ConsumerStatefulWidget {
  const SceneEditor({Key? key}) : super(key: key);

  @override
  ConsumerState<SceneEditor> createState() => _SceneEditorState();
}

class _SceneEditorState extends ConsumerState<SceneEditor> {
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

  late CodeBlockConfig materialConfig;

  late List<SceneTool> sceneTools;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Widget drawerWidget = const SizedBox();

  @override
  void initState() {
    super.initState();
    materialConfig = CodeBlockConfig(
      name: "material",
      returnVariable: "color",
      returnType: "vec3",
      parameters: ['vec3 pos', 'vec3 normal', 'float ID'],
      fixed: true,
      body: """
switch( int(ID) ) {
  case 1: color = vec3(0.5); break;
  case 2: color = checkerboard(pos); break;
  case 3: color = lattice(pos, vec3(sin(2.0 * PI * TIME) * 0.53, 0.12, 0.74));
}""",
      documentation: "This is the method in which lighting and textures are "
          "applied to your scene. This method should return the final "
          "'color' information calculated for this 'ray' based on the value of 'ID'. ",
    );

    sceneTools = [
      SceneTool(
        data: Boxicons.bx_plus,
        name: "Add",
        onTap: () {
          ref.watch(activeSceneEditorToolIndex.notifier).state = 0;
          setState(
            () => drawerWidget = AddShape(
              onAdd: (shape) => ref.watch(shapeManagerProvider.notifier).state.create(shape),
            ),
          );
          scaffoldKey.currentState?.openEndDrawer();
        },
        color: appYellow,
      ),
      SceneTool(
        data: Boxicons.bxs_tree,
        name: "Tree",
        onTap: () {
          ref.watch(activeSceneEditorToolIndex.notifier).state = 1;
          setState(() => drawerWidget = const ShapeTree());
          scaffoldKey.currentState?.openEndDrawer();
        },
        color: containerGreen,
      ),
      SceneTool(
        data: Boxicons.bx_pencil,
        name: "Edit",
        onTap: () {
          ref.watch(activeSceneEditorToolIndex.notifier).state = 2;
          setState(() => drawerWidget = const EditShape());
          scaffoldKey.currentState?.openEndDrawer();
        },
        color: theme,
      ),
    ];
  }

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
      height = query[1] - kToolbarHeight - kBottomNavigationBarHeight;
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

    return Scaffold(
      key: scaffoldKey,
      endDrawer: Drawer(
        width: 250.w,
        child: drawerWidget,
      ),
      onEndDrawerChanged: (change) {
        if (!change) {
          ref.watch(activeSceneEditorToolIndex.notifier).state = -1;
        }
      },
      appBar: AppBar(
        elevation: 0.0,
        leading: Image.asset(
          "assets/icon.png",
          width: 48.0,
          height: 48.0,
          fit: BoxFit.cover,
        ),
        title: Text(
          "Scene Editor",
          style: context.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 750),
            child: IconButton(
              key: ValueKey<int>(ref.read(renderProvider)),
              onPressed: () {
                int lastState = ref.watch(renderProvider.notifier).state;
                int newState = lastState == 0 ? 1 : 0;
                ref.watch(renderProvider.notifier).state = newState;
                if (newState == 1) {
                  ShaderTools.assembleShader(
                    ref,
                    ShapeFormat.generateBuildCode(
                        ref.read(shapeManagerProvider).root),
                    ShapeFormat.generateMaterialCode(
                        ref.read(shapeManagerProvider).materials),
                  ).then((shader) {
                    ref.watch(fragmentShaderProvider.notifier).state = shader;
                    ref.watch(renderProvider.notifier).state = 2;
                    setState(() {});
                  });
                }
              },
              iconSize: 32.r,
              splashRadius: 10.r,
              icon: Icon(
                ref.read(renderProvider) == 0
                    ? Icons.play_arrow_rounded
                    : Icons.stop_rounded,
                color: appYellow,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: Builder(builder: (_) {
                if (initialized) {
                  if (renderState == 2 && timer == null) {
                    timer = Timer.periodic(
                        const Duration(milliseconds: 100), animate);
                  } else {
                    clear(ref.read(glProvider), stop: true);
                    timer?.cancel();
                    timer = null;
                  }
                }

                return flutterGlPlugin.isInitialized
                    ? GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          uploadToShader(
                              x: min(
                                  max(details.localPosition.dx, 0.0), width));
                        },
                        onVerticalDragUpdate: (details) {
                          uploadToShader(
                              y: min(
                                  max(details.localPosition.dy, 0.0), height));
                        },
                        child: Texture(
                          textureId: flutterGlPlugin.textureId!,
                          filterQuality: FilterQuality.medium,
                        ),
                      )
                    : const SizedBox();
              }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: kToolbarHeight,
                width: 390.w,
                color: headerColor,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
                child: ListView.separated(
                  itemBuilder: (_, index) => BottomItem(
                    tool: sceneTools[index],
                    index: index,
                  ),
                  separatorBuilder: (_, __) => SizedBox(width: 20.w),
                  itemCount: sceneTools.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void uploadToShader({double x = -1.0, double y = -1.0}) {
    Map<String, Pair<int, dynamic>> uniforms = ref.read(shaderUniformsProvider);
    Pair<int, dynamic> pair = uniforms['MOUSE']!;
    Vector2 mouse = pair.v as Vector2;
    mouse.x = x > -1.0 ? x : mouse.x;
    mouse.y = y > -1.0 ? y : mouse.y;
  }

  void loadUniforms(DreamShader shader, dynamic gl) {
    Map<String, Pair<int, dynamic>> uniforms =
        ref.watch(shaderUniformsProvider.notifier).state;
    for (String key in uniforms.keys) {
      Pair<int, dynamic> pair = uniforms[key]!;
      shader.load(gl, pair.k, pair.v);
    }
  }

  void animate(timer) {
    Map<String, Pair<int, dynamic>> uniforms =
        ref.watch(shaderUniformsProvider.notifier).state;
    Pair<int, dynamic> timePair = uniforms['TIME']!;
    DreamDouble time = timePair.v as DreamDouble;
    time.value = DateTime.now().millisecondsSinceEpoch * 0.001;
    render();
  }

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
