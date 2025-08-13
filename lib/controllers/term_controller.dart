import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';

class TermController {
  Future<Map<String, dynamic>> getTerms({String taxonomy = 'kateqoriya'}) async {
    List terms = [];

    Map result = await httpRequest('${App.domain}/api/terms.php?action=get&taxonomy=$taxonomy');

    final payload = result['payload'];

    if (payload['status'] == 'success') {
      terms = payload['result'];
    }

    return {...result, 'terms': terms};
  }

  Future<Map<String, dynamic>> get({String slug = '', String id = '', String? taxonomy}) async {
    Map data = {};

    String url = '${App.domain}/api/terms.php?action=get';

    if (slug != '') {
      url = '$url&slug=$slug';
    } else {
      url = '$url&id=$id';
    }

    if (taxonomy != null) {
      url = '$url&taxonomy=$taxonomy';
    }

    Map result = await httpRequest(url);

    final payload = result['payload'];

    if (payload['status'] == 'success') {
      data = payload['result'];
    }

    return {...result, 'data': data};
  }
}
