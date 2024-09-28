
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_class_chat_app/components/CustomTextField.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController editTitle = TextEditingController();
  TextEditingController editDescription = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  List notes = [];

  // Future<Uri> uploadPic() async {
  //
  //   //Get the file from the image picker and store it
  //   File image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //
  //   //Create a reference to the location you want to upload to in firebase
  //   StorageReference reference = _storage.ref().child("images/");
  //
  //   //Upload the file to firebase
  //   StorageUploadTask uploadTask = reference.putFile(file);
  //
  //   // Waits till the file is uploaded then stores the download url
  //   Uri location = (await uploadTask.future).downloadUrl;
  //
  //   //returns the download url
  //   return location;
  // }

  void getNotes() async{
    var snapshots = await db.collection('notes').get();

    setState(() {
      notes = snapshots.docs;
    });
  }

  void addNotes() async {
    try {
      await db.collection('notes').add({
        'title': title.text,
        'description': description.text
      });
      getNotes();
    } on FirebaseException catch (err) {
      print(err);
    }
  }

  void deleteNote(id) async {
    try {
      await db.collection('notes').doc(id).delete();
      getNotes();
    } on FirebaseException catch (err) {
      print(err);
    }
  }

  void editNote(id) async {
    try {
      await db.collection('notes').doc(id).update({
        'title': editTitle.text,
        'description': editDescription.text,
      });
      getNotes();
    } on FirebaseException catch (err) {
      print(err);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(controller: title, hintText: 'Title'),
            SizedBox(height: 10,),
            CustomTextField(controller: description, hintText: 'Description', maxLines: 3,),

            SizedBox(height: 10,),

            ElevatedButton(onPressed: (){
                addNotes();
            }, child: Text('Submit')),
            
            for(var el in notes)
              Card(
                child: Container(
                  child: Column(
                    children: [
                      Text('${el['title']}',),
                      Text('${el['description']}'),
                      Row(
                        children: [
                          IconButton(onPressed: (){
                            deleteNote(el.id);
                          }, icon: Icon(Icons.delete)),
                          
                          IconButton(onPressed: (){
                            setState(() {
                              editTitle.text = el['title'];
                              editDescription.text = el['description'];
                            });
                            showDialog(context: context, builder: (bc){
                              return AlertDialog(
                                content: Container(
                                  height: 400,
                                    width: 700,
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Material(child: CustomTextField(controller: editTitle, hintText: 'title',)),
                                        Material(child: CustomTextField(controller: editDescription,)),
                                        ElevatedButton(onPressed: (){
                                          editNote(el.id);
                                          Navigator.pop(bc);
                                        }, child: Text('Save'))
                                      ],
                                    ),
                                ),
                              );
                            });
                          }, icon: Icon(Icons.edit))
                        ],
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
