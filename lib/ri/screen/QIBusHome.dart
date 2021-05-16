import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:route_it_v2/ri/model/QiBusModel.dart';
import 'package:route_it_v2/ri/screen/FirstPreferencePage.dart';
import 'package:route_it_v2/ri/screen/HomePage.dart';
import 'package:route_it_v2/ri/screen/QIBusNotification.dart';
import 'package:route_it_v2/ri/screen/RouteUpload.dart';
import 'package:route_it_v2/ri/screen/DisplayAllRoutes.dart';
import 'package:route_it_v2/ri/utils/QiBusColors.dart';
import 'package:route_it_v2/ri/utils/QiBusConstant.dart';
import 'package:route_it_v2/ri/utils/QiBusDataGenerator.dart';
import 'package:route_it_v2/ri/utils/QiBusExtension.dart';
import 'package:route_it_v2/ri/utils/QiBusImages.dart';
import 'package:route_it_v2/ri/utils/QiBusStrings.dart';
import 'package:route_it_v2/ri/utils/QiBusWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:route_it_v2/ri/utils/AllRequiredFunctions.dart';
import 'package:document_analysis/document_analysis.dart';
import 'QIBusSearhList.dart';
import 'QIBusSignIn.dart';
import 'QIBusViewOffer.dart';
import 'dart:collection';
import 'package:route_it_v2/ri/screen/DisplaySearchedRoutes.dart';

class QIBusHome extends StatefulWidget {
  @override
  _QIBusHomeState createState() => _QIBusHomeState();
}

class _QIBusHomeState extends State<QIBusHome> {

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(child: ElevatedButton(
            child: Text('Compute'),
            onPressed: (){
              retrieveAllDocIds();
              retrieveRoutePreferences();
              retrieveUserRoutePreference();
              getToList();
              getFromList();
              getToFromList('Mysore');
              print('Compute');
            },

          ),),
          Center(child: ElevatedButton(
            child: Text("CosineDist"),
            onPressed: (){
              cosineDist();
              sortDocIdsAfterCosine();
              print('Cosine Distance');
            },
          ),),
          Center(child: ElevatedButton(
            child: Text("Trip Details"),
            onPressed: (){
              print("Trip Details");
              getAllRoutesAccordingToPreference();
            },
          ),),
          Center(child: ElevatedButton(
            child: Text("Print"),
            onPressed: (){
              printAllDetails();
            },
          ),),

          Center(child: ElevatedButton(
            child: Text("clear"),
            onPressed: (){
              print("cleared");
              allDocIds.clear();
              nestedRoutePreferences.clear();
              currentUserPreference.clear();
              sortedDocIds.clear();
              sortedMap.clear();
              toList.clear();
              fromList.clear();
              toFromList.clear();
              allRoutesAccordingToPreference.clear();

            },
          ),),
          Center(child: ElevatedButton(
            child: Text("Logout"),
            onPressed: (){
              signOut(context);
            },
          ),),
          Center(child: ElevatedButton(
            child: Text("Display routes"),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DisplayAllRoutes()));
            },
          ),),
          Center(child: ElevatedButton(
            child: Text("Search routes"),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DisplaySearchedRoutes()));
            },
          ),),
        ],
      ),
    );
  }
}


class NavigatorPage extends StatefulWidget {


  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _NavigatorPageState extends State<NavigatorPage> {

  int _selectedIndex = 1;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    List<Widget> _widgetOptions = <Widget>[
      DisplaySearchedRoutes(),
      QIBusHome(),
     // DisplayAllRoutes(),
      RouteUpload(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  doThis()async{
     await retrieveAllDocIds();
     await retrieveRoutePreferences();
     await retrieveUserRoutePreference();
     await getToList();
     await getFromList();
     await  getToFromList('Mysore');
     await cosineDist();
     await  sortDocIdsAfterCosine();
     await getAllRoutesAccordingToPreference();
     await printAllDetails();

  }
@override
  void initState() {
    // TODO: implement initState

    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(onPressed: (){
            clearAllData();
            signOut(context);
          }, child: Icon(Icons.power_settings_new_sharp))
        ],
        title: Center(child: const Text('Route It')),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_rounded),
            label: 'Upload Route',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

