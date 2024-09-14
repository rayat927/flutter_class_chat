import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_class_chat_app/components/CustomTextField.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void login() async {
    var url = Uri.parse('http://68.178.163.174:5503/user/login');
    Map body = {
      'email': email.text,
      'password': password.text
    };

    Response res = await post(url, body: body);
    var json = jsonDecode(res.body);

    if(res.statusCode == 201){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', json['user_id'].toString());
      Navigator.pushNamed(context, '/chat_list');

    }
  }

  void checkUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? user_id = prefs.getString('user_id');

    if(user_id != null){
      Navigator.pushNamed(context, '/chat_list');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              CustomTextField(controller: email, hintText: 'Email',),
              SizedBox(height: 10,),
            CustomTextField(controller: password, hintText: 'Password',),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              login();
            }, child: Text('Sign In')),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('do register'),
            )
            
          ],
        ),
      ),
    );
  }
}
