import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/theme.dart';

class Ecommerce {
  static String currency = '₼';
  static Map<String, String> sorts = {'new': 'Ən yenilər', 'expensive': 'Bahadan ucuza', 'cheap': 'Ucuzdan bahaya'};
  static Map orderStatusColors = {
    'pending': Colors.orange,
    'completed': Colors.green,
    'cargo': Colors.pink,
    'confirmed': Colors.blue,
    'canceled': Colors.red,
  };
  static Map status = {
    'pending': ['Gözləyir', 'assets/ecommerce/pending.svg'],
    'confirmed': ['Təsdiqləndi', 'assets/ecommerce/confirmed.svg'],
    'cargo': ['Kuryerə təhvil verildi.', 'assets/ecommerce/cargo.svg'],
    'completed': ['Tamamlandı', 'assets/ecommerce/completed.svg'],
  };
  static List successPaymentUrls = ['sifaris-detallari'];
  static List declinedPaymentUrls = ['odenis-bas-tutmadi'];
  static List canceledPaymentUrls = ['odenisden-imtina-edildi'];
  static double galleryHeight = 1.7 / 3;
}

String fixedPrice(dynamic price) {
  if (price == null) return '';

  try {
    double value;

    if (price is int) {
      value = price.toDouble();
    } else if (price is double) {
      value = price;
    } else if (price is String) {
      if (price.trim().isEmpty || price == 'null') return '';
      value = double.parse(price);
    } else {
      return '';
    }

    return value.toStringAsFixed(2);
  } catch (e) {
    return '';
  }
}

Widget displayPrice(BuildContext context, data, {bool variation = false, double fontSize = 15.0}) {
  String finalPrice = '';
  String price = '';
  if (data['product_type'] == 'simple') {
    if (data['sale_price'] != null && data['sale_price'] != 0 && data['sale_price'] != '') {
      finalPrice = data['final_price'];
      price = data['price'];
    } else {
      finalPrice = data['final_price'];
    }
  } else {
    if (variation) {
      if (data['variation_sale_price'] != null && data['variation_sale_price'] != 0 && data['variation_sale_price'] != '') {
        finalPrice = data['variation_final_price'];
        price = data['variation_price'];
      } else {
        finalPrice = data['variation_final_price'];
      }
    } else {
      if (data['min_price'] == data['max_price']) {
        finalPrice = data['min_price'];
      } else {
        finalPrice = '${data['min_price']} - ${data['max_price']}';
      }
    }
  }
  if (finalPrice != '') {
    if (price != '') {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 8.0,
        children: [
          Text(
            '$finalPrice ${Ecommerce.currency}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize.sp, height: 1.2),
          ),
          Text(
            '$price ${Ecommerce.currency}',
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
              decorationColor: Theme.of(context).colorScheme.grey5,
              fontSize: 12.0.sp,
              height: 1.3,
              color: Theme.of(context).colorScheme.grey4,
            ),
          ),
        ],
      );
    } else {
      return Text(
        '$finalPrice ${Ecommerce.currency}',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
      );
    }
  } else {
    return const SizedBox();
  }
}

String getOrderStatus(String status) {
  String data = 'Gözləyir';
  if (status == 'pending') {
    data = 'Gözləyir';
  } else if (status == 'confirmed') {
    data = 'Təsdiqləndi';
  } else if (status == 'completed') {
    data = 'Tamamlandı';
  } else if (status == 'canceled') {
    data = 'Ləğv edildi';
  } else if (status == 'whatsapp') {
    data = 'Whatsapp sifarişi';
  } else if (status == 'waiting-payment') {
    data = 'Ödəniş edilməyib';
  } else if (status == 'cargo') {
    data = 'Kuryerə verildi';
  }
  return data;
}

String getPaymentMethod(String method) {
  String method = 'Qapıda ödəniş';
  if (method == 'online') {
    method = 'Onlayn ödəniş';
  } else if (method == 'offline') {
    method = 'Qapıda ödəniş';
  }
  return method;
}
