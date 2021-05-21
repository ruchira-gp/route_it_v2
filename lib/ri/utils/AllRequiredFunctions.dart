import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_analysis/document_analysis.dart';
import 'dart:collection';
import 'package:route_it_v2/ri/screen/RiSignIn.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:route_it_v2/ri/utils/RiColors.dart';
import 'package:route_it_v2/ri/utils/RiConstant.dart';
import 'package:route_it_v2/ri/utils/RiWidget.dart';
import 'package:url_launcher/url_launcher.dart';

List<String> allDocIds = []; // List of all Document ID
// List nestedRoutePreferences = []; // List of List of route prefs
// List currentUserPreference = []; // Current user pref
LinkedHashMap sortedMap; // sorted map got after cosine function
List<String> sortedDocIds =
    []; // List of all sorted Document IDs after cosine function
var toList = []; // toCity List
var fromList = []; // fromCity list
var toFromList = []; // toCity list , given fromCity
List<TripDetails> allRoutesAccordingToPreference = []; // List of all routes

void launchURL(url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
class TripDetails extends StatelessWidget {
  final String desc;
  final String title;
  final String tripImage;
  final String toCity;
  final String fromCity;
  final String duration;
  final String expenses;
  final String mode;
  // ignore: non_constant_identifier_names
  final String travel_month;
  final String link;

  TripDetails(
      {this.fromCity,
      this.desc,
      this.title,
      this.toCity,
      this.tripImage,
      this.duration,
      this.expenses,
      this.mode,
        this.link,
      // ignore: non_constant_identifier_names
      this.travel_month});
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text('Trip Details')),
                content: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(spacing_middle),
                            topLeft: Radius.circular(spacing_middle),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                color:Colors.white,
                                // child: Image.network(tripImage) ,
                                child: CachedNetworkImage(
                                  imageUrl: tripImage,
                                  height: width * 0.3,
                                  fit: BoxFit.none,
                                  width: width,
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal),
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      Text(
                        desc,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal),
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      text("From : $fromCity", textAllCaps: true, fontFamily: fontMedium),
                      SizedBox(
                        height: 15,
                      ),
                      text("To : $toCity", textAllCaps: true, fontFamily: fontMedium),
                      SizedBox(
                        height: 15,
                      ),

                      text("Expenses : $expenses", textAllCaps: true, fontFamily: fontMedium),
                      SizedBox(
                        height: 15,
                      ),
                      text("Mode of Travel : $mode", textAllCaps: true, fontFamily: fontMedium),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(onPressed: ()async{
                        await launch(link);
                       // launchURL(link);
                      }, child: Text('Guide Me !'))
                    ],
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              );
            });
      },

      child:Container(
        width: width * 0.7,
        margin: EdgeInsets.only(
            left: spacing_standard_new,
            right: spacing_standard_new,
            bottom: spacing_standard_new),
        decoration: boxDecoration(
            showShadow: true, bgColor: qIBus_white, radius: spacing_middle),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(spacing_middle),
                  topLeft: Radius.circular(spacing_middle),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      color:Colors.white,
                      child: CachedNetworkImage(
                        imageUrl: tripImage,
                        height: width * 0.3,
                        fit: BoxFit.none,
                        width: width,
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: spacing_control_half,
                    ),
                    text(title, textAllCaps: true, fontFamily: fontMedium),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    text("From : $fromCity", textAllCaps: true, fontFamily: fontMedium),
                    text("To : $toCity", textAllCaps: true, fontFamily: fontMedium),
                  ],
                )

              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      )
      // child: Card(
      //     color: Colors.white,
      //     child: Padding(
      //       padding: const EdgeInsets.all(20.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           Row(
      //             children: [
      //               Container(
      //                 height: 120.0,
      //                 width: 120.0,
      //                 decoration: BoxDecoration(
      //                   image: DecorationImage(
      //                     image: NetworkImage(tripImage, scale: 5),
      //                     fit: BoxFit.fill,
      //                   ),
      //                   shape: BoxShape.rectangle,
      //                 ),
      //               ),
      //               SizedBox(
      //                 width: 20,
      //               ),
      //               Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Text(
      //                     '$title',
      //                     style: TextStyle(fontWeight: FontWeight.bold),
      //                   ),
      //                   Text(
      //                     'from: $fromCity',
      //                     style: TextStyle(color: Colors.green),
      //                   ),
      //                   Padding(
      //                     padding: const EdgeInsets.all(8.0),
      //                     child: Text('to : $toCity'),
      //                   ),
      //
      //                 ],
      //               )
      //             ],
      //           ),
      //         ],
      //       ),
      //     )),
    );
  }
}

// All Global Functions Start Here

//--------------------------------------------------------------------
// Retrieves all document IDs and stores in  List allDocIds
retrieveAllDocIds() async {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance
      .collection('trip')
      .get()
      .then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              allDocIds.add(doc.id);
            })
          });
}

//----------------------------------------------------------------------------------------------
// Retrieves all route preferences as list of list and stores it in nestedRoutePreferences
retrieveRoutePreferences() async {
  // final firestoreInstance = FirebaseFirestore.instance;
  // firestoreInstance.collection('trip').get().then((querySnapshot) {
  //   querySnapshot.docs.forEach((result) {
  //     List X = [];
  //     X.clear();
  //     String a = "", b = "", c = "", d = "", e = "", f = "";
  //     //print(result.id);
  //     a = result.data()['route']['prefs']['desert'];
  //     b = result.data()['route']['prefs']['forest'];
  //     c = result.data()['route']['prefs']['highway'];
  //     d = result.data()['route']['prefs']['mountain'];
  //     e = result.data()['route']['prefs']['pilgrimage'];
  //     f = result.data()['route']['prefs']['riverside'];
  //     X.add(a);
  //     X.add(b);
  //     X.add(c);
  //     X.add(d);
  //     X.add(e);
  //     X.add(f);
  //
  //     nestedRoutePreferences.add(X);
  //   });
  // });
}

//----------------------------------------------------------------------------------------------
// Retrieves Current User route preferences as list  and stores it in currentUserPreference

retrieveUserRoutePreference() {
  // var firebaseUser = FirebaseAuth.instance.currentUser;
  // final firestoreInstance = FirebaseFirestore.instance;
  //
  // firestoreInstance
  //     .collection("users")
  //     .doc(firebaseUser.uid)
  //     .get()
  //     .then((result) {
  //   int a = 0, b = 0, c = 0, d = 0, e = 0, f = 0;
  //   //print(result.id);
  //   a = result.data()['prefs']['desert'];
  //   b = result.data()['prefs']['forest'];
  //   c = result.data()['prefs']['highway'];
  //   d = result.data()['prefs']['mountain'];
  //   e = result.data()['prefs']['pilgrimage'];
  //   f = result.data()['prefs']['riverside'];
  //   currentUserPreference.add(a);
  //   currentUserPreference.add(b);
  //   currentUserPreference.add(c);
  //   currentUserPreference.add(d);
  //   currentUserPreference.add(e);
  //   currentUserPreference.add(f);
  // });
}

//----------------------------------------------------------------------------------------------
// Retrieves Cosine Sorted  as Map  and stores it in sortedMap
cosineDist() async {
  print('doc ids >>>>> $allDocIds>');
  List nestedRoutePreferences = []; // List of List of route prefs
  List currentUserPreference = [];
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;

  await firestoreInstance
      .collection("users")
      .doc(firebaseUser.uid)
      .get()
      .then((result) {
    int a = 0, b = 0, c = 0, d = 0, e = 0, f = 0;
    //print(result.id);
    a = result.data()['prefs']['desert'];
    b = result.data()['prefs']['forest'];
    c = result.data()['prefs']['highway'];
    d = result.data()['prefs']['mountain'];
    e = result.data()['prefs']['pilgrimage'];
    f = result.data()['prefs']['riverside'];
    currentUserPreference.add(a);
    currentUserPreference.add(b);
    currentUserPreference.add(c);
    currentUserPreference.add(d);
    currentUserPreference.add(e);
    currentUserPreference.add(f);
  });
  print('2)currentUserPreference = $currentUserPreference');
  //final firestoreInstance = FirebaseFirestore.instance;
  await firestoreInstance.collection('trip').get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      List X = [];
      X.clear();
      String a = "", b = "", c = "", d = "", e = "", f = "";
      //print(result.id);
      a = result.data()['route']['prefs']['desert'];
      b = result.data()['route']['prefs']['forest'];
      c = result.data()['route']['prefs']['highway'];
      d = result.data()['route']['prefs']['mountain'];
      e = result.data()['route']['prefs']['pilgrimage'];
      f = result.data()['route']['prefs']['riverside'];
      X.add(a);
      X.add(b);
      X.add(c);
      X.add(d);
      X.add(e);
      X.add(f);

      nestedRoutePreferences.add(X);
    });
  });
  print('3) nestedRoutePrefs >>>>>$nestedRoutePreferences');

  List<dynamic> routeRating = []..addAll(nestedRoutePreferences);
  //List routeRating = nestedRoutePreferences;
  print('4) route Rating = $routeRating');
  List<double> cosineValues = [];
  routeRating.forEach((element) {
    var temp = element;
    var tempDouble =
        temp.map((i) => int.parse(i.toString()).toDouble()).toList();
    tempDouble = tempDouble.cast<double>();
    print('tempDouble = $tempDouble');
    var userPreferenceDouble = currentUserPreference
        .map((i) => int.parse(i.toString()).toDouble())
        .toList();
    print('userprefernceDouble : $userPreferenceDouble');
    double x = 1 - cosineDistance(tempDouble, userPreferenceDouble);
    cosineValues.add(x);
  });
  print('5) cosinevalues>>>>>>> $cosineValues');
  //var temp = routeRating[i];

  print("hello im cosineDist function");
  var finalList = new Map();
  for (var x = 0; x < cosineValues.length; x++) {
    finalList[allDocIds[x]] = cosineValues[x];
    //print(finalList);
  }
  var sortedKeys = finalList.keys.toList(growable: false)
    ..sort((k1, k2) => finalList[k2].compareTo(finalList[k1]));
  sortedMap = LinkedHashMap.fromIterable(sortedKeys,
      key: (k) => k, value: (k) => finalList[k]);
  sortedMap.forEach((key, value) {
    sortedDocIds.add(key);
  });
  print('6) Sorted DOc ids >>>>>> : $sortedDocIds');
  List<String> sortedDocIds2 = []..addAll(sortedDocIds);
  print('7) Sorted DOc ids2>>>>>>>> : $sortedDocIds2');

  List<TripDetails> allRoutesAccordingToPreference2 = [];
  String desc = "";
  String title = "";
  String tripImage = "";
  String toCity = "";
  String fromCity = "";
  String link="";
  String expenses="";
  String mode="";
  int o=0;
while(o<sortedDocIds2.length){
  await firestoreInstance.collection("trip").doc(sortedDocIds2[o]).get().then((value) {
    //print("doc id inside loop : ${sortedDocIds2[o]}");
    desc = (value.data()["info"]['desc']);
    title = (value.data()["info"]['title']);
    tripImage = (value.data()["info"]['photo']);
    toCity = (value.data()['route']["route_info"]['to']);
    fromCity = (value.data()['route']["route_info"]['from']);
    link=(value.data()['route']["route_info"]['link']);
    expenses=(value.data()['misc']["expenses"]);
    mode=(value.data()['misc']["mode"]);
      });
    allRoutesAccordingToPreference.add(TripDetails(
    desc: desc,
    title: title,
    tripImage: tripImage,
    toCity: toCity,
    fromCity: fromCity,
    link: link,
    expenses: expenses,
    mode: mode,
  ));
  print(sortedDocIds2[o]);
  o++;
      }
      print(allRoutesAccordingToPreference);
  // sortedDocIds2.forEach((element)  {
  //    firestoreInstance.collection("trip").doc(element).get().then((value) {
  //     print("doc id inside loop : $element");
  //     desc = (value.data()["info"]['desc']);
  //     title = (value.data()["info"]['title']);
  //     tripImage = (value.data()["info"]['photo']);
  //     toCity = (value.data()['route']["route_info"]['to']);
  //     fromCity = (value.data()['route']["route_info"]['from']);
  //     link=(value.data()['route']["route_info"]['link']);
  //     expenses=(value.data()['misc']["expenses"]);
  //     mode=(value.data()['misc']["mode"]);
  //     TripDetails x=TripDetails(desc: desc,
  //       title: title,
  //       tripImage: tripImage,
  //       toCity: toCity,
  //       fromCity: fromCity,
  //       link: link,
  //       expenses: expenses,
  //       mode: mode);
  //     allRoutesAccordingToPreference.add(x);
  //
  //     //  allRoutesAccordingToPreference.add(TripDetails(
  //     //   desc: desc,
  //     //   title: title,
  //     //   tripImage: tripImage,
  //     //   toCity: toCity,
  //     //   fromCity: fromCity,
  //     //   link: link,
  //     //   expenses: expenses,
  //     //   mode: mode,
  //     // ));
  //   });
  //   print('title : $title');
  //   //allRoutesAccordingToPreference2.add(TripDetails(desc: desc,title: title,tripImage: tripImage,toCity: toCity,fromCity: fromCity,));
  // });
  //allRoutesAccordingToPreference = []..addAll(allRoutesAccordingToPreference2);

  print(
      "allroutes according yo preference22 : $allRoutesAccordingToPreference2");
  print("allroutes according yo preference : $allRoutesAccordingToPreference");
}

//----------------------------------------------------------------------------------------------

//Sorting docids in sortMap and storing it in sortedDocIds
sortDocIdsAfterCosine() {
  // sortedMap.forEach((key, value) {
  //   sortedDocIds.add(key);
  // });
}

//----------------------------------------------------------------------------------------------
//retrieve preference flag during sign-in
// if returns 0 : new user
// if returns 1 : existing user

retrievePreferenceFlag() async {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  int a;
  await firestoreInstance
      .collection("users")
      .doc(firebaseUser.uid)
      .get()
      .then((value) {
    a = (value.data()["pref_flag"]);
  });
  //print(a);
  return a;
}

//----------------------------------------------------------------------------------------------

//Signing out user into Login Page
signOut(context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => QIBusSignIn(),
    ),
    (route) => false,
  );
}

//----------------------------------------------------------------------------------------------

// get To city List and store in toList
getToList() async {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("trip").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      toList.add(result.data()['route']['route_info']['to']);
    });
  });
}

//----------------------------------------------------------------------------------------------

// get From city List and store in toList
getFromList() async {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("trip").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      fromList.add(result.data()['route']['route_info']['from']);
    });
  });
}

//----------------------------------------------------------------------------------------------

// get to city List provided fromCity and store in toList
getToFromList(String fromCity) async {
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection("trip").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      if (fromCity == result.data()['route']['route_info']['from']) {
        toFromList.add(result.data()['route']['route_info']['to']);
      }
    });
  });
}

//--------------------------------------------------------------------------------------------------------
// Converts the route details into object of type TripDetails and stores it in allRoutesAccordingToPreference

getAllRoutesAccordingToPreference()  {
  print('Sorted DOc ids 222222: $sortedDocIds');
  final firestoreInstance = FirebaseFirestore.instance;
  String desc = "";
  String title = "";
  String tripImage = "";
  String toCity = "";
  String fromCity = "";
  String link="";
  String expenses="";
  String mode="";
   sortedDocIds.forEach((element)  {
     firestoreInstance.collection("trip").doc(element).get().then((value) {
      desc = (value.data()["info"]['desc']);
      title = (value.data()["info"]['title']);
      tripImage = (value.data()["info"]['photo']);
      toCity = (value.data()['route']["route_info"]['to']);
      fromCity = (value.data()['route']["route_info"]['from']);
      link = (value.data()['route']["route_info"]['link']);
      expenses=(value.data()['misc']["expenses"]);
      mode=(value.data()['misc']["mode"]);
       allRoutesAccordingToPreference.add(TripDetails(
        desc: desc,
        title: title,
        tripImage: tripImage,
        toCity: toCity,
        fromCity: fromCity,
        link: link,
        mode: mode,
        expenses: expenses,
      ));
    });
  });

  print("allroutes according yo preference : $allRoutesAccordingToPreference");
}

//----------------------------------------------------------------------------------------------

printAllDetails() {
  print('###### Below : currentUserPreference ######');
  // print(currentUserPreference);
  // print('###### Below : nestedRoutePreferences ######');
  // print(nestedRoutePreferences);
  print('###### Below : allDocIds ######');
  print(allDocIds);
  print("SOrted Map");
  print(sortedMap);
  print('This is sortedDocIds list .........');
  print(sortedDocIds);
  print('To city  list.........');
  print(toList);
  print('From city  list.........');
  print(fromList);
  print('to city -- fromCIty=Mysore');
  print(toFromList);
  print('TD list allRoutesAccordingToPreference');
  print(allRoutesAccordingToPreference);
}

clearAllData() {
  print("cleared");
  allDocIds.clear();
  // nestedRoutePreferences.clear();
  // currentUserPreference.clear();
  sortedDocIds.clear();
  sortedMap.clear();
  toList.clear();
  fromList.clear();
  toFromList.clear();
  allRoutesAccordingToPreference.clear();
}
