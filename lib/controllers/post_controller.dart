import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';

class PostController {
  Future<Map<String, dynamic>> getPosts({
    int limit = 10,
    int offset = 0,
    Map<String, String> filter = const {},
    List? multiple,
    String search = '',
  }) async {
    List posts = [];
    bool noPosts = false;

    String url = '${App.domain}/api/posts.php?action=get&limit=$limit&offset=$offset';

    if (filter.isNotEmpty) {
      filter.forEach((key, value) {
        url = '$url&$key=$value';
      });
    }

    if (multiple != null) {
      String ids = multiple.join(',');
      url = '$url&multiple=$ids';
    }

    if (search.isNotEmpty) {
      url = '$url&search=$search';
    }

    Map result = await httpRequest(url);
    final payload = result['payload'];

    if (payload['status'] == 'success') {
      posts = payload['result'];
    } else {
      noPosts = true;
    }

    return {...result, 'posts': posts, 'noPosts': noPosts};
  }

  Future<Map<String, dynamic>> get({String slug = '', String id = ''}) async {
    Map data = {};

    String url = '${App.domain}/api/posts.php?action=get';

    if (slug != '') {
      url = '$url&slug=$slug';
    } else {
      url = '$url&id=$id';
    }

    Map result = await httpRequest(url);
    final payload = result['payload'];

    if (payload['status'] == 'success') {
      data = payload['result'];
    }

    return {...result, 'data': data};
  }
}
