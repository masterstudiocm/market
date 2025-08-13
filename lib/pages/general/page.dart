import 'package:flutter/material.dart';
import 'package:market/widgets_extra/appbar.dart';

class GeneralPage extends StatelessWidget {
  final String title;
  final Widget child;
  const GeneralPage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: Text(title)),
      body: SafeArea(child: child),
    );
  }
}
