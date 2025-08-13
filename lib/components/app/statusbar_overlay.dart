import 'package:flutter/material.dart';

class StatusbarOverlay extends StatelessWidget {
  const StatusbarOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top,
      color: const Color.fromARGB(107, 0, 0, 0),
    );
  }
}
