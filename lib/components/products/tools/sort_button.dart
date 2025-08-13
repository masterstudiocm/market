import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/ecommerce.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/bottom_sheet.dart';
import 'package:market/widgets/outline_button.dart';
import 'package:market/widgets/svg_icon.dart';

class SortButton extends StatelessWidget {
  final Function(String) onChanged;
  final String selected;

  const SortButton({super.key, required this.onChanged, required this.selected});

  @override
  Widget build(BuildContext context) {
    var sortsList = Ecommerce.sorts.entries.toList();

    return Expanded(
      child: MsOutlineButton(
        onTap: () {
          showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            builder: (context) {
              return MsBottomSheet(
                title: 'Sıralama',
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Ecommerce.sorts.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      title: Text(sortsList[index].value, overflow: TextOverflow.ellipsis),
                      value: sortsList[index].key,
                      groupValue: selected,
                      onChanged: (value) {
                        onChanged(sortsList[index].key);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              );
            },
          );
        },
        height: 40.0,
        borderColor: Theme.of(context).colorScheme.grey2,
        padding: const EdgeInsets.symmetric(horizontal: 15.0).r,
        child: Row(
          children: [
            MsSvgIcon(icon: 'assets/icons/sort.svg', size: 15.0, color: Theme.of(context).colorScheme.grey5),
            SizedBox(width: 10.0.r),
            Expanded(child: Text(Ecommerce.sorts[selected]!, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}
