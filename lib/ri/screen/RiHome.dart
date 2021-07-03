
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:route_it_v2/main/utils/latlong.dart';

import 'package:route_it_v2/ri/screen/About.dart';
import 'package:route_it_v2/ri/screen/FirstPreferencePage.dart';
import 'package:route_it_v2/ri/screen/HomePage.dart';

import 'package:route_it_v2/ri/screen/RouteUpload.dart';
import 'package:route_it_v2/ri/screen/DisplayAllRoutes.dart';

import 'package:route_it_v2/ri/utils/AllRequiredFunctions.dart';

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
              //retrieveUserRoutePreference();
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
              // nestedRoutePreferences.clear();
              // currentUserPreference.clear();
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
      HomePageRI(),
      // Hello(),
      // Hello(),
      // Hello(),

     DisplayAllRoutes(),


  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  doThis()async{
     // await retrieveAllDocIds();
     // await retrieveRoutePreferences();
     // await retrieveUserRoutePreference();
     // await getToList();
     // await getFromList();
     // await  getToFromList('Mysore');
     // await cosineDist();
     // await  sortDocIdsAfterCosine();
      await getAllRoutesAccordingToPreference();
     // await printAllDetails();

  }
@override
  void initState() {
    // TODO: implement initState
  if(sortedMap!=null)
  sortedMap.clear();
  if(sortedDocIds!=null)// sorted map got after cosine function
  sortedDocIds.clear();// List of all sorted Document IDs after cosine function
  allDocIds.clear();
   toList = []; // toCity List
  fromList = []; // fromCity list
   toFromList = []; // toCity list , given fromCity
    allRoutesAccordingToPreference = [] ;
  retrieveAllDocIds();

  getToList();
  getFromList();
  getToFromList('Mysore');
  cosineDist();


    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RouteUpload()));
        },
        child: const Icon(Icons.upload_sharp),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(

        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(

          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child:  Image.asset('images/ri/app_logo.png'),
            ),
            ListTile(

              title: Text('Edit Preferences'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FirstPreference()));
              },
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => About()));

              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          ElevatedButton(onPressed: ()async{
            final ProgressDialog prx =  ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
            prx.style(
                message: 'Logging Out , Please Wait',
                borderRadius: 10.0,
                backgroundColor: Colors.white,
                progressWidget: CircularProgressIndicator(),
                elevation: 10.0,
                insetAnimCurve: Curves.easeInOut,

                progressTextStyle: TextStyle(
                    color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
                messageTextStyle: TextStyle(
                    color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
            );
            await prx.show();

            signOut(context);
            sortedDocIds.clear();
            sortedMap.clear();
            toList.clear();
            fromList.clear();
            toFromList.clear();
            allRoutesAccordingToPreference.clear();
            await prx.hide();
          }, child: Icon(Icons.power_settings_new_sharp))
        ],
        title: Center(child: const Text('Route It')),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[600],
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
            icon: Icon(Icons.map_outlined),
            label: 'Browse Routes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

