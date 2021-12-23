import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
   const AppTextField(
      {this.controller,
      this.inputType,
      this.onChange,
      this.validator,
      this.lines,
      this.hint,
      Key? key})
      : super(key: key);
  final TextEditingController? controller;
  final TextInputType? inputType;
  final String? hint;
  final int? lines;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
      child: TextFormField(
        maxLines:lines??1 ,
        controller: controller,
        keyboardType: TextInputType.name,
        decoration: _inputDecoration(context),
        validator: validator??(a){return null;},
        onChanged: onChange,
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return  InputDecoration(
        hintText: "Enter $hint",
      labelText: hint,
        );
  }
}
