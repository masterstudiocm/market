import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';

class PagePostController {
  Future<Map<String, dynamic>> get(int id) async {
    Map data = {};

    Map result = await httpRequest('${App.domain}/api/page.php?action=get&id=$id');

    final payload = result['payload'];

    if (payload['status'] == 'success') {
      data = payload['result'];
    }

    return {...result, 'data': data};
  }
}
