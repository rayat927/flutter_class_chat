import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
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

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    // var url = Uri.parse('http://68.178.163.174:5503/user/login');
    // Map body = {
    //   'email': email.text,
    //   'password': password.text
    // };
    //
    // Response res = await post(url, body: body);
    // var json = jsonDecode(res.body);
    //
    // if(res.statusCode == 201){
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString('user_id', json['user_id'].toString());
    //   Navigator.pushNamed(context, '/chat_list');
    //
    // }
    try {
      await auth.signInWithEmailAndPassword(email: email.text, password: password.text);
      Navigator.pushNamed(context, '/chat_list');
    } on FirebaseAuthException catch (err) {
      if(err.code == 'wrong-password'){
        print('Wrong Password');
      } else if(err.code == 'invalid-email'){
        print('Invalid Email');
      }else if (err.code == 'user-not-found'){
        print('User not found');
      } else if(err.code == 'INVALID_LOGIN_CREDENTIALS'){
        print('Invalid Credentials');
      }
    }
  }

  void checkUser() async{
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    // String? user_id = prefs.getString('user_id');
    //
    // if(user_id != null){
    //   Navigator.pushNamed(context, '/chat_list');
    // }
    if(auth.currentUser != null){
      print('logged in');
      Future.delayed(Duration(milliseconds: 100), () {
      Navigator.pushNamed(context, '/chat_list');
      });

    }
  }
  //
  // void verifyUserPhoneNumber() {
  //   auth.verifyPhoneNumber(
  //     phoneNumber: userNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await auth.signInWithCredential(credential).then(
  //             (value) => print('Logged In Successfully'),
  //       );
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       print(e.message);
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       receivedID = verificationId;
  //       otpFieldVisibility = true;
  //       setState(() {});
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       print('TimeOut');
  //     },
  //   );
  // }
  //
  // Future<void> verifyOTPCode() async {
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //     verificationId: receivedID,
  //     smsCode: otpController.text,
  //   );
  //   await auth
  //       .signInWithCredential(credential)
  //       .then((value) => print('User Login In Successful'));
  // }

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
