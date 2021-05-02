import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods{

  Future<void> addData(blogdata) async {

    FirebaseFirestore.instance.collection('blogs').add(blogdata).catchError((e){
      print(e);
    });

  }

  getData() async {
    return await FirebaseFirestore.instance.collection('blogs').snapshots();
  }

}