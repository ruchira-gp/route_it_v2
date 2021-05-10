import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:route_it_v2/ri/model/QiBusModel.dart';
import 'package:route_it_v2/ri/screen/FirstPreferencePage.dart';
import 'package:route_it_v2/ri/screen/QIBusNotification.dart';
import 'package:route_it_v2/ri/screen/RouteUpload.dart';
import 'package:route_it_v2/ri/screen/temp.dart';
import 'package:route_it_v2/ri/utils/QiBusColors.dart';
import 'package:route_it_v2/ri/utils/QiBusConstant.dart';
import 'package:route_it_v2/ri/utils/QiBusDataGenerator.dart';
import 'package:route_it_v2/ri/utils/QiBusExtension.dart';
import 'package:route_it_v2/ri/utils/QiBusImages.dart';
import 'package:route_it_v2/ri/utils/QiBusStrings.dart';
import 'package:route_it_v2/ri/utils/QiBusWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:route_it_v2/ri/utils/RecommendationSys.dart';
import 'package:route_it_v2/ri/utils/RetrieveUserPreference.dart';
import 'package:document_analysis/document_analysis.dart';
import 'QIBusSearhList.dart';
import 'QIBusSignIn.dart';
import 'QIBusViewOffer.dart';
import 'dart:collection';
import 'package:route_it_v2/ri/screen/HomePage.dart';
List<TripDetails> allTripDetails=[];
List <String> allDocId=[];
class QIBusHome extends StatefulWidget {
  @override
  _QIBusHomeState createState() => _QIBusHomeState();
}

class _QIBusHomeState extends State<QIBusHome> {


  cosineDistForAllTripDetails() {
    var listInt1 = B[0];
    var listInt2 = userPreference;
    var listDouble =
    listInt1.map((i) => int.parse(i.toString()).toDouble()).toList();
    listDouble = listDouble.cast<double>();
    var userPreferenceDouble =
    userPreference.map((i) => int.parse(i.toString()).toDouble()).toList();
   // print("listDouble=$listDouble");
   // print("userPreferenceDouble=$userPreferenceDouble");
    // List<double> cosineValue;
    // for(var i=1;i<listDouble.length;i++){
    //   print(listDouble[i]);
    // }
    // List<double> cosineValues=[];
    // double x=1-cosineDistance(listDouble,userPreferenceDouble);
    // print(x);
    // print(x.runtimeType);
    // cosineValues.add(x);
    // print(cosineValues);

    //cosineValues.add(1-cosineDistance(listDouble,userPreferenceDouble));
    //print(cosineValues);
    //print("Cosine: ${1-cosineDistance(listDouble,userPreferenceDouble)}");//0.1

    List routeRating = B;
    List<double> cosineValues = [];

    for (var i = 0; i < routeRating.length; i++) {
     // print(routeRating[i]);
      var temp = routeRating[i];
      //  print(routeRating[i].runtimeType);
      var tempDouble =
      temp.map((i) => int.parse(i.toString()).toDouble()).toList();
      tempDouble = tempDouble.cast<double>();
      // print(tempDouble);
      //print("Cosine: ${1-cosineDistance(tempDouble,userPreferenceDouble)}");
      double x = 1 - cosineDistance(tempDouble, userPreferenceDouble);
      //  print(x);
      //  print(x.runtimeType);
      cosineValues.add(x);
      //  print("---");
    }
    //print(cosineValues);
    var finalList = new Map();

    for (var x = 0; x < cosineValues.length; x++) {
      finalList[docId[x]] = cosineValues[x];
    }
   // print(finalList);
    var sortedKeys = finalList.keys.toList(growable: false)
      ..sort((k1, k2) => finalList[k2].compareTo(finalList[k1]));
    LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => finalList[k]);
    // print(sortedMap);
    sortedMap.forEach((key, value) {
      allDocId.add(key);
    });
    print('This is allDocId lis .........');
    print(allDocId);

  }
  getAllTripDetailsAccordingToPreference()async {

    final firestoreInstance = FirebaseFirestore.instance;
    String desc="";
    String title="";
    String tripImage="";
    String toCity="";
    String fromCity="";
    allDocId.forEach((element) async{
      await firestoreInstance.collection("trip").doc(element).get().then((value){
        setState(() {
          desc=(value.data()["info"]['desc']);
          title=(value.data()["info"]['title']);
          tripImage=(value.data()["info"]['photo']);
          toCity=(value.data()['route']["route_info"]['to']);
          fromCity=(value.data()['route']["route_info"]['from']);
        });

      });
      if(allTripDetails.length<=allDocId.length) {
        allTripDetails.add(TripDetails(desc: desc,
          title: title,
          tripImage: tripImage,
          toCity: toCity,
          fromCity: fromCity,));
      }
    });
    print(allTripDetails);

  }
  doThisForList()async{
    await cosineDistForAllTripDetails();
    await getAllTripDetailsAccordingToPreference();
   // print('all trip details');
  //
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doThisForList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: allTripDetails,
      ),
    );
  }
}

// class QIBusHome extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return QIBusHomeState();
//   }
// }
//
// class QIBusHomeState extends State<QIBusHome> {
// List docId = []; //Doc Ids
// List B = []; //nested list of routes prefs
// List userPreference = [];
//
// static var toSearchController = TextEditingController();
// static var fromSearchController = TextEditingController();
// // static TextEditingController get toSearchController => null; //user prefs
// //static TextEditingController get fromSearchController => null;
//
// retrieveDocId() async {
//   //A.clear();
//   var firebaseUser = FirebaseAuth.instance.currentUser;
//   final firestoreInstance = FirebaseFirestore.instance;
//
//   FirebaseFirestore.instance
//       .collection('trip')
//       .get()
//       .then((QuerySnapshot querySnapshot) => {
//             querySnapshot.docs.forEach((doc) {
//               //print(doc.id);
//               docId.add(doc.id);
//             })
//           });
//   print(docId);
//   docId.clear();
//   // return a;
// }
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
//
//   //print("Jaccard: ${jaccardDistance(B[0], )}");//0.333...
//   // print("Cosine: ${cosineDistance(vector1, vector2)}");//0.1
// }
//
// cosineDist() {
//   var listInt1 = B[0];
//   var listInt2 = userPreference;
//   var listDouble =
//       listInt1.map((i) => int.parse(i.toString()).toDouble()).toList();
//   listDouble = listDouble.cast<double>();
//   var userPreferenceDouble =
//       userPreference.map((i) => int.parse(i.toString()).toDouble()).toList();
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
//     print(routeRating[i].runtimeType);
//     var tempDouble =
//         temp.map((i) => int.parse(i.toString()).toDouble()).toList();
//     tempDouble = tempDouble.cast<double>();
//     print(tempDouble);
//     //print("Cosine: ${1-cosineDistance(tempDouble,userPreferenceDouble)}");
//     double x = 1 - cosineDistance(tempDouble, userPreferenceDouble);
//     print(x);
//     print(x.runtimeType);
//     cosineValues.add(x);
//     print("---");
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
//   print(sortedMap);
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
//  // var firebaseUser = FirebaseAuth.instance.currentUser;
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
//  // var firebaseUser = FirebaseAuth.instance.currentUser;
//   final firestoreInstance = FirebaseFirestore.instance;
//   // await firestoreInstance.collection("trip").doc().get().then((value){
//   //   print(value.id);
//   firestoreInstance.collection("trip").get().then((querySnapshot) {
//     //print(querySnapshot);
//     querySnapshot.docs.forEach((result) {
//       //print(result.data()['route']['prefs']);
//       //print(result.id);
//      // print(result.data()['route']['route_info']['to']);
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
//  // print(toFromList);
// }
//
//
//
//
// test() async {
//   await retrieveDocId();
//   await retrieveRoutePreferences();
//   await retrieveUserRoutePreference();
//   cosineDist();
// }

// @override
// void initState() {
//   super.initState();
//   getToList();
//   getFromList();
//   test();
//
//   mRecentList = QIBusGetData();
//   mOfferList = QIBusGetOffer();
//   formatted = formatter.format(now);
// }

// Widget mToolbar() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: <Widget>[
//       Center(
//         child: text(QIBus_home,
//             textColor: Colors.blue,
//             fontFamily: fontBold,
//             fontSize: textSizeLargeMedium),
//       ),
// GestureDetector(
//   onTap: () {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (BuildContext context) => FirstPreference()));
//     retrievePreference().then((s) {
//       print(s);
//     });
//
//     // launchScreen(context, QIBusNotification.tag);
//   },
//   child: Image(
//     image: AssetImage(qibus_gif_bell),
//     height: 25,
//     width: 25,
//     color: qIBus_white,
//   ),
// ),
// GestureDetector(
//   onTap: () async {
//     // getToList();
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) => QIBusSignIn(),
//       ),
//       (route) => false,
//     );
//     // launchScreen(context, QIBusNotification.tag);
//   },
//   child: Image(
//     image: AssetImage(qibus_gif_bell),
//     height: 25,
//     width: 25,
//     color: Colors.redAccent,
//   ),
// ),
// GestureDetector(
//   onTap: () async {
//     getToList();
//     // await FirebaseAuth.instance.signOut();
//     // Navigator.pushAndRemoveUntil(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (BuildContext context) => QIBusSignIn(),
//     //   ),
//     //       (route) => false,
//     // );
//     // launchScreen(context, QIBusNotification.tag);
//   },
//   child: Image(
//     image: AssetImage(qibus_gif_bell),
//     height: 25,
//     width: 25,
//     color: Colors.green,
//   ),
// ),
// GestureDetector(
//   onTap: () async {
//     Navigator.push(context,
//         MaterialPageRoute(builder: (BuildContext context) => CheckedIn()));
//
//     // getToList();
//     // await FirebaseAuth.instance.signOut();
//     // Navigator.pushAndRemoveUntil(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (BuildContext context) => QIBusSignIn(),
//     //   ),
//     //       (route) => false,
//     // );
//     // launchScreen(context, QIBusNotification.tag);
//   },
//   child: Image(
//     image: AssetImage(qibus_gif_bell),
//     height: 25,
//     width: 25,
//     color: Colors.black,
//   ),
// ),
// GestureDetector(
//   onTap: () {
//    // getToList();
//    //  print("Doc Id=$docId");
//    //  print("B=$B");
//    //  print("User Preference=$userPreference");
//    //  cosineDist();
//     getToFromList();
//     //toFromList.clear();
//
//     // launchScreen(context, QIBusNotification.tag);
//   },
//   onDoubleTap: (){
//     print('printing list');
//     print(toFromList);
//   },
//   onLongPress: (){
//     print(' Clearing toFromList..................');
//     toFromList.clear();
//   },
//   child: Image(
//     image: AssetImage(qibus_gif_bell),
//     height: 25,
//     width: 25,
//     color: Colors.indigo,
//   ),
// ),
//     ],
//   );
// }

//   var mTopSearch = Row(
//     children: <Widget>[
//       Column(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: qIBus_colorPrimary,
//                 border: Border.all(width: 0, color: qIBus_colorPrimary)),
//             width: 20,
//             height: 20,
//           ),
//           Container(
//             height: 30,
//             width: 0.5,
//             color: qIBus_colorPrimary,
//           ),
//           SvgPicture.asset(
//             qibus_ic_pin,
//             color: qIBus_colorPrimary,
//           ),
//         ],
//       ),
//       SizedBox(
//         width: spacing_standard_new,
//       ),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               child: TextField(
//                 controller: fromSearchController,
//                 style: TextStyle(
//                     fontSize: textSizeMedium,
//                     fontFamily: fontRegular,
//                     color: qIBus_textChild),
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
//                   isDense: true,
//                   hintText: 'From city',
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//             view(),
//             Container(
//               child: TextField(
//                 controller: toSearchController,
//                 style: TextStyle(
//                     fontSize: textSizeMedium,
//                     fontFamily: fontRegular,
//                     color: qIBus_textChild),
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
//                   isDense: true,
//                   hintText: 'To city',
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       Container(
//         decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: qIBus_colorPrimary,
//             border: Border.all(width: 0, color: qIBus_colorPrimary)),
//         child: Padding(
//           padding: EdgeInsets.all(4),
//           child: Image.asset(
//             qibus_ic_wrap,
//             color: qIBus_white,
//             width: 20,
//             height: 20,
//           ),
//         ),
//       )
//     ],
//   );
//
//   Widget mOption(IconData icon, var name, var pos) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isSelected = pos;
//         });
//       },
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             height: spacing_standard,
//           ),
//           Icon(
//             icon,
//             color: isSelected == pos ? qIBus_colorPrimary : qIBus_icon_color,
//           ),
//           SizedBox(
//             height: 4,
//           ),
//           text(name,
//               fontSize: textSizeSmall,
//               textColor:
//                   isSelected == pos ? qIBus_colorPrimary : qIBus_textChild)
//         ],
//       ),
//     );
//   }
//
//   Widget mSelection(var date) {
//     return Stack(
//       children: <Widget>[
//         Container(
//             height: MediaQuery.of(context).size.width * 0.25,
//             margin: EdgeInsets.only(left: 16, right: 16),
//             decoration: boxDecoration(
//                 radius: 8, bgColor: qIBus_white, showShadow: true),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(16, 0, 8, 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       text(QIBus_text_when_you_want_to_go,
//                           textColor: qIBus_textChild),
//                       SizedBox(
//                         height: spacing_standard,
//                       ),
//                       GestureDetector(
//                         onTap: () {},
//                         child: RichText(
//                             text: TextSpan(
//                           children: [
//                             WidgetSpan(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(right: 8),
//                                 child: SvgPicture.asset(
//                                   qibus_ic_calender,
//                                   color: qIBus_icon_color,
//                                   width: 20,
//                                   height: 20,
//                                 ),
//                               ),
//                             ),
//                             TextSpan(
//                                 text: date,
//                                 style: TextStyle(
//                                     fontFamily: fontMedium,
//                                     fontSize: textSizeMedium,
//                                     color: qIBus_colorPrimary)),
//                           ],
//                         )),
//                       )
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(16, 6, 8, 6),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Icon(
//                         Icons.arrow_drop_up,
//                         color: qIBus_icon_color,
//                       ).onTap(() {
//                         setState(() {
//                           count = count + 1;
//                         });
//                       }),
//                       text("$count", textColor: qIBus_colorPrimary),
//                       count == 1
//                           ? Icon(
//                               Icons.arrow_drop_down,
//                               color: qIBus_white,
//                             )
//                           : Icon(
//                               Icons.arrow_drop_down,
//                               color: qIBus_icon_color,
//                             ).onTap(() {
//                               setState(() {
//                                 if (count == 1 || count < 1) {
//                                   count = 1;
//                                 } else {
//                                   count = count - 1;
//                                 }
//                               });
//                             }),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     launchScreen(context, QIBusSearchList.tag);
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width * 0.2,
//                     height: MediaQuery.of(context).size.width * 0.25,
//                     decoration: boxDecoration(bgColor: qIBus_colorPrimary),
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Icon(
//                         Icons.search,
//                         color: qIBus_white,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ))
//       ],
//     );
//   }
//
//   var mRecentSearchLbl = Container(
//     margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
//     child: text(QIBus_text_recent_search, fontFamily: fontMedium),
//   );
//
//   Widget mNewOfferLbl() {
//     return Container(
//       margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           text(QIBus_txt_new_offers, fontFamily: fontMedium),
//           GestureDetector(
//             onTap: () {
//               launchScreen(context, QIBusViewOffer.tag);
//             },
//             child: text(QIBus_txt_view_all, textColor: qIBus_textChild),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget mRecentSearch(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return SizedBox(
// //      height: width * 0.4,
//       height: 155,
//       child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: mRecentList.length,
//           shrinkWrap: true,
//           itemBuilder: (context, index) {
//             return RecentSearch(mRecentList[index], index);
//           }),
//     );
//   }
//
//   Widget mOffer(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return SizedBox(
// //      height: width * 0.4,
//       height: 160,
//       child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: mOfferList.length,
//           shrinkWrap: true,
//           itemBuilder: (context, index) {
//             return NewOffer(mOfferList[index], index);
//           }),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     changeStatusColor(qIBus_colorPrimary);
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       // floatingActionButton: FloatingActionButton(
//       //   backgroundColor: Colors.red,
//       //   splashColor: Colors.green,
//       //   child: Icon(Icons.upload_sharp),
//       //   onPressed: () {
//       //     Navigator.push(
//       //         context,
//       //         MaterialPageRoute(
//       //             builder: (BuildContext context) => RouteUpload()));
//       //     print("hello");
//       //   },
//       // ),
//       backgroundColor: qIBus_app_background,
//
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Stack(
//           children: <Widget>[
//             // Container(
//             //   color: qIBus_colorPrimary,
//             //   height: width * 0.3,
//             // ),
//             Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.only(
//                       left: 16,
//                       right: 16,
//                     ),
//                     child: mToolbar(),
//                   ),
//                   SizedBox(
//                     height: 16,
//                  ),
// Container(
//     margin: EdgeInsets.only(
//       left: 16,
//       right: 16,
//     ),
//     decoration: boxDecoration(
//         radius: 8, bgColor: qIBus_white, showShadow: false),
//     padding: EdgeInsets.all(10.0),
//     child: Column(
//       children: <Widget>[
//         mTopSearch,
//         Padding(
//           padding: EdgeInsets.only(
//               left: 16,
//               right: spacing_standard_new,
//               top: spacing_standard_new),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               mOption(Icons.directions_bike, "Bike", 1),
//               mOption(Icons.directions_car, "Car", 2),
//               mOption(Icons.directions_bus, "Bus/Van", 3)
//               //mOption(qibus_ic_ac, QIBus_lbl_ac, 1),
//               //mOption(qibus_ic_non_ac, QIBus_lbl_non_ac, 2),
//               //mOption(qibus_ic_sleeper_icon,QIBus_lbl_sleeper, 3),
//               //mOption(qibus_ic_seater, QIBus_lbl_seater, 4),
//             ],
//           ),
//         ),
//       ],
//     )),
// SizedBox(
//   height: 16,
// ),
// mSelection(formatted),
// mRecentSearchLbl,
// mRecentSearch(context),
// mNewOfferLbl(),
// mOffer(context),
//                   SizedBox(
//                     height: 16,
//                   ),
//
//                 ],
//               ),
//             )
//           ],
//         ),
//       )),
//     );
//   }
// }

// class RecentSearch extends StatelessWidget {
//   QIBusBookingModel model;
//
//   RecentSearch(QIBusBookingModel model, int pos) {
//     this.model = model;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return Container(
//       width: width * 0.7,
//       decoration: boxDecoration(
//           showShadow: true, bgColor: qIBus_white, radius: spacing_middle),
//       margin: EdgeInsets.only(left: spacing_standard_new),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.fromLTRB(spacing_middle, spacing_standard_new,
//                 spacing_standard_new, spacing_standard),
//             child: RichText(
//                 text: TextSpan(
//               children: [
//                 WidgetSpan(
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: spacing_middle),
//                     child: SvgPicture.asset(
//                       qibus_ic_bus,
//                       color: qIBus_colorPrimary,
//                       height: 18,
//                       width: 18,
//                     ),
//                   ),
//                 ),
//                 TextSpan(
//                     text: model.destination,
//                     style: TextStyle(
//                         fontSize: textSizeMedium,
//                         color: qIBus_textHeader,
//                         fontFamily: fontMedium)),
//               ],
//             )),
//           ),
//           SizedBox(
//             height: spacing_control,
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(
//                 spacing_middle, 0, spacing_standard_new, 14),
//             child: text(model.duration, textColor: qIBus_textChild),
//           ),
//           RaisedButton(
//               onPressed: () {
//                 launchScreen(context, QIBusSearchList.tag);
//               },
//               textColor: qIBus_white,
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16.0)),
//               padding: const EdgeInsets.all(0.0),
//               child: Container(
//                 decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                     color: qIBus_colorPrimary),
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       QIBus_text_book_now,
//                       style: TextStyle(fontSize: 16),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }
//
// class NewOffer extends StatelessWidget {
//   QIBusNewOfferModel model;
//
//   NewOffer(QIBusNewOfferModel model, int pos) {
//     this.model = model;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return Container(
//       width: width * 0.7,
//       margin: EdgeInsets.only(left: spacing_standard_new),
//       decoration: boxDecoration(
//           showShadow: true, bgColor: qIBus_white, radius: spacing_middle),
//       child: Column(
//         children: <Widget>[
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(spacing_middle),
//                 topLeft: Radius.circular(spacing_middle)),
//             child: Stack(
//               children: <Widget>[
//                 Container(
//                   color: model.color,
//                   child: CachedNetworkImage(
//                     imageUrl: model.img,
//                     height: width * 0.26,
//                     fit: BoxFit.none,
//                     width: width,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 8,
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               text(QIBus_lbl_use_code, fontFamily: fontMedium),
//               SizedBox(
//                 width: spacing_control_half,
//               ),
//               text(model.useCode, textAllCaps: true, fontFamily: fontMedium),
//             ],
//           ),
//           SizedBox(
//             height: 8,
//           ),
//         ],
//       ),
//     );
//   }
// }
//}]