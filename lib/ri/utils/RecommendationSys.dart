// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:route_it_v2/ri/utils/RetrieveUserPreference.dart';
// import 'package:document_analysis/document_analysis.dart';
//
// List A=[];//Doc Ids
// List B=[];//nested list of routes prefs
// List C=[];//user prefs
//
//
// retrieveDocId()async{
//    //A.clear();
//   var firebaseUser =  FirebaseAuth.instance.currentUser;
//   final firestoreInstance = FirebaseFirestore.instance;
//
//   FirebaseFirestore.instance
//       .collection('trip')
//       .get()
//       .then((QuerySnapshot querySnapshot) => {
//   querySnapshot.docs.forEach((doc) {
//   //print(doc.id);
//     A.add(doc.id);
//   })
//   });
//   print(A);
//   A.clear();
//  // return a;
// }
//
// retrieveRoutePreferences()async{
//   var firebaseUser = FirebaseAuth.instance.currentUser;
//   final firestoreInstance = FirebaseFirestore.instance;
//   firestoreInstance.collection('trip').get().then((querySnapshot) {
//     querySnapshot.docs.forEach((result) {
//       List X=[];
//       X.clear();
//       String a="",b="",c="",d="",e="",f="";
//       //print(result.id);
//       a=result.data()['route']['prefs']['desert'];
//       b=result.data()['route']['prefs']['forest'];
//       c=result.data()['route']['prefs']['highway'];
//       d=result.data()['route']['prefs']['mountain'];
//       e=result.data()['route']['prefs']['pilgrimage'];
//       f=result.data()['route']['prefs']['riverside'];
//       X.add(a);
//       X.add(b);
//       X.add(c);X.add(d);X.add(e);X.add(f);
//       B.add(X);
//
//
//     });
//   });
//   print(B);
//
//
//   B.clear();
//
// }
// retrieveUserRoutePreference(){
//   var firebaseUser =  FirebaseAuth.instance.currentUser;
//   final firestoreInstance = FirebaseFirestore.instance;
//
//    firestoreInstance.collection("users").doc(firebaseUser.uid).get().then((result){
//      int a=0,b=0,c=0,d=0,e=0,f=0;
//      //print(result.id);
//      a=result.data()['prefs']['desert'];
//      b=result.data()['prefs']['forest'];
//      c=result.data()['prefs']['highway'];
//      d=result.data()['prefs']['mountain'];
//      e=result.data()['prefs']['pilgrimage'];
//      f=result.data()['prefs']['riverside'];
//      C.add(a);
//      C.add(b);
//      C.add(c);C.add(d);C.add(e);C.add(f);
//   });
//   //print(a);
//
//
//  print(C);
//
//   //print("Jaccard: ${jaccardDistance(B[0], )}");//0.333...
//  // print("Cosine: ${cosineDistance(vector1, vector2)}");//0.1
// }
// cosineDist(){
//   var listInt1 = B[0];
//   var listInt2=C;
//   var listDouble = listInt1.map((i) => int.parse(i.toString()).toDouble()).toList();
//   var listDouble2 = C.map((i) => int.parse(i.toString()).toDouble()).toList();
//
//   print(listDouble);
//   print(listDouble2);
//
//
//    print("Cosine: ${1-cosineDistance(listDouble,listDouble2)}");//0.1
// }
// class RecSys extends StatefulWidget {
//   @override
//   _RecSysState createState() => _RecSysState();
// }
//
// class _RecSysState extends State<RecSys> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Test-1'),),
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(
//               child: Text('Click'),
//               onPressed: (){
//                 retrieveDocId();
//               },
//             ),
//             ElevatedButton(
//               child: Text('Route Prefs'),
//               onPressed: (){
//                 retrieveRoutePreferences();
//               },
//             ),
//             ElevatedButton(
//               child: Text('User Pref'),
//               onPressed: (){
//                 retrieveUserRoutePreference();
//               },
//             ),
//             ElevatedButton(
//               child: Text('Cosine'),
//               onPressed: (){
//                 cosineDist();
//                 // retrieveUserRoutePreference();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
