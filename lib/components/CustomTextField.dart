import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  var controller;
  var hintText;
  var maxLines;


   CustomTextField({super.key, this.controller, this.hintText, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      obscureText: false,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          gapPadding: 20,
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20)
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 20,
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20)
        ),

      ),
    );
  }
}
