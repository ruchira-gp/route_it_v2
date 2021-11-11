import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:route_it_v2/ri/screen/FirstPreferencePage.dart';
import 'package:route_it_v2/ri/screen/RiHome.dart';
import 'package:route_it_v2/ri/screen/registrationScreen.dart';
import 'package:route_it_v2/ri/utils/RiColors.dart';
import 'package:route_it_v2/ri/utils/RiConstant.dart';
import 'package:route_it_v2/ri/utils/RiExtensions.dart';
import 'package:route_it_v2/ri/utils/RiStrings.dart';
import 'package:route_it_v2/ri/utils/RiWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:route_it_v2/ri/utils/AllRequiredFunctions.dart';


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
              // Center(
              //   child: text(QIBus_text_welcome_to,
              //       textColor: Colors.blue[500],
              //       fontFamily: fontBold,
              //       fontSize: textSizeLarge),
              // ),
              Center(
                  child: Image.asset(
                'images/ri/app_logo.png',
                scale: 4,
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
                      color: Colors.blue[500]),
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
                      color: Colors.blue[500]),
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
    final ProgressDialog pr =  ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    pr.style(
        message: 'Logging In , Please Wait',
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
    await pr.show();
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text,
          password: passwordTextEditingController.text
      );

      if (userCredential!=null){
        retrievePreferenceFlag().then((s)async {

          if(s==0)
            {
              await pr.hide();

              Navigator.pushAndRemoveUntil(  context,
                MaterialPageRoute(builder: (BuildContext context) => FirstPreference()),
                ModalRoute.withName('/'),);
              // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
             // displayToastMessage("You have successfully logged-in", context);
            }
          else
            {
              await pr.hide();
              Navigator.pushAndRemoveUntil(  context,
                MaterialPageRoute(builder: (BuildContext context) => NavigatorPage()),
                ModalRoute.withName('/'),);
              // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
             // displayToastMessage("You have successfully logged-in", context);
            }
        }
        );
      //  print("preferences2 ",$firebaseUser.uid);

      }
      else
      {
        await pr.hide();
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
