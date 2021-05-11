import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:route_it_v2/ri/screen/QIBusHome.dart';
class FirstPreference extends StatefulWidget {


  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<FirstPreference> {
  final List<String> _items =["Desert","Forest","Highway","Mountain","Pilgrimage","RiverSide",] ;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    final String highPreference=" High Preference";
    final String mediumPreference=" Medium Preference";
    final String lowPreference=" Low Preference";

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton:  FloatingActionButton(

          onPressed: () {
            var firebaseUser =  FirebaseAuth.instance.currentUser;
            final firestoreInstance = FirebaseFirestore.instance;
            firestoreInstance.collection("users").doc(firebaseUser.uid).update({
              "pref_flag": 1,
              "prefs.mountain" : _items.length-_items.indexOf("Mountain"),
              "prefs.forest" : _items.length-_items.indexOf("Forest"),
              "prefs.pilgrimage" :_items.length- _items.indexOf("Pilgrimage"),
              "prefs.highway" :_items.length-_items.indexOf("Highway"),
              "prefs.riverside" : _items.length-_items.indexOf("RiverSide"),
              "prefs.desert" : _items.length-_items.indexOf("Desert"),
            }).then((_) {
              print("success!");
              Navigator.pushAndRemoveUntil(  context,
                MaterialPageRoute(builder: (BuildContext context) => QIBusHome()),
                ModalRoute.withName('/'),);
            });
          },
          child: const Icon(Icons.done),
          backgroundColor: Colors.green,),
      appBar: AppBar(title: Text('Order the list'),
      actions: [

        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => QIBusHome()));
        }, child: Icon(Icons.home)),

      ],),

        body:  ReorderableListView(

     // padding: const EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        for (int index = 0; index < _items.length; index++)

          ListTile(
            subtitle: (index>=2 && index<4)?Text(mediumPreference):(index<2?Text(highPreference):Text(lowPreference)) ,
            isThreeLine: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 20),
            key: Key('$index'),
            tileColor: index%2==0 ? oddItemColor : evenItemColor,
            title: Text(' ${_items[index]}'),
            trailing: Container(
              child: Center(child: Text((index+1).toString(),style: TextStyle(color: Colors.white),)),
              height:30,
              width: 30,
              decoration: BoxDecoration(color:Colors.green,borderRadius: BorderRadius.circular(12), ),
            ),
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final String item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
      },
    )
    );
  }
}