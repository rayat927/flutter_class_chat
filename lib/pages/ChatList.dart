import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class_chat_app/pages/ChatThread.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with WidgetsBindingObserver {

  List chats = [];

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  void getUsers() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    // String? user_id = prefs.getString('user_id');
    // final url = Uri.parse('http://68.178.163.174:5503/user/');
    //
    // Response res = await get(url);
    // var jsonData = jsonDecode(res.body);
    // setState(() {
    //   chats = jsonData.where((el) => el['id'].toString() != user_id).toList();
    // });

    var snapshots = await db.collection('users').where('id', isNotEqualTo:  auth.currentUser!.uid).get();

    setState(() {
      chats = snapshots.docs;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('weoifjwoeipfjwoipefjoiwjfoipwjefopjwefjweoifwfowpf');
    if (state == AppLifecycleState.resumed)
    {
      var snap = await db.collection('users').where((el) => el['id'] == auth.currentUser!.uid).get();
      print(snap.docs[0]);
      await db.collection('users').doc(snap.docs[0].id).update({
        'online': true,
      });

    }
    //TODO: set status to online here in firestore
    else{
      var snap = await db.collection('users').where((el) => el['id'] == auth.currentUser!.uid).get();
      print(snap.docs[0]);
      await db.collection('users').doc(snap.docs[0].id).update({
        'online': false,
      });
    }
    //TODO: set status to offline here in firestore
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
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
