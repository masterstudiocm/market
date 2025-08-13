import 'package:flutter/material.dart';
import 'package:market/components/products/load_products.dart';
import 'package:market/pages/ecommerce/single_product.dart';
import 'package:market/pages/ecommerce/single_taxonomy.dart';
import 'package:market/pages/general/page.dart';
import 'package:market/pages/general/single_post.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/mehsul-kateqoriyasi/': (context) {
      final arguments = ModalRoute.of(context)!.settings.arguments as List?;
      return SingleTaxonomyPage(slug: arguments?.isNotEmpty == true ? arguments![0] as String : null, taxonomy: 'mehsul-kateqoriyasi');
    },
    '/brand/': (context) {
      final arguments = ModalRoute.of(context)!.settings.arguments as List?;
      return SingleTaxonomyPage(slug: arguments?.isNotEmpty == true ? arguments![0] as String : null, taxonomy: 'brand');
    },
    '/product/': (context) {
      final arguments = ModalRoute.of(context)!.settings.arguments as List?;
      return SingleProductPage(slug: arguments?.isNotEmpty == true ? arguments![0] as String : null);
    },
    '/products/': (context) {
      return const GeneralPage(title: 'Bütün məhsullar', child: LoadProducts());
    },
    '/post/': (context) {
      final arguments = ModalRoute.of(context)!.settings.arguments as List?;
      return SinglePostPage(slug: arguments?.isNotEmpty == true ? arguments![0] as String : null);
    },
  };
}
