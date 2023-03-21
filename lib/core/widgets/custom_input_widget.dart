import 'package:flutter/material.dart';

import '../size_config.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {required this.inputController, required this.hintText});

  final TextEditingController inputController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: inputController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        fillColor: Colors.grey,
        filled: true,
        hintText: hintText,
        contentPadding: EdgeInsets.only(left: getProportionateScreenWidth(14)),
        focusColor: Color(0xffA0A0A0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter $hintText';
        } else {
          return null;
        }
      },
    );
  }
}
