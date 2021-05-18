import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:route_it_v2/ri/screen/HomePage.dart';
import 'package:route_it_v2/ri/screen/QIBusHome.dart';
import 'package:route_it_v2/ri/screen/QIBusSignIn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clipboard/clipboard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:dart_now_time_filename/dart_now_time_filename.dart';
import '../../main.dart';

class RouteUpload extends StatefulWidget {
  @override
  _RouteUploadState createState() => _RouteUploadState();
}

class _RouteUploadState extends State<RouteUpload> {
  TextEditingController titleTextEditingController = TextEditingController();

  TextEditingController descriptionTextEditingController =
      TextEditingController();

  TextEditingController durationTextEditingController = TextEditingController();

  TextEditingController expensesTextEditingController = TextEditingController();

  TextEditingController modeTextEditingController = TextEditingController();

  TextEditingController travelMonthTextEditingController =
      TextEditingController();

  TextEditingController fromTextEditingController = TextEditingController();

  TextEditingController toTextEditingController = TextEditingController();

  TextEditingController linkTextEditingController = TextEditingController();
  double mpref = 1;
  double fpref = 1;
  double hpref = 1;
  double ppref = 1;
  double rpref = 1;
  double dpref = 1;

  //TextEditingController controller = TextEditingController();

  String paste = '';
  var _imageFile;
  String imageUrl;
  final _imagePicker = ImagePicker();
  PickedFile image;
  //Check Permissions

  File file;
  selectImage() async {
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.gallery);
      file = File(image.path);
    } else {
      print('No Image Path Received');
    }
  }

  uploadImageAndRoute() async {
    final ProgressDialog pr =  ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    pr.style(
        message: 'Route Uploading , Please Wait',
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
    final _firebaseStorage = FirebaseStorage.instance;

    var firebaseUser = FirebaseAuth.instance.currentUser;

    final firestoreInstance = FirebaseFirestore.instance;
    CollectionReference trip = FirebaseFirestore.instance.collection('trip');
    if (image != null) {
      //Upload to Firebase
      String tt = NowFilename.genNowFilename();
      var snapshot =
          await _firebaseStorage.ref().child('images/$tt').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    }
    firestoreInstance.collection("trip").doc().set({
      "info": {
        "desc": descriptionTextEditingController.text,
        "photo": imageUrl,
        "title": titleTextEditingController.text,
      },
      "likes": 2,
      "misc": {
        "duration_days": durationTextEditingController.text,
        "expenses": expensesTextEditingController.text,
        "mode": modeTextEditingController.text,
        "travel_month": travelMonthTextEditingController.text,
      },
      "route": {
        "prefs": {
          "mountain": mpref.toInt().toString(),
          "forest": fpref.toInt().toString(),
          "pilgrimage": ppref.toInt().toString(),
          "highway": hpref.toInt().toString(),
          "riverside": rpref.toInt().toString(),
          "desert": dpref.toInt().toString()
        },
        "route_info": {
          "from": fromTextEditingController.text,
          "link": linkTextEditingController.text,
          "to": toTextEditingController.text,
        }
      }
    }).then((_) async{
      fromTextEditingController.clear();
      titleTextEditingController.clear();

      descriptionTextEditingController.clear();

      durationTextEditingController.clear();

      expensesTextEditingController.clear();

      modeTextEditingController.clear();

      travelMonthTextEditingController.clear();

      toTextEditingController.clear();

      linkTextEditingController.clear();
      await pr.hide();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => NavigatorPage()),
        ModalRoute.withName('/'),
      );
      print("success!");


    });
  }

  List modes = ['Motorcycle', 'Car', 'Bus', 'Flight'];
  double i = 1;
  int _value = 1;
  DateTime currentDate = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        String formatted = formatter.format(pickedDate);
        travelMonthTextEditingController.text = formatted;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 35.0,
              ),
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Upload Route",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand-Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: titleTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Title",
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

                    SizedBox(
                      height: 1.0,
                    ),
                    TextFormField(
                      controller: descriptionTextEditingController,
                      decoration: InputDecoration(
                          labelText: "Description",
                          hintText: 'Amazing place ! Must Visit !'),
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),

                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: durationTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Number of days",
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

                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: expensesTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Expenses",
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
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Mode of Travel'),
                    ),
                    Column(
                      children: <Widget>[
                        for (int i = 0; i <= 3; i++)
                          ListTile(
                            title: Text(
                              '${modes[i]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: Colors.black38),
                            ),
                            leading: Radio(
                              value: i,
                              groupValue: _value,
                              onChanged: (int value) {
                                setState(() {
                                  _value = value;
                                  modeTextEditingController.text = modes[value];
                                });
                              },
                            ),
                          ),
                      ],
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(formatter.format(currentDate)),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Select date'),
                        ),
                      ],
                    ),
                    TextField(
                      controller: travelMonthTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Travel Date",
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
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: toTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "To ",
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
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: fromTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "From",
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
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: linkTextEditingController,
                      enableInteractiveSelection: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Link",
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
                    Row(
                      children: [
                        buildPaste(),
                        SizedBox(width: 20,),
                        Text('<- Click to Paste Link Above'),
                      ],
                    ),
                    ElevatedButton(
                      // color: Colors.blueAccent,
                      // textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Select Image",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      // shape: new RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.circular(24.0),
                      // ),
                      onPressed: () {
                        selectImage();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Route Topography'),
                    ),

                    Card(
                      elevation: 7.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('RiverSide : ${rpref.toInt()}'),
                            ),
                            Slider(
                              value: rpref,
                              min: 0,
                              max: 6,
                              divisions: 6,
                              label: rpref.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  rpref = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ), //R
                    Card(
                      elevation: 7.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Mountains : ${mpref.toInt()}'),
                            ),
                            Slider(
                              value: mpref,
                              min: 0,
                              max: 6,
                              divisions: 6,
                              label: mpref.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  mpref = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ), //m
                    Card(
                      elevation: 7.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Pilgrimage : ${ppref.toInt()}'),
                            ),
                            Slider(
                              value: ppref,
                              min: 0,
                              max: 6,
                              divisions: 6,
                              label: ppref.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  ppref = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ), //p
                    Card(
                      elevation: 7.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Highway : ${hpref.toInt()}'),
                            ),
                            Slider(
                              value: hpref,
                              min: 0,
                              max: 6,
                              divisions: 6,
                              label: hpref.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  hpref = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ), //h
                    Card(
                      elevation: 7.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Desert : ${dpref.toInt()}'),
                            ),
                            Slider(
                              value: dpref,
                              min: 0,
                              max: 6,
                              divisions: 6,
                              label: dpref.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  dpref = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ), //d
                    Card(
                      elevation: 7.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Forest : ${fpref.toInt()}'),
                            ),
                            Slider(
                              value: fpref,
                              min: 0,
                              max: 6,
                              divisions: 6,
                              label: fpref.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  fpref = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ), //f

                    SizedBox(
                      height: 50.0,
                    ),
                    ElevatedButton(
                      // color: Colors.blueAccent,
                      // textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Route Upload",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      // shape: new RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.circular(24.0),
                      // ),
                      onPressed: () {
                        RegExp exp = new RegExp(
                            r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
                        Iterable<RegExpMatch> matches =
                            exp.allMatches(linkTextEditingController.text);

                        matches.forEach((match) {
                          linkTextEditingController.text =
                              (linkTextEditingController.text
                                  .substring(match.start, match.end));
                        });
                        if (mpref + dpref + ppref + rpref + hpref + fpref ==
                            0.0) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                      child: Text('Route Preference Invalid')),
                                  content: Text(
                                      'All route preferences cannot be zero'),
                                  actions: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 35),
                                      child: ElevatedButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              });


                        } else {

                          uploadImageAndRoute();

                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaste() => Row(
        children: [

          IconButton(
            icon: Icon(Icons.paste),
            onPressed: () async {
              final value = await FlutterClipboard.paste();

              setState(() {
                linkTextEditingController.text = value;
              });
            },
          )
        ],
      );
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}

class NumberInputWithIncrementDecrement extends StatefulWidget {
  @override
  _NumberInputWithIncrementDecrementState createState() =>
      _NumberInputWithIncrementDecrementState();
}

class _NumberInputWithIncrementDecrementState
    extends State<NumberInputWithIncrementDecrement> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = "0"; // Setting the initial value for the field.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Field increment decrement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  minWidth: 5.0,
                  child: Icon(Icons.arrow_drop_up),
                  onPressed: () {
                    int currentValue = int.parse(_controller.text);
                    setState(() {
                      currentValue++;
                      _controller.text =
                          (currentValue).toString(); // incrementing value
                    });
                  },
                ),
                MaterialButton(
                  minWidth: 5.0,
                  child: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    int currentValue = int.parse(_controller.text);
                    setState(() {
                      print("Setting state");
                      currentValue--;
                      _controller.text =
                          (currentValue).toString(); // decrementing value
                    });
                  },
                ),
              ],
            ),
            Spacer(
              flex: 2,
            )
          ],
        ),
      ),
    );
  }
}
