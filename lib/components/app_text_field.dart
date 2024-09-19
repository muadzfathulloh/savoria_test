import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter, TextInputType;
import 'package:savoria_test/components/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.labelText,
    this.controller,
    this.prefix,
    this.suffix,
    this.contentPadding,
    this.keyboardType,
    this.onChanged,
    this.obscureText,
    this.autofocus,
    this.focusNode,
    this.maxLines,
    this.padding,
    this.validator,
    this.labelStyle,
    this.inputFormatters,
    this.enabled,
    this.hintText,
    this.isRequired = true,
    this.disableLabel = false,
    this.onTap,
  });

  final String? labelText;
  final Function()? onTap;
  final bool isRequired;
  final bool disableLabel;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? padding;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool? obscureText;
  final bool? autofocus;
  final FocusNode? focusNode;
  final int? maxLines;
  final String? Function(String?)? validator;
  final TextStyle? labelStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!disableLabel) ...[
            Row(
              children: [
                isRequired ? const Text('* ', style: TextStyle(fontSize: 12, color: Colors.red)) : const SizedBox(),
                Text(labelText ?? 'NAMA LENGKAP', style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 5),
          ],
          GestureDetector(
            onTap: onTap,
            child: TextFormField(
              enabled: enabled ?? true,
              inputFormatters: inputFormatters,
              validator: validator,
              autofocus: autofocus ?? false,
              focusNode: focusNode,
              maxLines: maxLines ?? 1,
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: keyboardType ?? TextInputType.text,
              controller: controller,
              onChanged: onChanged,
              obscureText: obscureText ?? false,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: AppColor.grey,
                    width: 1,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: AppColor.grey,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: AppColor.grey200,
                    width: 1,
                  ),
                ),
                prefixIcon: prefix,
                prefixIconConstraints: const BoxConstraints(
                  maxHeight: 35,
                  maxWidth: 35,
                ),
                suffixIcon: suffix,
                suffixIconConstraints: const BoxConstraints(
                  maxHeight: 35,
                  maxWidth: 35,
                ),
                contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 10),
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
