import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:route_it_v2/ri/screen/FirstPreferencePage.dart';
import 'package:route_it_v2/ri/screen/QIBusHome.dart';
import 'package:route_it_v2/ri/screen/preferenceSelection.dart';
import 'package:route_it_v2/ri/screen/progressDialog.dart';
import 'package:route_it_v2/ri/screen/registrationScreen.dart';
import 'package:route_it_v2/ri/screen/temp.dart';
import 'package:route_it_v2/ri/utils/QiBusColors.dart';
import 'package:route_it_v2/ri/utils/QiBusConstant.dart';
import 'package:route_it_v2/ri/utils/QiBusExtension.dart';
import 'package:route_it_v2/ri/utils/QiBusImages.dart';
import 'package:route_it_v2/ri/utils/QiBusStrings.dart';
import 'package:route_it_v2/ri/utils/QiBusWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:route_it_v2/ri/utils/AllRequiredFunctions.dart';
import 'package:route_it_v2/ri/utils/codePicker/country_code_picker.dart';

import '../../main.dart';
import 'HomePage.dart';
import 'QIBusVerification.dart';

class QIBusSignIn extends StatefulWidget {
  static String tag = '/QIBusSignIn';

  @override
  QIBusSignInState createState() => QIBusSignInState();
}

class QIBusSignInState extends State<QIBusSignIn> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    changeStatusColor(qIBus_white);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: qIBus_white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(16, 30, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              text(QIBus_text_welcome_to,
                  textColor: qIBus_textChild,
                  fontFamily: fontBold,
                  fontSize: textSizeLarge),
              text(QIBus_text_qibus,
                  textColor: qIBus_colorPrimary,
                  fontFamily: fontBold,
                  fontSize: textSizeXLarge),
              Center(
                  child: Image.asset(
                'images/ri/app_logo.png',
                scale: 5,
              )),
              // CachedNetworkImage(
              //   imageUrl: qibus_ic_travel,
              //   height: width * 0.5,
              //   width: width,
              //   fit: BoxFit.contain,
              // ),
              SizedBox(
                height: 25,
              ),
              Container(
                  decoration: boxDecoration(
                      showShadow: false,
                      bgColor: qIBus_white,
                      radius: 8,
                      color: qIBus_colorPrimary),
                  padding: EdgeInsets.all(0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 30,
                          style: TextStyle(
                              fontSize: textSizeLargeMedium,
                              fontFamily: fontRegular),
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            hintText: QIBus_hint_enter_your_emailId,
                            hintStyle: TextStyle(
                                color: qIBus_textChild,
                                fontSize: textSizeMedium),
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 25,
              ),
              Container(
                  decoration: boxDecoration(
                      showShadow: false,
                      bgColor: qIBus_white,
                      radius: 8,
                      color: qIBus_colorPrimary),
                  padding: EdgeInsets.all(0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: passwordTextEditingController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          maxLength: 30,
                          style: TextStyle(
                              fontSize: textSizeLargeMedium,
                              fontFamily: fontRegular),
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            hintText: QIBus_hint_password,
                            hintStyle: TextStyle(
                                color: qIBus_textChild,
                                fontSize: textSizeMedium),
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 16,
              ),
              QIBusAppButton(
                textContent: QIBus_lbl_continue,
                onPressed: () {
                  if(!emailTextEditingController.text.contains("@"))
                  {
                    displayToastMessage("Email address is not valid", context);
                  }
                  else if(passwordTextEditingController.text.isEmpty)
                  {
                    displayToastMessage("Password is mandatory", context);
                  }
                  else
                  {
                    loginAndAuthenticateUser(context);
                  }
                  // launchScreen(context, QIBusVerification.tag);
                },
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      width: width * 0.4,
                      height: 0.5,
                      color: qIBus_view_color,
                    ),
                    MyButton(),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async{

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return ProgressDialog(message: "Authenticating, Please Wait ...",);
        }
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text,
          password: passwordTextEditingController.text
      );
      var hello;
      if (userCredential!=null){
        retrievePreferenceFlag().then((s) {
          if(s==0)
            {
              Navigator.pushAndRemoveUntil(  context,
                MaterialPageRoute(builder: (BuildContext context) => FirstPreference()),
                ModalRoute.withName('/'),);
              // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
              displayToastMessage("You have successfully logged-in", context);
            }
          else
            {
              Navigator.pushAndRemoveUntil(  context,
                MaterialPageRoute(builder: (BuildContext context) => QIBusHome()),
                ModalRoute.withName('/'),);
              // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
              displayToastMessage("You have successfully logged-in", context);
            }
        }
        );
      //  print("preferences2 ",$firebaseUser.uid);

      }
      else
      {
        Navigator.of(context, rootNavigator: true).pop();
        _firebaseAuth.signOut();
        displayToastMessage("No record exists for this user. Please create new Account", context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

    }

    //
    // final User firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
    //     email: emailTextEditingController.text,
    //     password: passwordTextEditingController.text).catchError((errMsg){
    //   Navigator.of(context, rootNavigator: true).pop();
    //   displayToastMessage("Error :" + errMsg.toString(), context);
    // })).user;
    //
    // if (firebaseUser != null) { // User created
    //
    //   userRef.child(firebaseUser.uid).once().then(( DataSnapshot snap){
    //     if(snap.value !=null){
    //       Navigator.pushAndRemoveUntil(  context,
    //         MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
    //         ModalRoute.withName('/'),);
    //       // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
    //       displayToastMessage("You have successfully logged-in", context);
    //     }
    //     else
    //       {
    //         Navigator.of(context, rootNavigator: true).pop();
    //         _firebaseAuth.signOut();
    //         displayToastMessage("No record exists for this user. Please create new Account", context);
    //       }
    //   });
    // }
    // else{
    //   Navigator.of(context, rootNavigator: true).pop();
    //   displayToastMessage("Error Occurred, Please try again", context);
    // }
  }
  }


class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.green;
      }
      return Colors.blue;
    }

    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(getColor),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => RegistrationScreen()));
      },
      child: const Text('Do not have an account ? Sign Up '),
    );
  }
}
