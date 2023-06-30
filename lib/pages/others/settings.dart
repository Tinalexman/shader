import 'package:flutter/material.dart';
import 'package:shade/utils/constants.dart';
import 'package:shade/utils/theme.dart';




class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainDark,
      appBar: AppBar(
        title: Text("Shade Settings", style: context.textTheme.headlineSmall!.copyWith(color: theme),),
        elevation: 0.0,
        backgroundColor: mainDark,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}
