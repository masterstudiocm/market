import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';

class AuthController {
  Future<Map<String, dynamic>> login(String username, String password) async {
    return await httpRequest('${App.domain}/api/auth.php?action=login', fields: {'username': username, 'password': password}, snackbar: true);
  }

  Future<Map<String, dynamic>> registration(Map values) async {
    return await httpRequest(
      '${App.domain}/api/auth.php?action=registration',
      fields: {
        'first_name': values['first_name'] ?? '',
        'last_name': values['last_name'] ?? '',
        'user_email': values['user_email'] ?? '',
        'user_password': values['user_password'] ?? '',
      },
      snackbar: true,
    );
  }

  Future<Map<String, dynamic>> forgotPassword(String username) async {
    return await httpRequest('${App.domain}/api/auth.php?action=reset', fields: {'username': username}, snackbar: true);
  }

  Future<Map<String, dynamic>> confirmAccount(String code, String userId) async {
    return await httpRequest('${App.domain}/api/auth.php?action=confirm', fields: {'code': code, 'user_id': userId}, snackbar: true);
  }

  Future<Map<String, dynamic>> resend(String userId) async {
    return await httpRequest('${App.domain}/api/auth.php?action=resend', fields: {'user_id': userId}, snackbar: true);
  }
}
