import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:market/components/orders/order_info.dart';
import 'package:market/components/orders/order_progress.dart';
import 'package:market/controllers/order_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/outline_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/widgets/simple_notify.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/appbar.dart';

class SingleOrderPage extends StatefulWidget {
  final String orderId;
  const SingleOrderPage({super.key, required this.orderId});

  @override
  State<SingleOrderPage> createState() => _SingleOrderPageState();
}

class _SingleOrderPageState extends State<SingleOrderPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  Map data = {};
  List products = [];

  final orderController = Get.find<OrderController>();

  Future<void> get() async {
    if (!loading) setState(() => loading = true);
    Map result = await orderController.get(widget.orderId);
    setStateSafe(() {
      loading = false;
      serverError = result['serverError'];
      connectError = result['connectError'];
      data = result['data'];
      products = result['data']['products'] ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Sifariş detalları')),
      body: MsContainer(
        loading: loading,
        serverError: serverError,
        connectError: connectError,
        action: get,
        child: (data.isEmpty)
            ? const SimpleNotify(text: 'Heç bir sifariş tapılmadı.')
            : ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0).r,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.base),
                    child: Column(
                      spacing: 12.r,
                      children: [
                        OrderInfoItem(label: 'Sifariş tarixi', value: data['order_date']),
                        OrderInfoItem(label: 'Sifariş nömrəsi', value: data['order_number'], copy: true),
                        OrderInfoItem(label: 'Ödəniş üsulu', value: data['order_method']),
                        OrderInfoItem(label: 'Toplam ödəniş', value: '${data['order_total_price']} ${data['order_currency']}'),
                      ],
                    ),
                  ),
                  Divider(height: 10.0.r, thickness: 10.0.r, color: Theme.of(context).colorScheme.bg),
                  Container(
                    padding: const EdgeInsets.all(20.0).r,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrderProgressBar(data: data),
                        SizedBox(height: 30.0.r),
                        Text('Sifariş etdikləriniz:', style: Theme.of(context).textTheme.titleSmall),
                        SizedBox(height: 20.0.r),
                        if (products.isNotEmpty) ...[
                          Table(
                            columnWidths: {0: FixedColumnWidth(40.r), 2: FixedColumnWidth(90.r), 3: FixedColumnWidth(60.r)},
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.grey2)),
                                ),
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0).r,
                                      child: Text(
                                        '№',
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0).r,
                                      child: Text(
                                        'Məhsul',
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0).r,
                                      child: Text(
                                        'Miqdar',
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0).r,
                                      child: Text(
                                        'Toplam',
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              for (var i = 0; i < products.length; i++) ...[
                                TableRow(
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.grey2)),
                                  ),
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 15.0, 8.0).r,
                                        child: Text('${i + 1}.', style: TextStyle(fontSize: 13.0.sp)),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 15.0, 8.0).r,
                                        child: Text(
                                          removeHtmlTags(products[i]['order_product_name']),
                                          style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 15.0, 8.0).r,
                                        child: Text(
                                          '${products[i]['order_quantity']} x ${products[i]['order_single_price']} ${data['order_currency']}',
                                          style: TextStyle(fontSize: 13.0.sp),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0).r,
                                        child: Text('${products[i]['order_price']} ${data['order_currency']}', style: TextStyle(fontSize: 13.0.sp)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Divider(height: 10.0.r, thickness: 10.0.r, color: Theme.of(context).colorScheme.bg),
                  Ink(
                    color: Theme.of(context).colorScheme.base,
                    padding: const EdgeInsets.all(20.0).r,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sifarişçi məlumatları:', style: Theme.of(context).textTheme.titleSmall),
                        SizedBox(height: 10.0.r),
                        Text('${data['order_first_name']} ${data['order_last_name']}'),
                        SizedBox(height: 3.0.r),
                        Text(data['order_phone']),
                        if (data['order_email'] != '') ...[SizedBox(height: 3.0.r), Text(data['order_email'])],
                        SizedBox(height: 3.0.r),
                        Text(data['order_address']),
                        if (data['order_note'] != '') ...[SizedBox(height: 3.0.r), Text(data['order_note'])],
                        SizedBox(height: 25.0.r),
                        MsOutlineButton(
                          onTap: () {
                            SharePlus.instance.share(
                              ShareParams(text: '${App.domain}/sifaris-qeyde-alindi/?order=${data['order_id']}&value=${data['order_random']}'),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const MsSvgIcon(icon: 'assets/icons/share.svg', size: 17.0),
                              SizedBox(width: 10.0.r),
                              Text('Paylaş', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
