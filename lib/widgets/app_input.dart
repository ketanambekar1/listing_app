import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppInput extends StatelessWidget {
  final TextEditingController? controller;
  final RxString? rxText;
  final RxString? errorTextRx;

  final String? label;
  final String? hint;
  final String? helperText;
  final int? maxLength;
  final int maxLines;

  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;

  final Widget? prefix;
  final Widget? suffix;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final FormFieldValidator<String>? validator;

  final bool isPassword;
  final RxBool? isObscureRx;
  final RxBool _internalObscure;

  AppInput({
    super.key,
    this.controller,
    this.rxText,
    this.errorTextRx,
    this.label,
    this.hint,
    this.helperText,
    this.maxLength,
    this.maxLines = 1,
    this.textStyle,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.autovalidateMode,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.onTap,
    this.validator,
    this.isPassword = false,
    this.isObscureRx,
  }) : _internalObscure = (isObscureRx ?? (isPassword ? true.obs : false.obs));

  AppInput.password({
    super.key,
    this.controller,
    this.rxText,
    this.errorTextRx,
    this.label,
    this.hint,
    this.helperText,
    this.maxLength,
    this.textStyle,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.autovalidateMode,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.onTap,
    this.validator,
    RxBool? isObscure,
  })  : isPassword = true,
        isObscureRx = isObscure,
        maxLines = 1,
        _internalObscure = (isObscure ?? true.obs);

  RxBool get _obscure => _internalObscure;

  @override
  Widget build(BuildContext context) {
    if (controller != null && rxText != null && controller!.text != rxText!.value) {
      controller!.text = rxText!.value;
      controller!.selection = TextSelection.fromPosition(
        TextPosition(offset: controller!.text.length),
      );
    }

    final baseDecoration = _buildDecoration(context);

    if (rxText != null || errorTextRx != null || isPassword) {
      return Obx(() {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          maxLines: maxLines,
          style: textStyle,
          enabled: enabled,
          readOnly: readOnly,
          autofocus: autofocus,
          onTap: onTap,
          obscureText: isPassword ? _obscure.value : false,
          decoration: baseDecoration.copyWith(
            errorText: errorTextRx?.value,
            suffixIcon: _buildSuffix(),
          ),
          autovalidateMode: autovalidateMode,
          validator: validator,
          onChanged: (v) {
            rxText?.value = v;
            onChanged?.call(v);
          },
        );
      });
    }

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      maxLines: maxLines,
      style: textStyle,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      onTap: onTap,
      obscureText: isPassword ? _obscure.value : false,
      decoration: baseDecoration.copyWith(
        suffixIcon: _buildSuffix(),
      ),
      autovalidateMode: autovalidateMode,
      validator: validator,
      onChanged: onChanged,
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helperText,
      prefixIcon: prefix ?? (prefixIcon != null ? Icon(prefixIcon) : null),
      suffixIcon: _buildSuffix(),
    );
  }

  Widget? _buildSuffix() {
    if (suffix != null) return suffix;

    final List<Widget> widgets = [];

    if (isPassword) {
      widgets.add(IconButton(
        tooltip: _obscure.value ? 'Show' : 'Hide',
        onPressed: () => _obscure.value = !_obscure.value,
        icon: Icon(_obscure.value ? Icons.visibility_off : Icons.visibility),
      ));
    }

    if (suffixIcon != null) {
      widgets.add(IconButton(
        onPressed: onSuffixTap,
        icon: Icon(suffixIcon),
      ));
    }

    if (widgets.isEmpty) return null;
    return Row(mainAxisSize: MainAxisSize.min, children: widgets);
  }
}
