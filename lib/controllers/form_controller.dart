import 'dart:io';

import 'package:dio/dio.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets_extra/snackbar.dart';

class FormController {
  String data = '';

  Future<Map<String, dynamic>> send({
    required String form,
    required Map<String, dynamic> fields,
    File? file,
    List<File>? files,
    ProgressCallback? onProgress,
  }) async {
    final Map<String, dynamic> formMap = Map.from(fields);

    if (file != null) {
      formMap['file'] = await MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
    }

    if (files != null && files.isNotEmpty) {
      formMap['file[]'] = [for (var f in files) await MultipartFile.fromFile(f.path, filename: f.path.split('/').last)];
    }

    FormData formData = FormData.fromMap(formMap);

    Map result = await httpRequest('${App.domain}/api/form.php?form=$form', fields: formData, onProgress: onProgress, snackbar: true);

    final payload = result['payload'];

    if (payload['status'] == 'success') {
      data = payload['result'];
    } else if (payload['status'] == 'error') {
      SnackbarGlobal.show(payload['error']);
    }

    return {'data': data};
  }
}
