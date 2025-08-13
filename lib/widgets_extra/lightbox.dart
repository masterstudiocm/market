import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/fullscreen_controller.dart';
import 'package:market/widgets/icon_button.dart';

class MsLightbox extends StatefulWidget {
  final Widget child;

  const MsLightbox({super.key, required this.child});

  @override
  State<MsLightbox> createState() => _MsLightboxState();
}

class _MsLightboxState extends State<MsLightbox> {
  bool dismissed = false;

  final fullscreenController = Get.put(FullscreenController());

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () {
            fullscreenController.exitFullScreen();
            return Future.value((orientation == Orientation.portrait) ? true : false);
          },
          child: Stack(
            children: [
              Obx(
                () => Dismissible(
                  onUpdate: (data) {
                    if (!dismissed && data.progress >= .5) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                        fullscreenController.exitFullScreen();
                        setState(() {
                          dismissed = true;
                        });
                      }
                    }
                  },
                  direction: (fullscreenController.fullScreen.value) ? DismissDirection.none : DismissDirection.vertical,
                  key: Key(''),
                  child: widget.child,
                ),
              ),
              Positioned(
                top: 5.0.r,
                right: 20.0,
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      MsIconButton(
                        backgroundColor: Colors.black.withValues(alpha: .5),
                        onTap: () {
                          Navigator.pop(context);
                          fullscreenController.exitFullScreen();
                        },
                        child: Icon(Icons.close, color: Colors.white, size: 24.0.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
