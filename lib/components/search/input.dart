import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market/controllers/search_controller.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/icon_button.dart';
import 'package:market/widgets/svg_icon.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<SearchProductController>();

    return Ink(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0).r,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.base),
      child: Obx(
        () => Form(
          child: TextFormField(
            controller: searchController.textController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Məhsullar üzrə axtarış...',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (searchController.keyword.value != '') ...[
                    MsIconButton(
                      borderColor: Colors.transparent,
                      onTap: () {
                        searchController.add('');
                      },
                      child: MsSvgIcon(icon: 'assets/icons/close.svg', size: 15.0, color: Theme.of(context).colorScheme.text),
                    ),
                  ],
                  MsIconButton(
                    backgroundColor: Theme.of(context).colorScheme.grey2,
                    onTap: () {
                      searchController.add(searchController.textController.text);
                    },
                    child: MsSvgIcon(icon: 'assets/icons/search.svg', size: 15.0),
                  ),
                ],
              ),
            ),
            onFieldSubmitted: (text) {
              searchController.add(text);
            },
            onChanged: (value) {
              searchController.textController.text = value;
            },
          ),
        ),
      ),
    );
  }
}
