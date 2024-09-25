import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_class_chat_app/pages/ChatThread.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  List chats = [];

  void getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? user_id = prefs.getString('user_id');
    final url = Uri.parse('http://68.178.163.174:5503/user/');

    Response res = await get(url);
    var jsonData = jsonDecode(res.body);
    setState(() {
      chats = jsonData.where((el) => el['id'].toString() != user_id).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(''),
                accountEmail: Text('')),
            ListTile(
              title: Text('Notes'),
              onTap: (){
                Navigator.pushNamed(context, '/notes');
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Chat List'),
        centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for(var i in chats)
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ChatThread(user_id: i['id'].toString(),)));
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                  ),
                  child: Text('${i['name']}'),
                ),
              )
          ],
        ),
      ),

    );
  }
}
