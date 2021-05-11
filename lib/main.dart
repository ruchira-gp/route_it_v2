import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:route_it_v2/ri/screen/HomePage.dart';
import 'package:route_it_v2/ri/screen/QIBusHome.dart';
import 'package:route_it_v2/ri/screen/QIBusSignIn.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home :Splash()));
}
class Splash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return App();
  }
}
DatabaseReference userRef = FirebaseDatabase.instance.reference().child("user");
class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {

    _initialization;
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('SOmewtging went rwomg');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != null) {
                User user = snapshot.data;
                if (user == null) {
                  return QIBusSignIn();
                } else {
                  return QIBusHome();
                }
              }
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(width: 0.0,height: 0.0,);
        // print('loading');
      },
    );
  }
}



