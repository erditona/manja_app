import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField(
  TextEditingController controller,
  String labelText,
  TextInputType keyboardType,
) {
  List<TextInputFormatter> inputFormatters = [];

  if (keyboardType == const TextInputType.numberWithOptions(decimal: true)) {
    inputFormatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')));
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
