import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:route_it_v2/ri/utils/AllRequiredFunctions.dart';

class DisplayAllRoutes extends StatefulWidget {
  DisplayAllRoutes({Key key}) : super(key: key);
  @override
  _DisplayAllRoutesState createState() => _DisplayAllRoutesState();
}

class _DisplayAllRoutesState extends State<DisplayAllRoutes> {
  Widget appBarTitle = Text(
    "Trips",
    style: TextStyle(color: Colors.white),
  );
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white70,
        appBar: buildBar(context),
        body: GridView(
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: allRoutesAccordingToPreference,
        ),
      );
    }
    Widget buildBar(BuildContext context) {
      return AppBar(
          centerTitle: true,
          title: appBarTitle,
          backgroundColor: Colors.lightBlueAccent,
      );
    }


  }





