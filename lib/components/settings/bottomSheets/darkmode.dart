import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/controllers/darkmode_controller.dart';
import 'package:market/widgets/bottom_sheet.dart';

class DarkModeBottomSheet extends StatefulWidget {
  const DarkModeBottomSheet({super.key});

  @override
  State<DarkModeBottomSheet> createState() => _DarkModeBottomSheetState();
}

class _DarkModeBottomSheetState extends State<DarkModeBottomSheet> {
  final darkModeController = Get.find<DarkModeController>();

  @override
  Widget build(BuildContext context) {
    return MsBottomSheet(
      title: 'Tətbiqin görünümü',
      child: Obx(
        () => Column(
          children: darkModeController.modes.entries.map((MapEntry entry) {
            return RadioListTile(
              title: Text(entry.value),
              value: entry.key,
              groupValue: darkModeController.mode.value,
              onChanged: (value) {
                darkModeController.update(value);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
