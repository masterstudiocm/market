import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/orders/order_item.dart';
import 'package:market/controllers/order_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/widgets/simple_notify.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:visibility_detector/visibility_detector.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List orders = [];
  bool noOrders = false;
  int limit = 10;
  int offset = 0;
  bool loadMore = false;

  final orderController = Get.find<OrderController>();

  Future<void> get() async {
    Map result = await orderController.getOrders(limit: limit, offset: offset);
    setStateSafe(() {
      loading = false;
      loadMore = false;
      serverError = result['serverError'];
      connectError = result['connectError'];
      orders = orders + result['orders'];
      noOrders = result['noOrders'];
    });
  }

  void _refreshPage() {
    setState(() {
      offset = 0;
      loading = true;
      orders = [];
    });
    get();
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Sifarişləriniz')),
      body: SafeArea(
        child: MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: _refreshPage,
          child: (orders.isEmpty)
              ? SimpleNotify(text: 'Hazırda heç bir sifariş yoxdur.')
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0).r,
                  itemCount: orders.length + 1,
                  itemBuilder: (context, index) {
                    return (index != orders.length)
                        ? SingleOrderItem(data: orders[index])
                        : (noOrders)
                        ? const Text('Göstəriləcək başqa sifariş yoxdur.', textAlign: TextAlign.center)
                        : (orders.length < limit)
                        ? const SizedBox()
                        : VisibilityDetector(
                            key: Key('visibility_detector_${orders.length}'),
                            child: const MsIndicator(),
                            onVisibilityChanged: (visibilityInfo) {
                              var visiblePercentage = visibilityInfo.visibleFraction * 100;
                              if (visiblePercentage == 100 && !loadMore) {
                                setState(() {
                                  offset += limit;
                                  loadMore = true;
                                });
                                get();
                              }
                            },
                          );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 15.0.r);
                  },
                ),
        ),
      ),
    );
  }
}
