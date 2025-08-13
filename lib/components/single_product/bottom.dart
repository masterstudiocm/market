import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/single_product/variations.dart';
import 'package:market/controllers/variation_controller.dart';
import 'package:market/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/icon_button.dart';

class SingleProductBottom extends StatefulWidget {
  final Map data;
  final Map variations;

  const SingleProductBottom({super.key, required this.data, required this.variations});

  @override
  State<SingleProductBottom> createState() => _SingleProductBottomState();
}

class _SingleProductBottomState extends State<SingleProductBottom> {
  bool loading = false;
  int quantity = 1;
  final cartController = Get.find<CartController>();
  final variationController = Get.find<VariationController>();

  @override
  Widget build(BuildContext context) {
    return (widget.data['stock'] == '0' || (widget.data['product_type'] == 'simple' && widget.data['final_price'] == ''))
        ? const SizedBox()
        : Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Theme.of(context).colorScheme.grey1)),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    MsIconButton(
                      onTap: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                      icon: 'assets/icons/minus.svg',
                      iconSize: 16.0,
                    ),
                    SizedBox(
                      width: 40.0.r,
                      child: Text(quantity.toString(), textAlign: TextAlign.center),
                    ),
                    MsIconButton(
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: 'assets/icons/plus.svg',
                      iconSize: 16.0,
                    ),
                  ],
                ),
                SizedBox(width: 30.0.r),
                Expanded(
                  child: MsButton(
                    onTap: () async {
                      if (widget.data['product_type'] == 'simple' ||
                          (widget.data['product_type'] == 'variable' && variationController.selectedVariationId.value != '0')) {
                        setState(() => loading = true);
                        await cartController.add(widget.data['post_id'], variationController.selectedVariationId.value, quantity.toString());
                        setState(() => loading = false);
                      } else if (widget.variations.isNotEmpty) {
                        showModalBottomSheet(
                          useRootNavigator: true,
                          context: context,
                          builder: (context) {
                            bool modalLoading = false;
                            bool error = false;
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return MsBottomSheet(
                                  title: 'Məhsulu səbətə atmaq üçün müvafiq attributları seçin',
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0).r,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        VariationProduct(data: widget.variations),
                                        const SizedBox(height: 15.0),
                                        MsButton(
                                          onTap: () async {
                                            setState(() {
                                              error = false;
                                            });
                                            if (!modalLoading && variationController.selectedVariationId.value != '0') {
                                              setState(() {
                                                modalLoading = true;
                                              });
                                              await cartController.add(
                                                widget.data['post_id'],
                                                variationController.selectedVariationId.value,
                                                quantity.toString(),
                                              );
                                              variationController.reset();
                                              if (!context.mounted) return;
                                              Navigator.pop(context);
                                              setState(() {
                                                modalLoading = false;
                                              });
                                            } else {
                                              setState(() {
                                                error = true;
                                              });
                                            }
                                          },
                                          title: 'Səbətə at',
                                          loading: modalLoading,
                                        ),
                                        if (error) ...[
                                          SizedBox(height: 15.0.r),
                                          Row(
                                            children: [
                                              const Icon(Icons.error, color: Colors.red),
                                              SizedBox(width: 10.0.r),
                                              Expanded(
                                                child: Text(
                                                  'Bütün attributlar seçilməlidir.',
                                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    title: 'Səbətə at',
                    loading: (widget.data['product_type'] == 'variable' && widget.variations.isEmpty) ? true : loading,
                  ),
                ),
              ],
            ),
          );
  }
}
