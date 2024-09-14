


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class_chat_app/components/CustomTextField.dart';
import 'package:flutter_class_chat_app/models/Chat.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatThread extends StatefulWidget {
  String? user_id;

  ChatThread({super.key, this.user_id});

  @override
  State<ChatThread> createState() => _ChatThreadState();
}

class _ChatThreadState extends State<ChatThread> {

  late Socket socketInstance;

  TextEditingController message = TextEditingController();

  List chats = [];



  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? user_id = prefs.getString('user_id');

    Socket socket = io('http://68.178.163.174:5503/', <String, dynamic>{
      "transports": ["websocket"],
      "query": {'chatID': user_id}
    });
    socket.onConnect((_) {
      print('connect');
    });
    socket.on('receive_message', (data) {
      // var jsonData = jsonDecode(data);
      if(mounted){
        setState(() {
          chats.add(
              Chat(
                  from: data['senderChatID'],
                  to: data['receiverChatID'],
                  message: data['content']
              )
          );
        });
      }


    });
    socket.onDisconnect((_) => print('disconnect'));

    setState(() {
      socketInstance = socket;
    });
  }

  void getChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? user_id = prefs.getString('user_id');
    final url = Uri.parse('http://68.178.163.174:5503/chat?user_id=${user_id}');

    Response res = await get(url);
var jsondata = jsonDecode(res.body);
    setState(() {
      chats = jsondata.where((el) => el['sender'].toString() == widget.user_id  || el['receiver'].toString() == widget.user_id).toList().map((e) => Chat.fromJson(e)).toList();
    });
  }

  void send_message() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? user_id = prefs.getString('user_id');
    socketInstance.emit('send_message', jsonEncode({'content': message.text, 'receiverChatID': '${widget.user_id}', 'senderChatID': user_id}));
if(this.mounted){
  setState(() {
    chats.add(
        Chat(
            from: user_id,
            to: '${widget.user_id}',
            message: message.text
        )
    );
  });
}



  }

  @override
  void initState() {
    // TODO: implement initState

    connect();
    getChats();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: chats.map((chat) {
            return Align(
              alignment: chat.from == '${widget.user_id}' ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(

                constraints: BoxConstraints( maxWidth: 200),
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: chat.from == '${widget.user_id}' ? Colors.grey : Colors.blue[200],
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(
                  '${chat.message}'
                ),
              ),
            );
          }).toList(),
        ),
      ),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            children: [
              Flexible(child: CustomTextField(controller: message, hintText: 'Message',)),
              IconButton(onPressed: (){
                send_message();
              }, icon: Icon(Icons.send))
            ],
          )),
    );
  }
}
