import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/themes/theme.dart';

class MsFileFormField extends StatelessWidget {
  final File? initialFile;
  final List<String> allowedExtensions;
  final FormFieldValidator<File>? validator;
  final ValueChanged<File?>? onChanged;

  const MsFileFormField({super.key, this.initialFile, this.allowedExtensions = const ['pdf', 'doc', 'docx'], this.validator, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FormField<File>(
      initialValue: initialFile,
      validator: validator,
      builder: (field) {
        File? file = field.value;
        String? fileName = file?.path.split('/').last;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0.r)),
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: allowedExtensions);

                if (result != null && result.files.single.path != null) {
                  File selectedFile = File(result.files.single.path!);
                  field.didChange(selectedFile);
                  field.validate();
                  onChanged?.call(selectedFile);
                }
              },
              child: Ink(
                padding: EdgeInsets.all(20.0.r),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: field.hasError ? Theme.of(context).colorScheme.errorText : Theme.of(context).colorScheme.border,
                  ),
                  borderRadius: BorderRadius.circular(10.0.r),
                ),
                child: MsSvgIcon(icon: 'assets/widgets/upload.svg'),
              ),
            ),
            if (fileName != null) ...[
              SizedBox(height: 15.0.r),
              Container(
                padding: EdgeInsets.all(15.0).r,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.grey1, borderRadius: BorderRadius.circular(10.0.r)),
                child: Row(
                  spacing: 15.r,
                  children: [
                    MsSvgIcon(icon: 'assets/widgets/document.svg'),
                    Expanded(
                      child: Text(fileName, style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ],
            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(top: 5.0, left: 20.0).r,
                child: Text(
                  field.errorText!,
                  style: TextStyle(fontSize: 12.0.sp, color: Theme.of(context).colorScheme.errorText),
                ),
              ),
          ],
        );
      },
    );
  }
}
