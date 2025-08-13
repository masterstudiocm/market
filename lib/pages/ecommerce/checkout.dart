import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:market/components/cart/cart_total.dart';
import 'package:market/components/app/label.dart';
import 'package:market/controllers/cart_controller.dart';
import 'package:market/controllers/login_controller.dart';
import 'package:market/controllers/sitedata_controller.dart';
import 'package:market/pages/ecommerce/payment.dart';
import 'package:market/pages/ecommerce/single_order.dart';
import 'package:market/pages/ecommerce/map_picker.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/notify.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/navigator.dart';
import 'package:market/widgets_extra/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:url_launcher/url_launcher.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool serverError = false;
  bool connectError = false;
  bool whatsappButtonLoading = false;
  bool checkoutButtonLoading = false;
  bool visible = false;
  bool getLocation = false;
  bool readOnlyAddress = false;

  DateTime selectedDate = DateTime.now();

  String firstName = '';
  String lastName = '';
  String phone = '';
  String address = '';
  LatLng? latlng;
  String email = '';
  String note = '';
  String method = 'offline';
  String status = 'pending';

  List shippingDates = [];

  final loginController = Get.find<LoginController>();
  final cartController = Get.find<CartController>();
  final sitedataController = Get.find<SiteDataController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressController = TextEditingController(text: '');

  Future<void> order({String? status}) async {
    if (status == 'whatsapp') {
      setState(() => whatsappButtonLoading = true);
    } else {
      if (method == 'offline') {
        status = 'pending';
      } else {
        status = 'waiting-payment';
      }
      setState(() => checkoutButtonLoading = true);
    }

    FormData formData = FormData.fromMap({
      'first_name': firstName,
      'last_name': lastName,
      'address': _addressController.text,
      'latlng': jsonEncode(latlng),
      'phone': phone,
      'email': email,
      'note': note,
      'payment_method': method,
      'status': status,
      'platform': (Platform.isAndroid) ? 'Android' : 'IOS',
    });

    Map result = await httpRequest("${App.domain}/api/checkout.php?session_key=${loginController.userId}", fields: formData, snackbar: true);
    final payload = result['payload'];

    setStateSafe(() {
      whatsappButtonLoading = false;
      checkoutButtonLoading = false;
    });

    if (payload['status'] == 'success') {
      if (method == 'offline') {
        Get.close(1);
        if (status == 'pending') {
          setState(() {
            navigatePage(context, SingleOrderPage(orderId: payload['result']['id']));
            SnackbarGlobal.show('Sifarişiniz uğurla qeydə alındı.', type: SnackBarTypes.success);
            cartController.get();
          });
        } else {
          launchUrl(Uri.parse(payload['result']['url']));
        }
      } else {
        Get.to(() => PaymentPage(url: payload['result']['url'], orderId: payload['result']['id']));
      }
    } else if (payload['status'] == 'error') {
      SnackbarGlobal.show(payload['error'], duration: const Duration(seconds: 7));
    }
  }

  @override
  void initState() {
    super.initState();
    if (loginController.userdata.isNotEmpty) {
      firstName = loginController.userdata['first_name'] ?? '';
      lastName = loginController.userdata['last_name'] ?? '';
      phone = loginController.userdata['phone'] ?? '';
      _addressController.text = loginController.userdata['address'] ?? '';
      email = loginController.userdata['user_email'] ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Sifarişi tamamla')),
      body: (cartController.data['error'] != '')
          ? MsNotify(
              heading: 'Səbətinizdə düzəldilməsi vacib məqamlar var.',
              action: () {
                Navigator.pop(context);
              },
              buttonText: 'Səbətə qayıt',
            )
          : Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0).r,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormLabel(label: 'Adınız'),
                          TextFormField(
                            initialValue: firstName,
                            onChanged: (value) => firstName = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Adınızı qeyd etməmisiniz.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.0.r),
                          const FormLabel(label: 'Soyadınız'),
                          TextFormField(
                            initialValue: lastName,
                            onChanged: (value) => lastName = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Soyadınızı qeyd etməmisiniz.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.0.r),
                          const FormLabel(label: 'Telefon'),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            initialValue: phone,
                            onChanged: (value) => phone = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Telefon qeyd etməmisiniz.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.0.r),
                          const FormLabel(label: 'Çatdırılma ünvanı'),
                          TextFormField(
                            minLines: 1,
                            maxLines: 4,
                            controller: _addressController,
                            readOnly: readOnlyAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Çatdırılma ünvanı qeyd etməmisiniz.';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0).r,
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => MapPickerPage()));
                                      if (result != null) {
                                        _addressController.text =
                                            '${result['location']}\n\nLat: ${result['latlng'].latitude}, \nLng: ${result['latlng'].longitude}';
                                        setState(() {
                                          readOnlyAddress = true;
                                          latlng = result['latlng'];
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_searching_outlined, size: 16.0.r, color: Colors.blue),
                                        SizedBox(width: 5.0.r),
                                        Expanded(child: Text('Xəritədən seç', style: Theme.of(context).textTheme.link)),
                                      ],
                                    ),
                                  ),
                                ),
                                if (readOnlyAddress) ...[
                                  SizedBox(width: 25.0.r),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        readOnlyAddress = false;
                                      });
                                      _addressController.text = '';
                                    },
                                    child: Text('Təmizlə', style: Theme.of(context).textTheme.link),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(height: 15.0.r),
                          const FormLabel(label: 'Email', required: false),
                          TextFormField(
                            initialValue: email,
                            onChanged: (value) => email = value,
                            validator: (value) {
                              if (value != '' && !GetUtils.isEmail(value!.trim())) {
                                return 'Email düzgün deyil.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.0.r),
                          const FormLabel(label: 'Əlavə qeydiniz', required: false),
                          TextFormField(minLines: 2, maxLines: 4, initialValue: note, onChanged: (value) => note = value),
                          const SizedBox(height: 15.0),
                          const FormLabel(label: 'Ödəniş forması'),
                          RadioListTile(
                            title: const Text('Qapıda nağd ödəniş'),
                            value: 'offline',
                            groupValue: method,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              setState(() => method = value!);
                            },
                          ),
                          RadioListTile(
                            title: const Text('Onlayn ödəniş'),
                            value: 'online',
                            groupValue: method,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              setState(() => method = value!);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: (cartController.data['error'] != '')
          ? const SizedBox()
          : SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.base,
                  border: Border(top: BorderSide(color: Theme.of(context).colorScheme.grey1)),
                ),
                child: Ink(
                  color: Theme.of(context).colorScheme.base,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0).r,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Yekun məbləğ:', style: TextStyle(fontWeight: FontWeight.w600)),
                            Text(
                              '${cartController.data['final_price']} ${Ecommerce.currency}',
                              style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primaryColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0.r),
                        Row(
                          children: [
                            Expanded(
                              child: MsButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate() && !whatsappButtonLoading) {
                                    order(status: 'whatsapp');
                                  }
                                },
                                backgroundColor: Colors.green,
                                loading: whatsappButtonLoading,
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  children: [
                                    const MsSvgIcon(icon: 'assets/icons/whatsapp.svg', color: Colors.white),
                                    SizedBox(width: 10.0.r),
                                    Expanded(
                                      child: Text(
                                        'Whatsapp ilə sifariş',
                                        style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0.r),
                            Expanded(
                              child: MsButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate() && !checkoutButtonLoading) {
                                    order();
                                  }
                                },
                                loading: checkoutButtonLoading,
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'Sifarişi tətbiqdən təsdiqlə',
                                  style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class AnimatedCartTotal extends StatelessWidget {
  const AnimatedCartTotal({super.key, required this.visible, required this.cartController});

  final bool visible;
  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Visibility(
          visible: visible,
          child: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Theme.of(context).colorScheme.grey4)),
              color: Theme.of(context).colorScheme.base,
            ),
            child: const CartTotal(),
          ),
        ),
      ),
    );
  }
}
