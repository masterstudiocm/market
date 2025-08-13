import 'package:flutter/material.dart';
import 'package:market/components/products/load_products.dart';
import 'package:market/themes/functions.dart';
import 'package:market/widgets/indicator.dart';
import 'package:market/widgets/notify.dart';
import 'package:market/widgets_extra/appbar.dart';

class SingleTaxonomyPage extends StatefulWidget {
  final String? id;
  final String? title;
  final String? slug;
  final String? taxonomy;
  final Map? data;

  const SingleTaxonomyPage({super.key, this.id, this.title, this.slug, this.taxonomy, this.data});

  @override
  State<SingleTaxonomyPage> createState() => _SingleTaxonomyPageState();
}

class _SingleTaxonomyPageState extends State<SingleTaxonomyPage> {
  String id = '';
  String title = '';
  String slug = '';
  String taxonomy = '';
  Map data = {};
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      data = widget.data!;
      id = data['term_id'];
      slug = data['term_slug'];
      title = data['term_name'];
      taxonomy = data['term_taxonomy'];
    } else {
      if (widget.id != null) id = widget.id!;
      if (widget.title != null) title = widget.title!;
      if (widget.taxonomy != null) taxonomy = widget.taxonomy!;
      if (widget.slug != null) get();
    }
  }

  Future<void> get() async {
    setState(() => loading = true);
    var data = await getDataFromSlug(widget.slug!, type: 'term');
    setStateSafe(() {
      loading = false;
      if (data != null && data.isNotEmpty) {
        title = data['term_name'];
        id = data['term_id'];
        taxonomy = data['term_taxonomy'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: Text(title)),
      body: (id != '')
          ? LoadProducts(
              disabledFilter: taxonomy,
              tools: true,
              filter: {
                taxonomy: [id],
              },
            )
          : (loading)
          ? const MsIndicator()
          : MsNotify(heading: 'Heç bir məlumat tapılmadı.'),
    );
  }
}
