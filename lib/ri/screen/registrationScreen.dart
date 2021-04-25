import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:route_it_v2/ri/screen/QIBusHome.dart';
import 'package:route_it_v2/ri/screen/QIBusSignIn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:route_it_v2/ri/screen/progressDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';
class RegistrationScreen extends StatelessWidget {
  static const String idScreen = 'register';

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 35.0,),

              SizedBox(height: 1.0,),
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand-Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 10.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 50.0,),
                    ElevatedButton(
                      // color: Colors.blueAccent,
                      // textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      // shape: new RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.circular(24.0),
                      // ),
                      onPressed: (){
                        if (nameTextEditingController.text.length < 3){
                          displayToastMessage("Name must be atleast 3 Characters", context);
                        }
                        else if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("Email address is not valid", context);
                        }
                        else if(phoneTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Phone Number is mandatory", context);
                        }
                        else if(passwordTextEditingController.text.length < 6)
                        {
                          displayToastMessage("Password must be atleast 6 Characters", context);
                        }
                        registerNewUser(context);
                      },
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => QIBusSignIn(),
                    ),
                        (route) => false,
                  );
                },
                child: Text(
                  "Already have an Account? Login Here",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Registering, Please Wait ...",);
        }
    );
    final User firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error :" + errMsg.toString(), context);
    })).user; //if return is None then user is not created

    if (firebaseUser != null) { // User created
      //Save user info to the database
      var firebaseUser =  FirebaseAuth.instance.currentUser;

      final firestoreInstance = FirebaseFirestore.instance;

      firestoreInstance.collection("users").doc(firebaseUser.uid).set(
          {
            "name" : nameTextEditingController.text,
            "email" : emailTextEditingController.text,
            "phno" : phoneTextEditingController.text,
            "pref_flag":0,
            "prefs" : {
              "mountain" : 0,
              "forest" : 0,
              "pilgrimage" : 0,
              "highway" : 0,
              "riverside" : 0,
              "desert" : 0
            }
          }).then((_){
        print("success!");
      });




      // firestoreInstance.collection("users").add(
      //     {
      //       "name" : nameTextEditingController.text,
      //       "email" : emailTextEditingController.text,
      //       "phno" : phoneTextEditingController.text,
      //       "pref_flag":0,
      //       "prefs" : {
      //         "mountain" : 0,
      //         "forest" : 0,
      //         "pilgrimage" : 0,
      //         "highway" : 0,
      //         "riverside" : 0,
      //         "desert" : 0
      //       }
      //     }).then((value){
      //   print(value.id);
      // });
      displayToastMessage("Congragulations, your account has been created", context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => QIBusSignIn(),
        ),
            (route) => false,
      );
    }
    else{
      Navigator.pop(context);
      displayToastMessage("New user account has not been Created", context);
    }
  }
}

displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
}