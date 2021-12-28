import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({this.controller,
    this.inputType,
    this.onChange,
    this.expand=false,
    this.hint,
    Key? key})
      : super(key: key);
  final TextEditingController? controller;
  final TextInputType? inputType;
  final String? hint;
  final bool expand;

  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 200.0,
        ),
        child: TextFormField(
          maxLines: expand ? null : 1,
          controller: controller,
          // autovalidateMode: ,
          // expands:expands,
          // cursorHeight: 100,
          textAlignVertical: TextAlignVertical.top,
          keyboardType: inputType,
          decoration: _inputDecoration(context),
          toolbarOptions:const ToolbarOptions(paste: true, cut: true, selectAll: true, copy: true),
          onFieldSubmitted: (value) {
            //Validator
          },
          validator: (value) {
            if (value!.isEmpty ||
                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~@']+")
                    .hasMatch(value)) {
              return 'Enter a Field data';
            }
            return null;
          },

          onChanged: onChange,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
            color: Theme
                .of(context)
                .textTheme
                .bodyMedium!
                .color!
        ),

        borderRadius: BorderRadius.circular(4.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Theme
                .of(context)
                .buttonTheme
                .colorScheme!
                .background
        ),

        borderRadius: BorderRadius.circular(4.0),
      ),
      // errorBorder: OutlineInputBorder(
      //   borderSide: const BorderSide(
      //     color: Colors.red,
      //   ),
      //   borderRadius: BorderRadius.circular(10.0),
      // ),

      // errorText: "oops, something is not right!",
      // errorStyle: const TextStyle(
      //     color: Colors.red, fontWeight: FontWeight.bold),

      hintText: "Enter $hint",
      labelText: hint,
    );
  }
}
