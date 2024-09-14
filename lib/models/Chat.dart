class Chat {
  String? to;
  String? from;
  String? message;

  Chat({this.to, this.from, this.message});

  Chat.fromJson(json){
    to = json['receiver'].toString();
    from = json['sender'].toString();
    message = json['message'];
  }
}