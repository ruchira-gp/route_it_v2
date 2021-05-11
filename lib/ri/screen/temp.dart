
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:route_it_v2/ri/utils/AllRequiredFunctions.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
class DisplayAllRoutes extends StatefulWidget {
  DisplayAllRoutes({Key key}) : super(key: key);
  @override
  _DisplayAllRoutesState createState() => _DisplayAllRoutesState();
}

class _DisplayAllRoutesState extends State<DisplayAllRoutes> {
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

  _DisplayAllRoutesState() {
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
          children: allRoutesAccordingToPreference,
        ),

        //_IsSearching ? _buildSearchList() : _buildList(),
      );
    }

    Widget buildBar(BuildContext context) {
      return AppBar(
          centerTitle: true,
          title: appBarTitle,
          backgroundColor: Colors.lightBlueAccent,
      );
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





