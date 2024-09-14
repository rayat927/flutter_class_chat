import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  var controller;
  var hintText;


   CustomTextField({super.key, this.controller, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
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
