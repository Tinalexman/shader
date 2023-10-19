import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/functions.dart';
import 'package:shade/utils/providers.dart';
import 'package:shade/utils/widgets.dart';


class TextureEditor extends StatefulWidget {
  const TextureEditor({super.key});

  @override
  State<TextureEditor> createState() => _TextureEditorState();
}

class _TextureEditorState extends State<TextureEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Image.asset(
          "assets/icon.png",
          width: 48.0,
          height: 48.0,
          fit: BoxFit.cover,
        ),
        title: Text(
          "Texture Editor",
          style: context.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            iconSize: 26.r,
            splashRadius: 20.r,
            icon: const Icon(Icons.menu_rounded, color: appYellow),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2.0,
        child: Icon(
          Icons.add_rounded,
          color: mainDark,
          size: 26.r,
        ),
        onPressed: () {},
      ),
    );
  }
}
