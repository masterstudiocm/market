import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/sitedata_controller.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/checkbox.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/outline_button.dart';
import 'package:market/widgets/simple_notify.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterPage extends StatefulWidget {
  final Map filter;
  final List? price;
  final String? disabled;

  const FilterPage({super.key, required this.filter, this.price, this.disabled});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  Map data = {};
  Map variables = {};
  Map selecteds = {};
  Map selectedNames = {};
  List localSelects = [];
  List price = [0, 500.0];
  SfRangeValues priceRange = const SfRangeValues(0.0, 500.0);
  int maxPrice = 0;
  double interval = 10.0;
  String error = '';

  final sitedataController = Get.find<SiteDataController>();

  Future<void> get() async {
    Map result = await httpRequest('${App.domain}/api/filter.php?action=get');
    final payload = result['payload'];

    setStateSafe(() {
      loading = false;
      serverError = result['serverError'];
      connectError = result['connectError'];

      if (payload['status'] == 'success') {
        data = payload['result'];
        for (var item in data.keys) {
          selecteds[item] = widget.filter[item] ?? [];
          variables[item] = data[item]['terms'];
        }
        getNames();
      } else if (payload['status'] == 'error') {
        error = payload['error'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    maxPrice = double.parse(sitedataController.sitedata['max_price']).ceil();
    if (widget.price != null && widget.price!.isNotEmpty) {
      price = widget.price!;
      priceRange = SfRangeValues(widget.price![0], widget.price![1]);
    } else {
      price = [0.0, maxPrice];
      priceRange = SfRangeValues(0.0, maxPrice);
      interval = double.parse((maxPrice / 6).ceil().toString());
    }
    get();
  }

  void getNames() {
    selecteds.forEach((key, value) {
      selectedNames[key] = [];
      for (var index in value) {
        selectedNames[key].add(data[key]['terms'][index]['term_name']);
      }
    });
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      serverError = false;
      connectError = false;
      data = {};
      variables = {};
      selecteds = {};
      selectedNames = {};
      localSelects = [];
      price = [0, 500.0];
      priceRange = const SfRangeValues(0.0, 500.0);
      maxPrice = 0;
      interval = 10.0;
      error = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(
        title: const Text('Filter'),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                selecteds.forEach((key, value) {
                  if (key != widget.disabled) {
                    selecteds[key] = [];
                  }
                });
                selectedNames = {};
                localSelects = [];
                price = [0.0, maxPrice];
                priceRange = SfRangeValues(0.0, maxPrice);
              });
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(right: 20.0).r,
                alignment: Alignment.center,
                child: Text(
                  'Təmizlə',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
      body: MsContainer(
        loading: loading,
        serverError: serverError,
        connectError: connectError,
        action: _refreshPage,
        child: (error != '')
            ? SimpleNotify(text: error)
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0).r,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.keys.length,
                          itemBuilder: (context, index) {
                            final attr = variables.keys.elementAt(index);
                            if (attr != widget.disabled) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.grey2)),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      localSelects = localSelects + selecteds[attr];
                                      localSelects = localSelects.toSet().toList();
                                    });
                                    showModalBottomSheet(
                                      context: context,
                                      isDismissible: false,
                                      enableDrag: false,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter stateSetter) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: variables[attr].length,
                                                    itemBuilder: (c, i) {
                                                      final item = variables[attr].keys.elementAt(i);

                                                      return MsCheckbox(
                                                        value: localSelects.contains(item),
                                                        onChanged: (value) {
                                                          stateSetter(() {
                                                            if (value == false) {
                                                              localSelects.remove(item);
                                                            } else {
                                                              if (!localSelects.contains(item)) {
                                                                localSelects.add(item);
                                                              }
                                                            }
                                                          });
                                                        },
                                                        title: (data[attr]['type'] == 'color')
                                                            ? Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    width: 25.0.r,
                                                                    height: 25.0.r,
                                                                    decoration: BoxDecoration(
                                                                      color: hexToColor(variables[attr][item]['color']),
                                                                      borderRadius: BorderRadius.circular(25.0).r,
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 15.0.r),
                                                                  Text(
                                                                    variables[attr][item]['term_name'],
                                                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0.sp),
                                                                  ),
                                                                ],
                                                              )
                                                            : Text(
                                                                variables[attr][item]['term_name'],
                                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0.sp),
                                                              ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  padding: const EdgeInsets.all(15.0).r,
                                                  decoration: BoxDecoration(
                                                    border: Border(top: BorderSide(color: Theme.of(context).colorScheme.grey2)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      MsOutlineButton(
                                                        onTap: () {
                                                          setState(() {
                                                            localSelects = [];
                                                            getNames();
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                        height: 45.0,
                                                        title: 'İmtina et',
                                                      ),
                                                      SizedBox(width: 10.0.r),
                                                      MsButton(
                                                        onTap: () {
                                                          setState(() {
                                                            selecteds[attr] = localSelects;
                                                            getNames();
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                        height: 45.0,
                                                        title: 'Təsdiqlə',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ).whenComplete(() {
                                      setState(() {
                                        localSelects = [];
                                      });
                                    });
                                  },
                                  contentPadding: const EdgeInsets.symmetric(vertical: 5.0).r,
                                  title: Text(data[data.keys.elementAt(index)]['name'].toString(), style: TextStyle(fontSize: 17.0.sp)),
                                  subtitle: (selectedNames[attr] != null && selectedNames[attr].length != 0)
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 7.0.r),
                                            Text(selectedNames[attr].join(', '), style: TextStyle(color: Theme.of(context).colorScheme.grey4)),
                                          ],
                                        )
                                      : null,
                                  trailing: Icon(Icons.keyboard_arrow_down, size: 20.0.r),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0).r,
                              child: Text('Qiymət aralığı', style: TextStyle(fontSize: 17.0.sp)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0).r,
                              child: SfRangeSlider(
                                min: 0.0,
                                max: maxPrice,
                                stepSize: 1.0,
                                values: priceRange,
                                interval: interval,
                                showTicks: true,
                                showLabels: true,
                                enableTooltip: true,
                                minorTicksPerInterval: 1,
                                onChanged: (SfRangeValues values) {
                                  setState(() {
                                    priceRange = values;
                                    price = [priceRange.start, priceRange.end];
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0).r,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${price[0].ceil().toString()} ${Ecommerce.currency}'),
                                  Text('${price[1].ceil().toString()} ${Ecommerce.currency}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Ink(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0).r,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.grey2)),
                    ),
                    child: MsButton(
                      onTap: () {
                        Navigator.pop(context, {'filter': selecteds, 'price': price});
                      },
                      title: 'Filterlə',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
