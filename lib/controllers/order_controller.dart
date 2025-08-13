import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';

class OrderController {
  Future<Map<String, dynamic>> getOrders({int limit = 10, int offset = 0}) async {
    List orders = [];
    bool noOrders = false;

    final result = await httpRequest('${App.domain}/api/orders.php?action=get&limit=$limit&offset=$offset');

    final payload = result['payload'];

    if (payload['status'] == 'success') {
      orders = payload['result'];
    } else {
      noOrders = true;
    }

    return {...result, 'orders': orders, 'noOrders': noOrders};
  }

  Future<Map<String, dynamic>> get(String id) async {
    Map data = {};

    Map result = await httpRequest('${App.domain}/api/orders.php?action=get&order_id=$id');

    final payload = result['payload'];

    if (payload['status'] == 'success') {
      data = payload['result'];
    }

    return {...result, 'data': data};
  }
}
