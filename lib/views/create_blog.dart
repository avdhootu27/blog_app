import 'dart:io';

import 'package:blog_app/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  String authorName, title, description;
  CrudMethods crudMethods = new CrudMethods();
  File selectedImage;
  bool _isLoading = false;

  Future getImage() async {
    try {
      final image = await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        selectedImage = File(image.path);
      });
    }
    catch(platformException){
      print('not allowing '+ platformException);
    }
  }

  Future<void> uploadBlog() async {
    String name = '${randomAlphaNumeric(9)}.jpg';
    setState(() {
      _isLoading = true;
    });
    if(selectedImage != null){
      firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child('blogImages').child(name);

      final firebase_storage.TaskSnapshot task = await firebaseStorageRef.putFile(selectedImage);
      var downloadUrl;
      if(task.state == firebase_storage.TaskState.success){
        downloadUrl = await task.ref.getDownloadURL();
        print('****this is url : $downloadUrl');

        Map<String, String> blogMap ={
          'imageUrl': downloadUrl,
          'authorname': authorName,
          'title': title,
          'description': description
        };
        crudMethods.addData(blogMap).then((result){
          Navigator.pop(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flutter', style: TextStyle(
              fontSize: 22,

            )),
            Text('Blog', style: TextStyle(
              fontSize: 22,
              color: Colors.blue,
            ))
          ],
        ),
        // backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.file_upload),
            ),
          ),
        ],
      ),
      body: _isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) : Container(
        margin: EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: selectedImage != null ? Container(
                height: 200, width: MediaQuery.of(context).size.width,

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.file(
                    selectedImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ) : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                ),
                height: 200, width: MediaQuery.of(context).size.width,
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 18,),
            TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Author Name',
              ),
              onChanged: (val){
                authorName = val;
              },
            ),
            TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Title',
              ),
              onChanged: (val){
                title = val;
              },
            ),
            TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
              onChanged: (val){
                description = val;
              },
            ),
          ],
        ),
      ),
    );
  }
}
