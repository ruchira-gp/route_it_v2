import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_analysis/document_analysis.dart';
import 'dart:collection';
import 'package:route_it_v2/ri/screen/QIBusSignIn.dart';




List<String> allDocIds = []; // List of all Document ID
List nestedRoutePreferences = []; // List of List of route prefs
List currentUserPreference = []; // Current user pref
LinkedHashMap sortedMap; // sorted map got after cosine function
List<String> sortedDocIds = [];// List of all sorted Document IDs after cosine function
var toList = []; // toCity List
var fromList = []; // fromCity list
var toFromList = []; // toCity list , given fromCity
List<TripDetails> allRoutesAccordingToPreference=[]; // List of all routes




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

  TripDetails({
    this.fromCity,
    this.desc,
    this.title,
    this.toCity,
    this.tripImage,
    this.duration,
    this.expenses,
    this.mode,
    // ignore: non_constant_identifier_names
    this.travel_month

  } );
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text('Trip Details')),
                content: Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('images/ri/qibus_ic_home_selected.png'),
                            backgroundColor: Colors.transparent,
                            radius: 45,
                          ),
                          CircleAvatar(
                            backgroundImage:NetworkImage(tripImage),
                            backgroundColor: Colors.transparent,
                            radius: 45,
                            //backgroundImage: ImageProvider(AssetImage('images/DANKJI.png')),
                          ),
                        ],
                      ),
                      Text('Title',style: TextStyle(color: Colors.green,),textAlign: TextAlign.left,),
                      Text(title,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,fontStyle:FontStyle.normal),),
                      SizedBox(height: 15,),
                      Text('Desc',style: TextStyle(color: Colors.green,),textAlign: TextAlign.left,),
                      Text(desc,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,fontStyle:FontStyle.normal),),



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
      child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [

                        CircleAvatar(
                          backgroundImage:NetworkImage(tripImage,scale: 5),
                          backgroundColor: Colors.transparent,
                          radius: 25,
                          //backgroundImage: ImageProvider(AssetImage('images/DANKJI.png')),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('to'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('$toCity'),
                        ),
                      ],
                    )
                  ],
                ),
                Text(
                  '$title',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(
                  'from: $fromCity',
                  style: TextStyle(color: Colors.green),
                ),

              ],
            ),
          )),
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
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  firestoreInstance.collection('trip').get().then((querySnapshot) {
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
}

//----------------------------------------------------------------------------------------------
// Retrieves Current User route preferences as list  and stores it in currentUserPreference

retrieveUserRoutePreference() {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;

  firestoreInstance
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
}

//----------------------------------------------------------------------------------------------
// Retrieves Cosine Sorted  as Map  and stores it in sortedMap
cosineDist() {

  List routeRating = nestedRoutePreferences;
  List<double> cosineValues = [];
  for (var i = 0; i < routeRating.length; i++) {
    var temp = routeRating[i];
    var tempDouble =
    temp.map((i) => int.parse(i.toString()).toDouble()).toList();
    tempDouble = tempDouble.cast<double>();
    var userPreferenceDouble =
    currentUserPreference.map((i) => int.parse(i.toString()).toDouble()).toList();
    double x = 1 - cosineDistance(tempDouble, userPreferenceDouble);
    cosineValues.add(x);
  }
  var finalList = new Map();
  for (var x = 0; x < cosineValues.length; x++) {
    finalList[allDocIds[x]] = cosineValues[x];
  }
  var sortedKeys = finalList.keys.toList(growable: false)
    ..sort((k1, k2) => finalList[k2].compareTo(finalList[k1]));
  sortedMap = LinkedHashMap.fromIterable(sortedKeys,
      key: (k) => k, value: (k) => finalList[k]);

}


//----------------------------------------------------------------------------------------------


//Sorting docids in sortMap and storing it in sortedDocIds
sortDocIdsAfterCosine(){
  sortedMap.forEach((key, value) {
    sortedDocIds.add(key);
  });

}

//----------------------------------------------------------------------------------------------
//retrieve preference flag during sign-in
// if returns 0 : new user
// if returns 1 : existing user

retrievePreferenceFlag()async{
  var firebaseUser =  FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  int a;
  await firestoreInstance.collection("users").doc(firebaseUser.uid).get().then((value){
    a=(value.data()["pref_flag"]);
  });
  //print(a);
  return a;
}


//----------------------------------------------------------------------------------------------



//Signing out user into Login Page
signOut(context)async{
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
      if(fromCity==result.data()['route']['route_info']['from']){
        toFromList.add(result.data()['route']['route_info']['to']);
      }
    });
  });
}

//--------------------------------------------------------------------------------------------------------
// Converts the route details into object of type TripDetails and stores it in allRoutesAccordingToPreference

getAllRoutesAccordingToPreference(){
  final firestoreInstance = FirebaseFirestore.instance;
  String desc="";
  String title="";
  String tripImage="";
  String toCity="";
  String fromCity="";
  sortedDocIds.forEach((element) async{
    await firestoreInstance.collection("trip").doc(element).get().then((value){
      desc=(value.data()["info"]['desc']);
      title=(value.data()["info"]['title']);
      tripImage=(value.data()["info"]['photo']);
      toCity=(value.data()['route']["route_info"]['to']);
      fromCity=(value.data()['route']["route_info"]['from']);
    });
    allRoutesAccordingToPreference.add(TripDetails(desc: desc,title: title,tripImage: tripImage,toCity: toCity,fromCity: fromCity,));
  });

}


//----------------------------------------------------------------------------------------------


printAllDetails() {
  print('###### Below : currentUserPreference ######');
  print(currentUserPreference);
  print('###### Below : nestedRoutePreferences ######');
  print(nestedRoutePreferences);
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



