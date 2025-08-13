import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class OrderProgressBar extends StatefulWidget {
  final Map data;
  const OrderProgressBar({super.key, required this.data});

  @override
  State<OrderProgressBar> createState() => _OrderProgressBarState();
}

class _OrderProgressBarState extends State<OrderProgressBar> {
  int currentIndex = 0;
  List statusKeys = [];

  @override
  void initState() {
    super.initState();
    Ecommerce.status.keys.toList();
    setState(() {
      statusKeys = Ecommerce.status.keys.toList();
      currentIndex = Ecommerce.status.keys.toList().indexOf(widget.data['order_status']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 110.0,
                  height: 2.0.r,
                  child: CustomPaint(painter: DottedLinePainter()),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i <= 3; i++) ...[
                  if (i <= currentIndex) ...[
                    OrderProgressBarCompletedItem(image: Ecommerce.status[statusKeys[i]][1]),
                  ] else ...[
                    OrderProgressBarItem(image: Ecommerce.status[statusKeys[i]][1]),
                  ],
                ],
              ],
            ),
          ],
        ),
        SizedBox(height: 20.0.r),
        Text(getOrderStatus(widget.data['order_status']), style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFDDDDDD)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    const double dashWidth = 5.0;
    const double dashSpace = 5.0;

    double currentX = 0.0;

    while (currentX < size.width) {
      canvas.drawLine(Offset(currentX, 0), Offset(currentX + dashWidth, 0), paint);
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class OrderProgressBarCompletedItem extends StatelessWidget {
  final String image;
  const OrderProgressBarCompletedItem({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 60.0.r,
          height: 60.0.r,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryColor.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(40.0).r,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 50.0.r,
              height: 50.0.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0).r,
                color: Theme.of(context).colorScheme.primaryColor.withValues(alpha: .4),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 40.0.r,
              height: 40.0.r,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0).r, color: Theme.of(context).colorScheme.primaryColor),
              child: MsSvgIcon(icon: image, color: Theme.of(context).colorScheme.base, size: 18.0),
            ),
          ),
        ),
      ],
    );
  }
}

class OrderProgressBarItem extends StatelessWidget {
  final String image;
  const OrderProgressBarItem({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0.r,
      height: 50.0.r,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.base,
        borderRadius: BorderRadius.circular(50.0).r,
        border: Border.all(width: 1.0, color: Theme.of(context).colorScheme.grey3),
      ),
      child: MsSvgIcon(icon: image, color: Theme.of(context).colorScheme.text),
    );
  }
}
