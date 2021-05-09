
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
class CheckedIn extends StatefulWidget {
  CheckedIn({Key key}) : super(key: key);
  @override
  _CheckedInState createState() => _CheckedInState();
}

class _CheckedInState extends State<CheckedIn> {
  List<TripDetails> TD=[];
  List<TripDetails> B = [];
  var toFromList = [];
  List <String> documentId=[];


  Widget appBarTitle = Text(
    "Trips",
    style: TextStyle(color: Colors.white),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  List userData = [];
  List<String> userNameData = [];
  // ignore
  bool _IsSearching;
  String _searchText = "";

  _CheckedInState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = true;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }


  // doThis(){
  //
  //   VDD.add(VisitorDetails(
  //     name: 'ramzan',
  //     otp: '123',
  //     totalVisitor: '2',
  //     guest_status: '2',
  //     phNo: '1234567890',
  //     visitTime: '10-2-12',
  //     checkOutTime: '10-2-12',
  //     checkinTime: '10-2-12',
  //     employeeName: 'apple',
  //     purpose: 'assc',
  //     visitDate: '14-10-2020',
  //     visitorImage: 'https://visitor.prusight.com/uploads/guestImages/5f86a4f98623b.jpg',
  //   ));
  //   VDD.add(VisitorDetails(
  //     name: 'ritviz',
  //     otp: '123',
  //     totalVisitor: '2',
  //     guest_status: '2',
  //     phNo: '1234567890',
  //     visitTime: '10-2-12',
  //     checkOutTime: '10-2-12',
  //     checkinTime: '10-2-12',
  //     employeeName: 'apple',
  //     purpose: 'assc',
  //     visitDate: '14-10-2020',
  //     visitorImage: 'https://visitor.prusight.com/uploads/guestImages/5f86a4f98623b.jpg',
  //   ));
  //   VDD.add(VisitorDetails(
  //     name: 'rakesh',
  //     otp: '123',
  //     totalVisitor: '2',
  //     guest_status: '2',
  //     phNo: '1234567890',
  //     visitTime: '10-2-12',
  //     checkOutTime: '10-2-12',
  //     checkinTime: '10-2-12',
  //     employeeName: 'apple',
  //     purpose: 'assc',
  //     visitDate: '14-10-2020',
  //     visitorImage: 'https://visitor.prusight.com/uploads/guestImages/5f86a4f98623b.jpg',
  //   ));
  //   VDD.add(VisitorDetails(
  //     name: 'ramu',
  //     otp: '123',
  //     totalVisitor: '2',
  //     guest_status: '2',
  //     phNo: '1234567890',
  //     visitTime: '10-2-12',
  //     checkOutTime: '10-2-12',
  //     checkinTime: '10-2-12',
  //     employeeName: 'apple',
  //     purpose: 'assc',
  //     visitDate: '14-10-2020',
  //     visitorImage: 'https://visitor.prusight.com/uploads/guestImages/5f86a4f98623b.jpg',
  //   ));
  //   VDD.add(VisitorDetails(
  //     name: 'ram',
  //     otp: '123',
  //     totalVisitor: '2',
  //     guest_status: '2',
  //     phNo: '1234567890',
  //     visitTime: '10-2-12',
  //     checkOutTime: '10-2-12',
  //     checkinTime: '10-2-12',
  //     employeeName: 'apple',
  //     purpose: 'assc',
  //     visitDate: '14-10-2020',
  //     visitorImage: 'https://visitor.prusight.com/uploads/guestImages/5f86a4f98623b.jpg',
  //   ));
  //   VDD.add(VisitorDetails(
  //     name: 'abcd',
  //     otp: '123',
  //     totalVisitor: '2',
  //     guest_status: '2',
  //     phNo: '1234567890',
  //     visitTime: '10-2-12',
  //     checkOutTime: '10-2-12',
  //     checkinTime: '10-2-12',
  //     employeeName: 'apple',
  //     purpose: 'assc',
  //     visitDate: '14-10-2020',
  //     visitorImage: 'https://visitor.prusight.com/uploads/guestImages/5f86a4f98623b.jpg',
  //   ));
  // }
  _buildList() {
   // List<TripDetails> VD = TD;

    return TD;
  }

  _buildSearchList() {
     // ignore: non_constant_identifier_names
     List<TripDetails> VD =[];
    // VD=TD;
    if (_searchText.isEmpty) {
      return TD;
    } else {
      List<TripDetails> _searchList = [];
      TD.forEach((element) {
        if (element.toCity
            .toString()
            .toLowerCase()
            .contains(_searchText.toLowerCase()))
          _searchList.add(element);
      });

      setState(() {
        B = _searchList;
      });
      return _searchList;
    }
  }
  getTripDetails()async {
    final firestoreInstance = FirebaseFirestore.instance;
    String desc="";
    String title="";
    String tripImage="";
    String toCity="";
    String fromCity="";
    documentId.forEach((element) async{
      print("docid = $element");
        await firestoreInstance.collection("trip").doc(element).get().then((value){
         desc=(value.data()["info"]['desc']);
         title=(value.data()["info"]['title']);
         tripImage=(value.data()["info"]['photo']);
         toCity=(value.data()['route']["route_info"]['to']);
         fromCity=(value.data()['route']["route_info"]['from']);
       });
       print("$desc ");
      TD.add(TripDetails(desc: desc,title: title,tripImage: tripImage,toCity: toCity,fromCity: fromCity,));
    });

  }
        getToFromList() async {
      final firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance.collection("trip").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          if (result.data()['route']['route_info']['from'] ==
              "Mysore") {
            print('this is id ');
            print(result.id);
            // print(result.data()['route']['route_info']['to']);

            documentId.add(result.id);
          }
        });
      });
      print("###############################################");
      print(documentId);
    }
    doThis ()async{
    await getToFromList();
    await getTripDetails();
    }
    @override
    void initState() {
      super.initState();
      _IsSearching = false;

      doThis();

    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white70,
        key: key,
        appBar: buildBar(context),
        body: GridView(
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: _IsSearching ? _buildSearchList():_buildList()  ,
        ),

        //_IsSearching ? _buildSearchList() : _buildList(),
      );
    }

    Widget buildBar(BuildContext context) {
      return AppBar(
          centerTitle: true,
          title: appBarTitle,
          backgroundColor: Colors.lightBlueAccent,
          actions: <Widget>[
            IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = Icon(
                      Icons.close,
                      color: Colors.white,
                    );
                    this.appBarTitle = TextField(
                      controller: _searchQuery,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.white)),
                    );
                    _handleSearchStart();
                  } else {
                    _handleSearchEnd();
                  }
                });
              },
            )
          ]);
    }

    void _handleSearchStart() {
      setState(() {
        _IsSearching = true;
      });
    }

    void _handleSearchEnd() {
      setState(() {
        this.actionIcon = Icon(
          Icons.search,
          color: Colors.white,
        );
        this.appBarTitle = Text(
          "Trips",
          style: TextStyle(color: Colors.white),
        );
        _IsSearching = false;
        _searchQuery.clear();
      });
    }
  }


class ChildItem extends StatelessWidget {
  final String name;

  ChildItem(this.name);

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(this.name));
  }
}
class TripDetails extends StatelessWidget {
  final String desc;
  final String title;
  final String tripImage;
  final String toCity;
  final String fromCity;
  TripDetails({this.fromCity,
    this.desc,
    this.title,
    this.toCity,
    this.tripImage
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



