import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/settings/contact_item.dart';
import 'package:market/controllers/page_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/simple_notify.dart';
import 'package:market/widgets_extra/appbar.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  Map data = {};
  final PagePostController pageController = PagePostController();

  Future<void> get() async {
    if (!loading) setState(() => loading = true);
    Map result = await pageController.get(3);
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
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Bizimlə əlaqə')),
      body: SafeArea(
        child: MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: get,
          child: (data.isEmpty)
              ? SimpleNotify(text: 'Heç bir məlumat tapılmadı')
              : ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0).r,
                  children: [
                    ContactItem(
                      title: 'Telefon',
                      image: 'assets/icons/contact.svg',
                      url: 'tel:0555085864',
                      value: data['phone'] ?? '',
                      color: Theme.of(context).colorScheme.secondaryColor,
                    ),
                    ContactItem(
                      title: 'Email',
                      image: 'assets/icons/email.svg',
                      url: 'mailto:${data['email'] ?? ''}',
                      value: data['email'],
                      color: Theme.of(context).colorScheme.secondaryColor,
                    ),
                    ContactItem(title: 'Whatsapp', image: 'assets/brands/whatsapp.svg', url: data['whatsapp'] ?? '', value: data['phone']),
                    ContactItem(
                      title: 'Facebook',
                      image: 'assets/brands/facebook.svg',
                      url: data['facebook'] ?? '',
                      value: 'Bizi Facebookda izləyin',
                    ),
                    ContactItem(
                      title: 'Instagram',
                      image: 'assets/brands/instagram.svg',
                      url: data['instagram'] ?? '',
                      value: 'Bizi Instagramda izləyin',
                    ),
                    ContactItem(title: 'X (Twitter)', image: 'assets/brands/x.svg', url: data['twitter'] ?? '', value: 'Bizi X (Twitter)da izləyin'),
                    ContactItem(title: 'TikTok', image: 'assets/brands/tik-tok.svg', url: data['tiktok'] ?? '', value: 'Bizi TikTokda izləyin'),
                    ContactItem(
                      title: 'Linkedin',
                      image: 'assets/brands/linkedin.svg',
                      url: data['linkedin'] ?? '',
                      value: 'Bizi Linkedinda izləyin',
                    ),
                    ContactItem(
                      title: 'Telegram',
                      image: 'assets/brands/telegram.svg',
                      url: data['telegram'] ?? '',
                      value: 'Bizi Telegramda izləyin',
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
