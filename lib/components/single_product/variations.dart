import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/controllers/variation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/theme.dart';

class VariationProduct extends StatefulWidget {
  final Map data;
  final Map? gallery;
  final Function(List)? changeGallery;

  const VariationProduct({super.key, required this.data, this.gallery, this.changeGallery});

  @override
  State<VariationProduct> createState() => _VariationProductState();
}

class _VariationProductState extends State<VariationProduct> with TickerProviderStateMixin {
  Map attributes = {};
  Map attrDetails = {};
  List variations = [];
  String stock = '';
  Map selectedVariation = {};

  final varController = Get.find<VariationController>();

  void get() {
    if (widget.data.isNotEmpty) {
      // {color: {3: {name: Qara, color: #000000}, 2: {name: Qırmızı, color: #ff0000}}, size: {4: {name: XS}, 5: {name: S}},
      attributes = widget.data['attr'];
      // {color: {name: Rəng, type: color}, size: {name: Ölçü, type: text}}
      attrDetails = widget.data['attr_details'];
      variations = widget.data['result'];
      attrDetails.forEach((key, value) {
        if (!varController.selecteds.containsKey(key)) {
          varController.selecteds[key] = '';
        }
        if (!varController.stockControl.containsKey(key)) {
          varController.stockControl[key] = [];
        }
      });
      // If attribute is single, detect automatically out of stock attributes
      if (attributes.length == 1) {
        varController.stockControl[attributes[0]] = [];
        for (var i = 0; i < variations.length; i++) {
          if (variations[i]['variation_stock'] == '0') {
            var singleAttr = attributes.keys.elementAt(0);
            varController.stockControl[singleAttr].add(variations[i]['variation_$singleAttr']);
          }
        }
      }
      attributes.forEach((key, value) {
        if (attributes[key].length == 1) {
          varController.selecteds[key] = value.keys.elementAt(0);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  void didUpdateWidget(covariant VariationProduct oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.from(
            attributes.entries.map((entry) {
              var attr = entry.key;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${attrDetails[attr]['name']}:', style: TextStyle(fontSize: 12.0.sp)),
                  SizedBox(height: 5.0.r),
                  SizedBox(
                    height: 35.0.r,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List<Widget>.from(
                        attributes[attr].entries.map((subEntry) {
                          return GestureDetector(
                            onTap: () {
                              if (attrDetails[attr]['type'] == 'color' && widget.gallery != null) {
                                if (widget.gallery!.isNotEmpty && widget.gallery!.containsKey(subEntry.key)) {
                                  widget.changeGallery!(widget.gallery![subEntry.key]);
                                }
                              }
                              if (!varController.stockControl[attr].contains(subEntry.key)) {
                                setState(() {
                                  varController.selecteds[attr] = subEntry.key;
                                  for (var i in variations) {
                                    var x = 0;
                                    varController.selecteds.forEach((key, value) {
                                      if (i['variation_$key'].toString() == varController.selecteds[key]) {
                                        x++;
                                      }
                                    });
                                    if (x == varController.selecteds.length) {
                                      selectedVariation = i;
                                      stock = i['variation_stock'] ?? '';
                                      varController.updateVariationId(i['variation_id'].toString());
                                      break;
                                    }
                                  }
                                  for (var a in varController.selecteds.keys) {
                                    if (a != attr) {
                                      varController.stockControl[a] = [];
                                      for (var i in variations) {
                                        if (i['variation_$attr'].toString() == subEntry.key && i['variation_stock'] == '0') {
                                          varController.stockControl[a].add(i['variation_$a'].toString());
                                        }
                                      }
                                    }
                                  }
                                });
                              }
                            },
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10.0).r,
                                child: (attrDetails[attr]['type'] == 'color')
                                    ? Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 35.0.r,
                                            height: 35.0.r,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: (varController.selecteds[attr].contains(subEntry.key))
                                                    ? Theme.of(context).colorScheme.text
                                                    : Theme.of(context).colorScheme.grey3,
                                              ),
                                              borderRadius: BorderRadius.circular(50.0).r,
                                            ),
                                            child: Tooltip(
                                              message: subEntry.value['name'],
                                              child: Container(
                                                width: 25.0.r,
                                                height: 25.0.r,
                                                decoration: BoxDecoration(
                                                  color: hexToColor(subEntry.value['color']),
                                                  borderRadius: BorderRadius.circular(50.0).r,
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (varController.stockControl[attr].contains(subEntry.key)) ...[
                                            Positioned.fill(child: CustomPaint(painter: CrossPainter())),
                                          ],
                                        ],
                                      )
                                    : Stack(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                constraints: BoxConstraints(minWidth: 42.0.r),
                                                height: 35.0.r,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.base,
                                                  borderRadius: BorderRadius.circular(3.0).r,
                                                  border: Border.all(
                                                    color: (varController.selecteds[attr].contains(subEntry.key))
                                                        ? Theme.of(context).colorScheme.text
                                                        : Theme.of(context).colorScheme.grey3,
                                                  ),
                                                ),
                                                child: Text(subEntry.value['name'].toString(), style: TextStyle(fontSize: 12.0.sp)),
                                              ),
                                            ],
                                          ),
                                          if (varController.stockControl[attr].contains(subEntry.key)) ...[
                                            Positioned.fill(child: CustomPaint(painter: CrossPainter())),
                                          ],
                                        ],
                                      ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0.r),
                ],
              );
            }),
          ),
        ),
        if (selectedVariation.isNotEmpty) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              displayPrice(context, selectedVariation, variation: true, fontSize: 22.0),
              if (stock != '' && stock != '0') ...[Text('$stock ədəd qalıb.')] else if (stock == '0') ...[const Text('Məhsul bitib')],
            ],
          ),
        ],
      ],
    );
  }
}

class CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    // Drawing lines from corner to corner
    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
