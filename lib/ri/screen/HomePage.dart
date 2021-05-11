// import 'package:flutter/material.dart';
// import 'package:route_it_v2/ri/screen/QIBusHome.dart';
// import 'package:route_it_v2/ri/screen/RouteUpload.dart';
// import 'package:route_it_v2/ri/screen/temp.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:route_it_v2/ri/model/QiBusModel.dart';
// import 'package:route_it_v2/ri/screen/FirstPreferencePage.dart';
// import 'package:route_it_v2/ri/screen/QIBusNotification.dart';
// import 'package:route_it_v2/ri/screen/RouteUpload.dart';
// import 'package:route_it_v2/ri/screen/temp.dart';
// import 'package:route_it_v2/ri/utils/QiBusColors.dart';
// import 'package:route_it_v2/ri/utils/QiBusConstant.dart';
// import 'package:route_it_v2/ri/utils/QiBusDataGenerator.dart';
// import 'package:route_it_v2/ri/utils/QiBusExtension.dart';
// import 'package:route_it_v2/ri/utils/QiBusImages.dart';
// import 'package:route_it_v2/ri/utils/QiBusStrings.dart';
// import 'package:route_it_v2/ri/utils/QiBusWidget.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:route_it_v2/ri/utils/RecommendationSys.dart';
// import 'package:route_it_v2/ri/utils/RetrieveUserPreference.dart';
// import 'package:document_analysis/document_analysis.dart';
// import 'QIBusSearhList.dart';
// import 'QIBusSignIn.dart';
// import 'QIBusViewOffer.dart';
// import 'dart:collection';
// List docId = []; //Doc Ids
// List B = []; //nested list of routes prefs
// List userPreference = [];
// // List<TripDetails> allTripDetails=[];
// // List <String> allDocId=[];
//  var toSearchController = TextEditingController();
//  var fromSearchController = TextEditingController();
// // static TextEditingController get toSearchController => null; //user prefs
// //static TextEditingController get fromSearchController => null;
// // cosineDistForAllTripDetails() {
// //   var listInt1 = B[0];
// //   var listInt2 = userPreference;
// //   var listDouble =
// //   listInt1.map((i) => int.parse(i.toString()).toDouble()).toList();
// //   listDouble = listDouble.cast<double>();
// //   var userPreferenceDouble =
// //   userPreference.map((i) => int.parse(i.toString()).toDouble()).toList();
// //   // print("listDouble=$listDouble");
// //   // print("userPreferenceDouble=$userPreferenceDouble");
// //   // List<double> cosineValue;
// //   // for(var i=1;i<listDouble.length;i++){
// //   //   print(listDouble[i]);
// //   // }
// //   // List<double> cosineValues=[];
// //   // double x=1-cosineDistance(listDouble,userPreferenceDouble);
// //   // print(x);
// //   // print(x.runtimeType);
// //   // cosineValues.add(x);
// //   // print(cosineValues);
// //
// //   //cosineValues.add(1-cosineDistance(listDouble,userPreferenceDouble));
// //   //print(cosineValues);
// //   //print("Cosine: ${1-cosineDistance(listDouble,userPreferenceDouble)}");//0.1
// //
// //   List routeRating = B;
// //   List<double> cosineValues = [];
// //
// //   for (var i = 0; i < routeRating.length; i++) {
// //     // print(routeRating[i]);
// //     var temp = routeRating[i];
// //     //  print(routeRating[i].runtimeType);
// //     var tempDouble =
// //     temp.map((i) => int.parse(i.toString()).toDouble()).toList();
// //     tempDouble = tempDouble.cast<double>();
// //     // print(tempDouble);
// //     //print("Cosine: ${1-cosineDistance(tempDouble,userPreferenceDouble)}");
// //     double x = 1 - cosineDistance(tempDouble, userPreferenceDouble);
// //     //  print(x);
// //     //  print(x.runtimeType);
// //     cosineValues.add(x);
// //     //  print("---");
// //   }
// //   //print(cosineValues);
// //   var finalList = new Map();
// //
// //   for (var x = 0; x < cosineValues.length; x++) {
// //     finalList[docId[x]] = cosineValues[x];
// //   }
// //   // print(finalList);
// //   var sortedKeys = finalList.keys.toList(growable: false)
// //     ..sort((k1, k2) => finalList[k2].compareTo(finalList[k1]));
// //   LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
// //       key: (k) => k, value: (k) => finalList[k]);
// //   // print(sortedMap);
// //   sortedMap.forEach((key, value) {
// //     allDocId.add(key);
// //   });
// //   print('This is allDocId lis .........');
// //   print(allDocId);
// //
// // }
// // getAllTripDetailsAccordingToPreference()async {
// //
// //   final firestoreInstance = FirebaseFirestore.instance;
// //   String desc="";
// //   String title="";
// //   String tripImage="";
// //   String toCity="";
// //   String fromCity="";
// //   allDocId.forEach((element) async{
// //     await firestoreInstance.collection("trip").doc(element).get().then((value){
// //
// //         desc=(value.data()["info"]['desc']);
// //         title=(value.data()["info"]['title']);
// //         tripImage=(value.data()["info"]['photo']);
// //         toCity=(value.data()['route']["route_info"]['to']);
// //         fromCity=(value.data()['route']["route_info"]['from']);
// //
// //
// //     });
// //     if(allTripDetails.length<=allDocId.length) {
// //       allTripDetails.add(TripDetails(desc: desc,
// //         title: title,
// //         tripImage: tripImage,
// //         toCity: toCity,
// //         fromCity: fromCity,));
// //     }
// //   });
// //   print(allTripDetails);
// //
// // }
// // doThisForList()async{
// //   await cosineDistForAllTripDetails();
// //   await getAllTripDetailsAccordingToPreference();
// //   // print('all trip details');
// //   //
// // }
//
//
// retrieveRoutePreferences() async {
//   var firebaseUser = FirebaseAuth.instance.currentUser;
//   final firestoreInstance = FirebaseFirestore.instance;
//   firestoreInstance.collection('trip').get().then((querySnapshot) {
//     querySnapshot.docs.forEach((result) {
//       List X = [];
//       X.clear();
//       String a = "", b = "", c = "", d = "", e = "", f = "";
//       //print(result.id);
//       a = result.data()['route']['prefs']['desert'];
//       b = result.data()['route']['prefs']['forest'];
//       c = result.data()['route']['prefs']['highway'];
//       d = result.data()['route']['prefs']['mountain'];
//       e = result.data()['route']['prefs']['pilgrimage'];
//       f = result.data()['route']['prefs']['riverside'];
//       X.add(a);
//       X.add(b);
//       X.add(c);
//       X.add(d);
//       X.add(e);
//       X.add(f);
//       B.add(X);
//     });
//   });
//   print(B);
//
//   B.clear();
// }
//
// retrieveUserRoutePreference() {
//   var firebaseUser = FirebaseAuth.instance.currentUser;
//   final firestoreInstance = FirebaseFirestore.instance;
//
//   firestoreInstance
//       .collection("users")
//       .doc(firebaseUser.uid)
//       .get()
//       .then((result) {
//     int a = 0, b = 0, c = 0, d = 0, e = 0, f = 0;
//     //print(result.id);
//     a = result.data()['prefs']['desert'];
//     b = result.data()['prefs']['forest'];
//     c = result.data()['prefs']['highway'];
//     d = result.data()['prefs']['mountain'];
//     e = result.data()['prefs']['pilgrimage'];
//     f = result.data()['prefs']['riverside'];
//     userPreference.add(a);
//     userPreference.add(b);
//     userPreference.add(c);
//     userPreference.add(d);
//     userPreference.add(e);
//     userPreference.add(f);
//   });
//   //print(a);
//
//   print(userPreference);
// }
//
// cosineDist() {
//   var listInt1 = B[0];
//   var listInt2 = userPreference;
//   var listDouble =
//   listInt1.map((i) => int.parse(i.toString()).toDouble()).toList();
//   listDouble = listDouble.cast<double>();
//   var userPreferenceDouble =
//   userPreference.map((i) => int.parse(i.toString()).toDouble()).toList();
//   print("listDouble=$listDouble");
//   print("userPreferenceDouble=$userPreferenceDouble");
//   // List<double> cosineValue;
//   // for(var i=1;i<listDouble.length;i++){
//   //   print(listDouble[i]);
//   // }
//   // List<double> cosineValues=[];
//   // double x=1-cosineDistance(listDouble,userPreferenceDouble);
//   // print(x);
//   // print(x.runtimeType);
//   // cosineValues.add(x);
//   // print(cosineValues);
//
//   //cosineValues.add(1-cosineDistance(listDouble,userPreferenceDouble));
//   //print(cosineValues);
//   //print("Cosine: ${1-cosineDistance(listDouble,userPreferenceDouble)}");//0.1
//
//   List routeRating = B;
//   List<double> cosineValues = [];
//
//   for (var i = 0; i < routeRating.length; i++) {
//     print(routeRating[i]);
//     var temp = routeRating[i];
//   //  print(routeRating[i].runtimeType);
//     var tempDouble =
//     temp.map((i) => int.parse(i.toString()).toDouble()).toList();
//     tempDouble = tempDouble.cast<double>();
//    // print(tempDouble);
//     //print("Cosine: ${1-cosineDistance(tempDouble,userPreferenceDouble)}");
//     double x = 1 - cosineDistance(tempDouble, userPreferenceDouble);
//   //  print(x);
//   //  print(x.runtimeType);
//     cosineValues.add(x);
//   //  print("---");
//   }
//   print(cosineValues);
//   var finalList = new Map();
//
//   for (var x = 0; x < cosineValues.length; x++) {
//     finalList[docId[x]] = cosineValues[x];
//   }
//   print(finalList);
//   var sortedKeys = finalList.keys.toList(growable: false)
//     ..sort((k1, k2) => finalList[k2].compareTo(finalList[k1]));
//   LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
//       key: (k) => k, value: (k) => finalList[k]);
//  // print(sortedMap);
//  //  sortedMap.forEach((key, value) {
//  //    allDocId.add(key);
//  //  });
//  //  print('This is allDocId lis .........');
//  //  print(allDocId);
//
// }
//
// var isSelected = 0;
// List<QIBusBookingModel> mRecentList;
// List<QIBusNewOfferModel> mOfferList;
// var now = new DateTime.now();
// var count = 1;
// var formatter = new DateFormat('dd - MMM - yyyy');
// String formatted;
// String x = "";
// var toList = [];
// var fromList = [];
// var toFromList = [];
// getToList() async {
//   var firebaseUser = FirebaseAuth.instance.currentUser;
//   final firestoreInstance = FirebaseFirestore.instance;
//   // await firestoreInstance.collection("trip").doc().get().then((value){
//   //   print(value.id);
//   firestoreInstance.collection("trip").get().then((querySnapshot) {
//     print(querySnapshot);
//     querySnapshot.docs.forEach((result) {
//       //print(result.data()['route']['prefs']);
//       //print(result.id);
//       print(result.data()['route']['route_info']['to']);
//       toList.add(result.data()['route']['route_info']['to']);
//     });
//   });
// }
//
// getFromList() async {
//   // var firebaseUser = FirebaseAuth.instance.currentUser;
//   final firestoreInstance = FirebaseFirestore.instance;
//   firestoreInstance.collection("trip").get().then((querySnapshot) {
//     querySnapshot.docs.forEach((result) {
//       //print(result.id);
//       print(result.data()['route']['route_info']['from']);
//       fromList.add(result.data()['route']['route_info']['from']);
//     });
//   });
// }
//
// getToFromList() async {
//   // var firebaseUser = FirebaseAuth.instance.currentUser;
//   final firestoreInstance = FirebaseFirestore.instance;
//   // await firestoreInstance.collection("trip").doc().get().then((value){
//   //   print(value.id);
//   firestoreInstance.collection("trip").get().then((querySnapshot) {
//     //print(querySnapshot);
//     querySnapshot.docs.forEach((result) {
//       //print(result.data()['route']['prefs']);
//       //print(result.id);
//       // print(result.data()['route']['route_info']['to']);
//       if (result.data()['route']['route_info']['from'] ==
//           fromSearchController.text) {
//         print('this is id ');
//         print(result.id);
//         print(result.data()['route']['route_info']['to']);
//         toFromList.add(result.data()['route']['route_info']['to']);
//       }
//     });
//   });
//   print("###############################################");
//   // print(toFromList);
// }
//
//
//
// test() async {
//   //await retrieveDocId();
//   // await retrieveRoutePreferences();
//   // await retrieveUserRoutePreference();
//   await cosineDist();
//   //await doThisForList();
// }
// class NavigatorPage extends StatefulWidget {
//   @override
//   _NavigatorPageState createState() => _NavigatorPageState();
// }
//
//
// class _NavigatorPageState extends State<NavigatorPage> {
//
//
//   int _selectedIndex = 1;
//   static const TextStyle optionStyle =
//   TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static  List<Widget> _widgetOptions = <Widget>[
//     CheckedIn(),
//     QIBusHome(),
//     RouteUpload(),
//
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     getToList();
//     getFromList();
//     test();
//     mRecentList = QIBusGetData();
//     mOfferList = QIBusGetOffer();
//     formatted = formatter.format(now);
//     super.initState();
//
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: const Text('Route It')),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.upload_rounded),
//             label: 'Upload',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blueAccent,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
