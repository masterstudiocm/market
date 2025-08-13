import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/controllers/sitedata_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/simple_notify.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/appbar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List data = [];

  final sitedataController = Get.find<SiteDataController>();

  Future<void> get() async {
    if (!loading) setState(() => loading = true);

    Map result = await httpRequest('${App.domain}/api/notify.php?action=get');
    final payload = result['payload'];

    if (payload['status'] == 'success') {
      setStateSafe(() => data = payload['result']);
      sitedataController.sitedata['notify_count'] = 0;
      AppBadgePlus.updateBadge(0);
    }

    setStateSafe(() {
      loading = false;
      serverError = result['serverError'];
      connectError = result['connectError'];
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
      appBar: MsAppBar(title: Text('Bildirişlər'.tr)),
      body: MsContainer(
        loading: loading,
        serverError: serverError,
        connectError: connectError,
        action: get,
        child: (data.isEmpty)
            ? SimpleNotify(text: 'Heç bir bildirişiniz yoxdur.')
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0).r,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  String currentDate = getDate(data[index]['notify_schedule'], format: 'dd.MM.yyyy');
                  String previousDate = index == 0 ? '' : getDate(data[index - 1]['notify_schedule'], format: 'dd.MM.yyyy');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0 || currentDate != previousDate) ...[
                        SizedBox(height: 20.0.r),
                        Text(currentDate, style: TextStyle(color: Theme.of(context).colorScheme.grey4)),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20.0).r,
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.grey2)),
                        ),
                        child: Row(
                          spacing: 15.r,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 50.0.r,
                              height: 50.0.r,
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryColor, borderRadius: BorderRadius.circular(50.0)),
                              child: MsSvgIcon(icon: 'assets/icons/bell.svg', size: 20.0, color: Theme.of(context).colorScheme.base),
                            ),
                            Expanded(
                              child: Column(
                                spacing: 5.r,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 15.r,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data[index]['notify_title'],
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0.sp),
                                        ),
                                      ),
                                      Text(
                                        getDate(data[index]['notify_schedule'], format: 'HH:mm'),
                                        style: TextStyle(color: Theme.of(context).colorScheme.grey4, fontSize: 13.0.sp),
                                      ),
                                    ],
                                  ),
                                  Text(data[index]['notify_content'], style: TextStyle(color: Theme.of(context).colorScheme.grey4)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
