import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/welcome_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/annotated.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/pagination.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var welcomeController = Get.find<WelcomeController>();

  List items = [
    {
      "heading": "Mağazaçı olaraq onlayn və ənənəvi formada fəaliyyət göstəririk",
      "description": "Sifarişlərinizi həm rəsmi saytdan, həm mobil tətbiqdən, həmçinin filiallarımızdan əldə edə bilərsiniz.",
      "image": 'assets/welcome/welcome_01.jpg',
    },
    {
      "heading": "Geniş məhsul çeşidliliyi ilə sizə keyfiyyətli xidmət təklif edirik",
      "description": "Hər növ meyvə, tərəvəz, ət məhsulları, şirniyyatlar və s. ilə xidmətinizdəyik.",
      "image": 'assets/welcome/welcome_02.jpg',
    },
    {
      "heading": "Sizi yenilikçi interfeyse malik tətbiqimizdə görməyə çox şadıq",
      "description": "Çoxfunksional və yenilikçi tətbiq alətlərimizi kəşf edərək alış-veriş təcrübəsini maksimum yaşayın.",
      "image": 'assets/welcome/welcome_03.jpg',
    },
  ];

  double currentPage = 0.0;
  final PageController _pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double navigationHeight = 110.r;
    double contentHeight = 200.r;
    double sliderHeight = height - navigationHeight - contentHeight - MediaQuery.of(context).padding.bottom;

    return MsAnnotatedRegion(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryColor,
        body: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageViewController,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: sliderHeight,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: Theme.of(context).colorScheme.secondaryColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Image.asset(
                                      items[index]['image']!,
                                      width: double.infinity,
                                      height: sliderHeight,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0).r,
                              height: contentHeight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    items[index]['heading']!,
                                    style: TextStyle(fontSize: 19.0.sp, fontWeight: FontWeight.w500, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20.0.r),
                                  Text(
                                    items[index]['description']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white.withAlpha(100), height: 1.4, fontSize: 15.0.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      onPageChanged: (int value) {
                        setState(() {
                          currentPage = double.parse(value.toString());
                        });
                      },
                    ),
                    Positioned(
                      right: 20.r,
                      top: MediaQuery.of(context).viewPadding.top + 20.r,
                      child: MsButton(
                        onTap: () {
                          welcomeController.update(false);
                        },
                        height: 35.r,
                        title: 'Keç',
                        backgroundColor: Colors.black.withAlpha(120),
                        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0).r,
                height: navigationHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Pagination(
                      data: items,
                      activeIndex: currentPage.toInt(),
                      activeColor: Theme.of(context).colorScheme.primaryColor,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20.r),
                    MsButton(
                      height: 55.0,
                      onTap: () {
                        if ((currentPage.round() != items.length - 1)) {
                          _pageViewController.animateToPage(
                            currentPage.round() + 1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastEaseInToSlowEaseOut,
                          );
                        } else {
                          welcomeController.update(false);
                        }
                      },
                      title: 'Bitir',
                      child: (currentPage.round() != items.length - 1)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                Text(
                                  'Növbəti',
                                  style: TextStyle(color: Colors.white, fontSize: 15.0.sp, height: 1.1, fontWeight: FontWeight.w500),
                                ),
                                MsSvgIcon(icon: 'assets/arrows/arrow-right.svg', color: Colors.white),
                              ],
                            )
                          : null,
                    ),
                    SizedBox(height: 20.r),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
