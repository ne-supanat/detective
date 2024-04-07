import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.suffixText,
    this.onChanged,
    this.onEditingComplete,
    this.hintText,
    this.validator,
  });

  final TextEditingController? controller;
  final String? suffixText;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(opacity: 1),
        errorBorder: _border(color: Colors.red),
        focusedErrorBorder: _border(color: Colors.red, opacity: 1),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        suffixText: suffixText,
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        hintText: hintText,
      ),
      cursorHeight: 16,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      validator: validator,
    );
  }

  _border({double opacity = 0.5, Color color = Colors.indigo}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color.withOpacity(opacity), width: 1.5),
      borderRadius: const BorderRadius.all(Radius.circular(99)),
    );
  }
}
