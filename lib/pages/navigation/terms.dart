import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/terms/single_term_item.dart';
import 'package:market/controllers/term_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets_extra/appbar.dart';

class TermsPage extends StatefulWidget {
  final Map? parent;
  const TermsPage({super.key, this.parent});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List terms = [];

  final TermController termController = TermController();

  void get() async {
    setState(() => loading = true);
    Map result = await termController.getTerms(taxonomy: 'mehsul-kateqoriyasi');
    setStateSafe(() {
      loading = false;
      serverError = result['serverError'];
      connectError = result['connectError'];
      terms = result['terms'];
    });
  }

  @override
  void initState() {
    super.initState;
    if (widget.parent == null) {
      get();
    } else {
      loading = false;
      serverError = false;
      connectError = false;
      terms = widget.parent!['children'];
      terms = [widget.parent, ...terms];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Kateqoriyalar')),
      body: MsContainer(
        loading: loading,
        serverError: serverError,
        connectError: connectError,
        action: get,
        child: (terms.isEmpty)
            ? const Text('Heç bir kateqoriya tapılmadı.')
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).r,
                itemCount: terms.length,
                itemBuilder: (content, index) {
                  return SingleTermItem(data: terms[index], showAll: (index == 0 && widget.parent != null) ? true : false);
                },
                separatorBuilder: (context, index) {
                  return Divider(color: Theme.of(context).colorScheme.grey1);
                },
              ),
      ),
    );
  }
}
