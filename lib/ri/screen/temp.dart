
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
  //List userData = [];
  //List<String> userNameData = [];
  // ignore
  bool _isSearching=false;
  String _searchText = "";

  _CheckedInState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty==true) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }



  _buildList() {
    List<TripDetails> VD = [];
   // VD=TD;
   // print(VD.length);
    return VD;
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
      _isSearching = false;

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
          children: _isSearching ? _buildSearchList():_buildList()  ,
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
        _isSearching = true;
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
        _isSearching = false;
        _searchQuery.clear();
      });
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

// class VisitorDetails extends StatelessWidget {
//   final String name;
//   final String phNo;
//   final String checkOutTime;
//   final String totalVisitor;
//   final String visitTime;
//   final String otp;
//   final  String guest_status;
//   final String visitDate;
//   final String checkinTime;
//   final String purpose;
//   final String employeeName;
//   final String visitorImage;
//   VisitorDetails(
//       {this.checkOutTime,
//         this.otp,
//         this.guest_status,
//         this.visitTime,
//         this.totalVisitor,
//         this.phNo,
//         this.name,
//         this.purpose,
//         this.employeeName,
//         this.visitDate,
//         this.checkinTime,
//         this.visitorImage,
//       });
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Center(child: Text('Visitor Details')),
//                 content: Container(
//                   child: Column(
//                     children: [
//                       Stack(
//                         children: [
//                           CircleAvatar(
//                             backgroundImage: AssetImage('images/ri/qibus_ic_home_selected.png'),
//                             backgroundColor: Colors.transparent,
//                             radius: 45,
//                           ),
//                           CircleAvatar(
//                             backgroundImage:NetworkImage(visitorImage),
//                             backgroundColor: Colors.transparent,
//                             radius: 45,
//                             //backgroundImage: ImageProvider(AssetImage('images/DANKJI.png')),
//                           ),
//                         ],
//                       ),
//                       Text('Name',style: TextStyle(color: Colors.green,),textAlign: TextAlign.left,),
//                       Text(name,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,fontStyle:FontStyle.normal),),
//                       SizedBox(height: 15,),
//                       Row(
//                         children: [
//                           Column(crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Text('Visit Date ', style: TextStyle(color: Colors.grey,),textAlign: TextAlign.left,),
//                               Text(visitDate,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                               SizedBox(height: 15,),
//                               Text('Phone Number ',style: TextStyle(color: Colors.grey,),textAlign: TextAlign.left,),
//                               Text(phNo,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                               SizedBox(height: 15,),
//                               Text('Employee Name',style: TextStyle(color: Colors.grey,),textAlign: TextAlign.left,) ,
//                               Text(employeeName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                               SizedBox(height: 15,),
// //                              Text('Purpose',style: TextStyle(color: Colors.grey,),textAlign: TextAlign.left,),
// //                              Text(purpose,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                             ],
//                           ),Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               height: 190.0,
//                               width: 1.0,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Text('Visit Time',style: TextStyle(color: Colors.grey,),textAlign: TextAlign.left,) ,
//                                 Text(visitTime,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                                 SizedBox(height: 15,),
//                                 Text('Check-in Time',style: TextStyle(color: Colors.grey,),textAlign: TextAlign.left,),
//                                 Text(checkinTime,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.indigo),),
//                                 SizedBox(height: 15,),
//                                 Text('Check-out Time ',style: TextStyle(color: Colors.grey,),textAlign: TextAlign.left,),
//                                 Text(checkOutTime,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.red),),
//                                 SizedBox(height: 15,),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Container(
//                           height: 1.0,
//                           width: 250.0,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text('Purpose of Visit',style: TextStyle(color: Colors.grey,),textAlign: TextAlign.left,) ,
//                       Text(purpose,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                       SizedBox(height: 15,),
//                       Text('Total Visitors',style: TextStyle(color: Colors.grey,),textAlign: TextAlign.left,) ,
//                       Text(totalVisitor,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
//
//
//                     ],
//                   ),
//                 ),
//                 actions: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 35),
//                     child: FlatButton(
//                       child: Text('OK'),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 35),
//                     child: FlatButton(
//                       child: Text(
//                         'Check-out',style: TextStyle(color: Colors.red),
//                       ),
//                       onPressed: guest_status == '2' ||
//                           guest_status == '4' ||
//                           guest_status == '1'
//                           ? null
//                           : () async {
//                         print(' fuck you');
//                       },
//                     ),
//                   ),
//
//
//                 ],
//               );
//             });
//         //LowView(name: name,phNo: phNo,checkInTime: checkInTime,totalVisitor: totalVisitor,visitTime: visitTime,);
//       },
//       child: Card(
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Row(
//                   children: [
//                     Stack(
//                       children: [
//
//                         CircleAvatar(
//                           backgroundImage:NetworkImage(visitorImage,scale: 5),
//                           backgroundColor: Colors.transparent,
//                           radius: 25,
//                           //backgroundImage: ImageProvider(AssetImage('images/DANKJI.png')),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text('Visit Time'),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text('$visitTime'),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//                 Text(
//                   '$name',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text('$phNo'),
//                 Text(
//                   'Check out: $checkOutTime',
//                   style: TextStyle(color: Colors.green),
//                 ),
//                 Text('Total Visitor :$totalVisitor'),
//               ],
//             ),
//           )),
//     );
//   }
// }

