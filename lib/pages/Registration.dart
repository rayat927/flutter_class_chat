import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class_chat_app/components/CustomTextField.dart';
import 'package:http/http.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  void register() async {
    // final url = Uri.parse('http://68.178.163.174:5503/user/register');
    // Map body = {
    //   'name': name.text,
    //   'email': email.text,
    //   'password': password.text,
    //   'role': 'user',
    // };
    //
    // Response res = await post(url, body: body);
    //
    // if(res.statusCode == 201){
    //   Navigator.pushNamed(context, '/');
    // }

    try {
      var result =
          await registerUserWithEmailAndPassword(email.text, password.text);
      var snapshot = await db.collection('users').add({
        'id': result!.user!.uid,
        'email': email.text,
        'password': password.text,
        'name': name.text,
        'role': 'user'
      });

      Navigator.pushNamed(context, '/');
    }catch (err) {
      print(err);
    }
  }


  Future<UserCredential?> registerUserWithEmailAndPassword(email, password) async {
    try{
      var result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return result;
    } on FirebaseAuthException catch (err){
      if(err.code == 'email-already-in-use') {
        print('User already in use');
      }
      else if(err.code == 'invalid-email'){
        print('Invalid Email');
      }
      else if(err.code == 'weak-password'){
        print('Weak Password');
      }
      else {
        print('Something went wrong');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(controller: name, hintText: 'Name',),
            SizedBox(height: 10,),
            CustomTextField(controller: email, hintText: 'Email',),
            SizedBox(height: 10,),
            CustomTextField(controller: password, hintText: 'Password',),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              register();
            }, child: Text('Sign Up')),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
              child: Text('do login'),
            )

          ],
        ),
      ),
    );
  }
}
