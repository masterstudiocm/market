import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/controllers/page_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/html.dart';
import 'package:market/widgets/refresh_indicator.dart';
import 'package:market/widgets_extra/appbar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  Map data = <dynamic, dynamic>{};

  final PagePostController pageController = PagePostController();

  late PackageInfo _packageInfo;

  Future<void> get() async {
    if (!loading) setState(() => loading = true);
    Map result = await pageController.get(2);
    setStateSafe(() {
      loading = false;
      serverError = result['serverError'];
      connectError = result['connectError'];
      data = result['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    get();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.bg,
      appBar: MsAppBar(title: const Text('Haqqımızda')),
      body: MsRefreshIndicator(
        onRefresh: get,
        child: ListView(
          padding: EdgeInsets.fromLTRB(15.r, 15.r, 15.r, MediaQuery.of(context).padding.bottom + 15.r),
          children: <Widget>[
            SizedBox(height: 15.0.r),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0.r),
                child: Image.asset('assets/images/ic_launcher.png', width: 100.0.r),
              ),
            ),
            SizedBox(height: 15.0.r),
            Text(_packageInfo.appName, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            SizedBox(height: 5.0.r),
            Text(
              'Versiya: ${_packageInfo.version}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.grey5),
            ),
            SizedBox(height: 35.0.r),
            MsContainer(
              loading: loading,
              serverError: serverError,
              connectError: connectError,
              action: get,
              child: MsHtml(data: data['post_content'] ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
