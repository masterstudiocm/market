import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/controllers/page_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/widgets/accordion.dart';
import 'package:market/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/html.dart';
import 'package:market/widgets/simple_notify.dart';
import 'package:market/widgets_extra/appbar.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> with TickerProviderStateMixin {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;

  List faq = [];
  Map<int, int> activeFaqItemByTab = {};

  late TabController tabController;
  final PagePostController pageController = PagePostController();

  Future<void> get() async {
    if (!loading) setState(() => loading = true);
    Map result = await pageController.get(4);
    setStateSafe(() {
      loading = false;
      serverError = result['serverError'];
      connectError = result['connectError'];
      faq = result['data']['faq_az'] ?? [];
      tabController = TabController(length: faq.length, vsync: this);
      tabController.addListener(() {
        activeFaqItemByTab[tabController.index] ??= -1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 0, vsync: this);
    get();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: faq.length,
      child: Scaffold(
        appBar: const MsAppBar(title: Text('Ən çox soruşulan suallar')),
        body: SafeArea(
          child: MsContainer(
            loading: loading,
            serverError: serverError,
            connectError: connectError,
            action: get,
            child: (faq.isEmpty)
                ? SimpleNotify(text: 'Heç bir məlumat tapılmadı')
                : Column(
                    children: [
                      SizedBox(height: 20.0.r),
                      Container(
                        height: 50.0.r,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0).r,
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.grey2, borderRadius: BorderRadius.circular(8.0).r),
                        child: TabBar(
                          controller: tabController,
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          indicatorPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                          tabs: [
                            for (var index = 0; index < faq.length; index++) ...[
                              Tab(
                                child: Text(faq[index]['f_main_heading_az'], style: TextStyle(height: 1.1), maxLines: 2, textAlign: TextAlign.center),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            for (var index = 0; index < faq.length; index++)
                              ListView(
                                padding: const EdgeInsets.all(20.0).r,
                                shrinkWrap: true,
                                children: [
                                  for (var i = 0; i < faq[index]['f_questions_az'].length; i++)
                                    MsAccordion(
                                      active: activeFaqItemByTab[index] == i,
                                      onTap: () {
                                        setState(() {
                                          if (activeFaqItemByTab[index] == i) {
                                            activeFaqItemByTab[index] = -1;
                                          } else {
                                            activeFaqItemByTab[index] = i;
                                          }
                                        });
                                      },
                                      title: Text(
                                        faq[index]['f_questions_az'][i]['f_question_az'],
                                        style: TextStyle(
                                          fontSize: 14.0.sp,
                                          height: 1.4,
                                          fontWeight: (activeFaqItemByTab[index] == i) ? FontWeight.w600 : FontWeight.w400,
                                        ),
                                      ),
                                      content: MsHtml(
                                        data: faq[index]['f_questions_az'][i]['f_answer_az'],
                                        color: Theme.of(context).colorScheme.grey6,
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
