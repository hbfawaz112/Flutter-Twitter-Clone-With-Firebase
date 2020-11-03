import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';


mystyle(double size , [Color color, FontWeight fw]){

  return GoogleFonts.montserrat(
      fontSize:size,
      fontWeight: fw,
      color: color
  );
}

// ignore: deprecated_member_use
CollectionReference usercollection = Firestore.instance.collection('users');

// ignore: deprecated_member_use
CollectionReference tweetcollection = Firestore.instance.collection('tweets');

StorageReference tweetpicures = FirebaseStorage.instance.ref().child('tweetpictures');