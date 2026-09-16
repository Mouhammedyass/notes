import 'package:flutter/material.dart';

class CustomTextformfield extends StatelessWidget{
final String hinttext;
final TextEditingController myController;
final String? Function(String?)? validator;
  const CustomTextformfield({super.key, required this.hinttext, required this.myController, this.validator});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
        validator: validator,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            hintText: hinttext,
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(70)
            )
        )
    );
  }
}