import 'package:flutter/material.dart';
import 'package:flutter_class_chat_app/pages/ChatList.dart';
import 'package:flutter_class_chat_app/pages/ChatThread.dart';
import 'package:flutter_class_chat_app/pages/Login.dart';
import 'package:flutter_class_chat_app/pages/Registration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        useMaterial3: true,
        bottomSheetTheme: BottomSheetThemeData(
        // backgroundColor: Colors.white, --> optional if you want to change the background color
        surfaceTintColor: Colors.white,
    ),),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/chat_thread': (context) => ChatThread(),
        '/chat_list': (context) => ChatList(),
        '/register': (context) => Registration(),
      },
    );
  }
}

