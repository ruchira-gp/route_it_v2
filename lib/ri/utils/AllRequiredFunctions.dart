import 'dart:convert';
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
import 'package:http/http.dart' as http;

String getLatLongString = "";

double toLat = 0.0;
double toLong = 0.0;
double fromLat = 0.0;
double fromLong = 0.0;
getExpandedUrl(encryptedUrl) async {
  var response = await http.get(
    Uri.parse("http://expandurl.com/api/v1/?url=$encryptedUrl"),
  );
  String jsonResponse = response.body.toString();
  return (jsonResponse);
}

getLatLong(strr) {
  String str1 = strr.toString();
  RegExp reg1 = new RegExp(r"![0-9][a-zA-Z]([0-9\.]{5,})");
  String y = "";
  List<String> route = [];
  Iterable allMatches = reg1.allMatches(str1);
  int i = 0;
  allMatches.forEach((match) {
    y = (str1.substring(match.start, match.end));
    route.add(y.substring(
      3,
    ));
  });
 //print('Hello this is route ');
 //print(route);
  return route;
}

getMidP(List latlonglist) {
  fromLat = double.parse(latlonglist[0]);
  fromLong = double.parse(latlonglist[1]);
  toLat = double.parse(latlonglist[latlonglist.length - 2]);
  toLong = double.parse(latlonglist[latlonglist.length - 1]);

  var lat = (double.parse(latlonglist[0]) +
          double.parse(latlonglist[latlonglist.length - 2])) /
      2;
  var long = (double.parse(latlonglist[1]) +
          double.parse(latlonglist[latlonglist.length - 1])) /
      2;
  return [fromLat, fromLong, toLat, toLong, lat, long];
}

// available configuration for multiple choice
List<int> value = [2];

getMidPoint(String shortenedUri) async {
  var x = await getExpandedUrl(shortenedUri);
  return (getMidP(getLatLong(x)));
}
getLocation(String shortenedUri) async {
  var x = await getExpandedUrl(shortenedUri);
  return (getLatLong(x));
}
getPetrolBunks(List midPoint) async {
  Map data = {
    'client_id': 'XXXHYXS01GX50KRXM53HD12NB00CL4RTPODV34RLQTOW1VM0',
    'client_secret': 'PCDGO5DYACJ1BAHD0QVNRYKZ5FYYTQ0IQ4S3UHEYWTWWGZ2W',
    'v': '20210525',
    'll': '${midPoint[0]},${midPoint[1]}',
    'radius': '35000',
    'query': 'petrol bunk'
  };

  var response = await http.post(
      Uri.parse("https://api.foursquare.com/v2/venues/search"),
      body: data);
  var jsonResponse = json.decode(response.body);
  //print(jsonResponse);
  if (jsonResponse['response']['venues'].toString() == "[]") {
    //print('Empty List');
    return null;
  } else {

    print(jsonResponse['response']['venues'][0]['name']);
    print(jsonResponse['response']['venues'][0]['location']['lat']);
    print(jsonResponse['response']['venues'][0]['location']['lng']);
    return [
      jsonResponse['response']['venues'][0]['name'],
      jsonResponse['response']['venues'][0]['location']['lat'],
      jsonResponse['response']['venues'][0]['location']['lng'],
      jsonResponse['response']['venues'][1]['name'],
      jsonResponse['response']['venues'][1]['location']['lat'],
      jsonResponse['response']['venues'][1]['location']['lng'],
      jsonResponse['response']['venues'][2]['name'],
      jsonResponse['response']['venues'][2]['location']['lat'],
      jsonResponse['response']['venues'][2]['location']['lng'],
    ];
  }
}

getEateries(List midPoint) async {
  Map data = {
    'client_id': 'XXXHYXS01GX50KRXM53HD12NB00CL4RTPODV34RLQTOW1VM0',
    'client_secret': 'PCDGO5DYACJ1BAHD0QVNRYKZ5FYYTQ0IQ4S3UHEYWTWWGZ2W',
    'v': '20210525',
    'll': '${midPoint[0]},${midPoint[1]}',
    'radius': '40000',
    'query': 'restaurant'
  };

  var response = await http.post(
      Uri.parse("https://api.foursquare.com/v2/venues/search"),
      body: data);
  //print(response.body);

  var jsonResponse = json.decode(response.body);
  print(jsonResponse);
  if (jsonResponse['response']['venues'].toString() == "[]") {
    //print('Empty List');
    return null;
  } else {
    jsonResponse['response']['venues'].forEach((element) {
      //print(element['name']);
    });

    return [
      jsonResponse['response']['venues'][0]['name'],
      jsonResponse['response']['venues'][0]['location']['lat'],
      jsonResponse['response']['venues'][0]['location']['lng'],
      jsonResponse['response']['venues'][1]['name'],
      jsonResponse['response']['venues'][1]['location']['lat'],
      jsonResponse['response']['venues'][1]['location']['lng'],
      jsonResponse['response']['venues'][2]['name'],
      jsonResponse['response']['venues'][2]['location']['lat'],
      jsonResponse['response']['venues'][2]['location']['lng'],
    ];
  }
}

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

class LabeledCheckbox extends StatefulWidget {
  const LabeledCheckbox({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  _LabeledCheckboxState createState() => _LabeledCheckboxState();
}

class _LabeledCheckboxState extends State<LabeledCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Padding(
        padding: widget.padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(widget.label)),
            Checkbox(
              value: widget.value,
              onChanged: (newValue) {
                widget.onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

void launchURL(url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

class TripDetails extends StatefulWidget {
  final String docid;
  final String desc;
  final String title;
  final String tripImage;
  final String toCity;
  final String fromCity;
  final String duration;
  final String expenses;
  final String mode;
  final int likes;
  // ignore: non_constant_identifier_names
  final String travel_month;
  final String link;

  TripDetails(
      {this.fromCity,
      this.likes,
      this.docid,
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
  _TripDetailsState createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  Color colour = Colors.blue[900];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () {
          bool _eateriesIsSelected = false;
          bool _gasStationIsSelected = false;
          var one;
          getMidPoint(widget.link).then((xxx) {
            setState(() {
              one = xxx;
            });
            //print(one);
          });

          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Center(child: Text('Trip Details')),
                    content: Container(
                      child: SingleChildScrollView(
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
                                      color: Colors.white,
                                      // child: Image.network(tripImage) ,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.tripImage,
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
                              widget.title,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              widget.desc,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            text("From : ${widget.fromCity}",
                                textAllCaps: true, fontFamily: fontMedium),
                            SizedBox(
                              height: 15,
                            ),
                            text("To : ${widget.toCity}",
                                textAllCaps: true, fontFamily: fontMedium),
                            SizedBox(
                              height: 15,
                            ),
                            text("Expenses : ${widget.expenses}",
                                textAllCaps: true, fontFamily: fontMedium),
                            SizedBox(
                              height: 15,
                            ),
                            text("Mode of Travel : ${widget.mode}",
                                textAllCaps: true, fontFamily: fontMedium),
                            SizedBox(
                              height: 15,
                            ),
                            // LabeledCheckbox(
                            //   label: 'Eateries',
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 20.0),
                            //   value: _eateriesIsSelected,
                            //   onChanged: (bool newValue) {
                            //     setState(() {
                            //       _eateriesIsSelected = newValue;
                            //     });
                            //   },
                            // ),
                            // LabeledCheckbox(
                            //   label: 'Gas Station',
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 20.0),
                            //   value: _gasStationIsSelected,
                            //   onChanged: (bool newValue) {
                            //     setState(() {
                            //       _gasStationIsSelected = newValue;
                            //     });
                            //   },
                            // ),
                            ElevatedButton(
                                onPressed: () async {
                                  await launch(widget.link);
                                },
                                // launchURL(link);
                                child: Text('Guide Me !')),
                            ElevatedButton(
                                onPressed: () async {
                                  var z = await getLocation(widget.link);
                                  //print("${z[0]},${z[1]},${z[z.length - 2]},${z[z.length - 1]}");
                                  List xx = [z[z.length - 2], z[z.length - 1]];
                                  //print("This is xx");
                                  //print(xx);
                                  var xxx = await getEateries(xx);
                                  //print(xxx);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                  title: Center(child: Text(
                                                      'Trip Details')),
                                                  content: Container(child: Column(
                                                    children: [
                                                      Text(xxx[0]),Text(xxx[3]),Text(xxx[6]),
                                                    ],
                                                  ),height: 100,));
                                            });
                                      });
                                },
                                child: Text('Optional Eateries at Destination'),
                            ),




                                // launchURL(link);


                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 40),
                            child: FlatButton(
                                child: Icon(
                                  Icons.thumb_up,
                                  color: colour,
                                ),
                                onPressed: () {
                                  if (colour == Colors.green) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text("${widget.title} Route Disiked"),
                                    ));
                                    colour = Colors.blue[900];
                                    final firestoreInstance =
                                        FirebaseFirestore.instance;
                                    firestoreInstance
                                        .collection("trip")
                                        .doc(widget.docid)
                                        .update({
                                      "likes": widget.likes - 1,
                                    }).then((_) {
                                      //print("success!");
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text("${widget.title} Route Liked"),
                                    ));
                                    colour = Colors.green;

                                    final firestoreInstance =
                                        FirebaseFirestore.instance;
                                    firestoreInstance
                                        .collection("trip")
                                        .doc(widget.docid)
                                        .update({
                                      "likes": widget.likes + 1,
                                    }).then((_) {
                                      //print("success!");
                                    });
                                    Navigator.pop(context);
                                  }
                                }),
                          ),
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
                      ),
                    ],
                  );
                });
              });
        },
        child: Container(
          width: width * 0.6,
          margin: EdgeInsets.only(
              left: spacing_standard_new,
              right: spacing_standard_new,
              bottom: spacing_standard_new),
          decoration: boxDecoration(
              showShadow: true, bgColor: Colors.lightBlue[50], radius: spacing_middle),
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
                        color: Colors.white,
                        child: CachedNetworkImage(
                          imageUrl: widget.tripImage,
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
                      text(widget.title,
                          textAllCaps: true, fontFamily: fontMedium),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      text("From : ${widget.fromCity}",
                          textAllCaps: true, fontFamily: fontMedium),
                      text("To : ${widget.toCity}",
                          textAllCaps: true, fontFamily: fontMedium),
                      Row(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            color: Colors.green,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('${widget.likes}'),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ));
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

// retrieveUserRoutePreference() {
//   var firebaseUser = FirebaseAuth.instance.currentUser;
//   final firestoreInstance = FirebaseFirestore.instance;
//   List currentUserPreference =[];
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
//     currentUserPreference.add(a);
//     currentUserPreference.add(b);
//     currentUserPreference.add(c);
//     currentUserPreference.add(d);
//     currentUserPreference.add(e);
//     currentUserPreference.add(f);
//     print(currentUserPreference);
//   });
// }

//----------------------------------------------------------------------------------------------
// Retrieves Cosine Sorted  as Map  and stores it in sortedMap
cosineDist() async {
  //('doc ids >>>>> $allDocIds>');
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
  //print('2)currentUserPreference = $currentUserPreference');
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
  //print('3) nestedRoutePrefs >>>>>$nestedRoutePreferences');

  List<dynamic> routeRating = []..addAll(nestedRoutePreferences);
  //List routeRating = nestedRoutePreferences;
  //print('4) route Rating = $routeRating');
  List<double> cosineValues = [];
  routeRating.forEach((element) {
    var temp = element;
    var tempDouble =
        temp.map((i) => int.parse(i.toString()).toDouble()).toList();
    tempDouble = tempDouble.cast<double>();
    //print('tempDouble = $tempDouble');
    var userPreferenceDouble = currentUserPreference
        .map((i) => int.parse(i.toString()).toDouble())
        .toList();
    //print('userprefernceDouble : $userPreferenceDouble');
    double x = 1 - cosineDistance(tempDouble, userPreferenceDouble);
    cosineValues.add(x);
  });
 // print('5) cosinevalues>>>>>>> $cosineValues');
  //var temp = routeRating[i];

  //print("hello im cosineDist function");
  var finalList = new Map();
  for (var x = 0; x < cosineValues.length; x++) {
    finalList[allDocIds[x]] = cosineValues[x];
    //print(finalList);
  }
  var sortedKeys = finalList.keys.toList(growable: false)
    ..sort((k1, k2) => finalList[k2].compareTo(finalList[k1]));
  sortedMap = LinkedHashMap.fromIterable(sortedKeys,
      key: (k) => k, value: (k) => finalList[k]);

  //print(sortedMap);
  List aloha=[];
  sortedMap.forEach((key, value) {
    sortedDocIds.add(key);
    aloha.add(value);
  });
  //print('6) Sorted DOc ids >>>>>> : $sortedDocIds');
  List<String> sortedDocIds2 = []..addAll(sortedDocIds);
  //print('7) Sorted DOc ids2>>>>>>>> : $sortedDocIds2');

  List<TripDetails> allRoutesAccordingToPreference2 = [];
  String docid = "";
  String desc = "";
  String title = "";
  String tripImage = "";
  String toCity = "";
  String fromCity = "";
  String link = "";
  String expenses = "";
  String mode = "";
  int likes = 0;
  int o = 0;
  while (o < sortedDocIds2.length) {
    await firestoreInstance
        .collection("trip")
        .doc(sortedDocIds2[o])
        .get()
        .then((value) {
      docid = sortedDocIds2[o];
      desc = (value.data()["info"]['desc']);
      title = (value.data()["info"]['title']);
      tripImage = (value.data()["info"]['photo']);
      toCity = (value.data()['route']["route_info"]['to']);
      fromCity = (value.data()['route']["route_info"]['from']);
      link = (value.data()['route']["route_info"]['link']);
      expenses = (value.data()['misc']["expenses"]);
      mode = (value.data()['misc']["mode"]);
      likes = (value.data()['likes']);
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
      docid: docid,
      likes: likes,
    ));
    //print(sortedDocIds2[o]);
    o++;
  }
  //print(allRoutesAccordingToPreference);
  print("Current User Terrain Preference\n");
  print("\tDesert = ${currentUserPreference[0]}");
  print("\tForest = ${currentUserPreference[1]}");
  print("\tHighway = ${currentUserPreference[2]}");
  print("\tMountains = ${currentUserPreference[3]}");
  print("\tPilgrimage = ${currentUserPreference[4]}");
  print("\tRiverSide = ${currentUserPreference[5]}");
  print("\n");
  print(' ---------Match Percentage-------------');
  int i = 0;
  allRoutesAccordingToPreference.forEach((element) {
    var xyz=aloha[i] * 100;
    print("$xyz ==> ${element.title}  ");
    i++;
  });
  //print("allroutes according yo preference22 : $allRoutesAccordingToPreference2");
  //print("allroutes according yo preference : $allRoutesAccordingToPreference");
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

getAllRoutesAccordingToPreference() {
  //print('Sorted DOc ids 222222: $sortedDocIds');
  final firestoreInstance = FirebaseFirestore.instance;
  String desc = "";
  String title = "";
  String tripImage = "";
  String toCity = "";
  String fromCity = "";
  String link = "";
  String expenses = "";
  String mode = "";
  String docid = "";
  int likes = 0;
  sortedDocIds.forEach((element) {
    firestoreInstance.collection("trip").doc(element).get().then((value) {
      desc = (value.data()["info"]['desc']);
      title = (value.data()["info"]['title']);
      tripImage = (value.data()["info"]['photo']);
      toCity = (value.data()['route']["route_info"]['to']);
      fromCity = (value.data()['route']["route_info"]['from']);
      link = (value.data()['route']["route_info"]['link']);
      expenses = (value.data()['misc']["expenses"]);
      mode = (value.data()['misc']["mode"]);
      docid = element;
      likes = (value.data()['likes']);
      allRoutesAccordingToPreference.add(TripDetails(
        desc: desc,
        title: title,
        tripImage: tripImage,
        toCity: toCity,
        fromCity: fromCity,
        link: link,
        mode: mode,
        expenses: expenses,
        likes: likes,
        docid: docid,
      ));
    });
  });

  //print("allroutes according yo preference : $allRoutesAccordingToPreference");
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
