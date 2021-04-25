import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

 retrievePreference()async{
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  int a;
   await firestoreInstance.collection("users").doc(firebaseUser.uid).get().then((value){
    a=(value.data()["pref_flag"]);
  });
  //print(a);
  return a;
}
