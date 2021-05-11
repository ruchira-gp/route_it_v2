//
//
// import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:route_it_v2/ri/screen/HomePage.dart';
// import 'package:route_it_v2/ri/screen/QIBusHome.dart';
// import 'package:route_it_v2/ri/screen/QIBusSignIn.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:route_it_v2/ri/screen/progressDialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:clipboard/clipboard.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/services.dart';
// import 'package:dart_now_time_filename/dart_now_time_filename.dart';
// import '../../main.dart';
// class RouteUpload extends StatefulWidget {
//
//
//   @override
//   _RouteUploadState createState() => _RouteUploadState();
// }
//
// class _RouteUploadState extends State<RouteUpload> {
//   TextEditingController titleTextEditingController = TextEditingController();
//
//   TextEditingController descriptionTextEditingController = TextEditingController();
//
//   TextEditingController durationTextEditingController = TextEditingController();
//
//   TextEditingController expensesTextEditingController = TextEditingController();
//
//   TextEditingController modeTextEditingController = TextEditingController();
//
//   TextEditingController travelMonthTextEditingController = TextEditingController();
//
//   TextEditingController fromTextEditingController = TextEditingController();
//
//   TextEditingController toTextEditingController = TextEditingController();
//
//   TextEditingController linkTextEditingController = TextEditingController();
//   TextEditingController mpref = TextEditingController();
//   TextEditingController dpref = TextEditingController();
//   TextEditingController fpref = TextEditingController();
//   TextEditingController hpref = TextEditingController();
//   TextEditingController ppref = TextEditingController();
//   TextEditingController rpref = TextEditingController();
//
//   //TextEditingController controller = TextEditingController();
//
//   String paste = '';
//   var _imageFile;
//   String imageUrl;
//   final _imagePicker = ImagePicker();
//   PickedFile image;
//   //Check Permissions
//
//   File file;
//   selectImage()async{
//     await Permission.photos.request();
//
//     var permissionStatus = await Permission.photos.status;
//     if (permissionStatus.isGranted) {
//       //Select Image
//       image = await _imagePicker.getImage(source: ImageSource.gallery);
//        file = File(image.path);
//     }
//     else {
//       print('No Image Path Received');
//     }
//
//   }
//   uploadImageAndRoute() async {
//     final _firebaseStorage = FirebaseStorage.instance;
//
//       var firebaseUser =  FirebaseAuth.instance.currentUser;
//
//       final firestoreInstance = FirebaseFirestore.instance;
//       CollectionReference trip = FirebaseFirestore.instance.collection('trip');
//     if (image != null){
//       //Upload to Firebase
//           String tt=NowFilename.genNowFilename();
//       var snapshot = await _firebaseStorage.ref()
//           .child('images/$tt')
//           .putFile(file);
//       var downloadUrl = await snapshot.ref.getDownloadURL();
//       setState(() {
//         imageUrl = downloadUrl;
//       });
//     }
//     firestoreInstance.collection("trip").doc().set(
//           {
//             "info" : {
//               "desc" :descriptionTextEditingController.text,
//               "photo" :imageUrl,
//               "title":titleTextEditingController.text,
//             },
//             "likes":2,
//             "misc":{
//               "duration_days":durationTextEditingController.text,
//               "expenses":expensesTextEditingController.text,
//               "mode":modeTextEditingController.text,
//               "travel_month":travelMonthTextEditingController.text,
//             },
//             "route": {
//               "prefs": {
//                 "mountain": mpref.text,
//                 "forest": fpref.text,
//                 "pilgrimage": ppref.text,
//                 "highway": hpref.text,
//                 "riverside": rpref.text,
//                 "desert": dpref.text
//               },
//               "route_info":{
//                 "from":fromTextEditingController.text,
//                 "link":linkTextEditingController.text,
//                 "to":toTextEditingController.text,
//               }
//             }
//           }).then((_){
//             fromTextEditingController.clear();
//             titleTextEditingController.clear();
//
//              descriptionTextEditingController.clear();
//
//              durationTextEditingController.clear();
//
//              expensesTextEditingController.clear();
//
//              modeTextEditingController.clear();
//
//              travelMonthTextEditingController.clear();
//
//             toTextEditingController.clear();
//
//              linkTextEditingController.clear();
//             Navigator.pushAndRemoveUntil(  context,
//               MaterialPageRoute(builder: (BuildContext context) => NavigatorPage()),
//               ModalRoute.withName('/'),);
//         print("success!");
//       });
//
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               SizedBox(height: 35.0,),
//
//               SizedBox(height: 1.0,),
//               Text(
//                 "Upload Route",
//                 style: TextStyle(fontSize: 24.0, fontFamily: "Brand-Bold"),
//                 textAlign: TextAlign.center,
//               ),
//
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//
//                     SizedBox(height: 1.0,),
//                     TextField(
//                       controller: titleTextEditingController,
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         labelText: "Title",
//                         labelStyle: TextStyle(
//                           fontSize: 14.0,
//                         ),
//                         hintStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 10.0,
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 14.0),
//                     ),
//
//                     SizedBox(height: 1.0,),
//                 TextFormField(
//                   controller: descriptionTextEditingController,
//                  decoration: InputDecoration(
//                    labelText: "Description",
//                    hintText: 'Amazing place ! Must Visit !'
//                  ) ,
//                   textInputAction: TextInputAction.newline,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: 5,),
//
//                     SizedBox(height: 1.0,),
//                     TextField(
//                       controller:durationTextEditingController ,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: "Number of days",
//                         labelStyle: TextStyle(
//                           fontSize: 14.0,
//                         ),
//                         hintStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 10.0,
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 14.0),
//                     ),
//
//                     SizedBox(height: 10.0,),
//                     TextField(
//                       controller: expensesTextEditingController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: "Expenses",
//                         labelStyle: TextStyle(
//                           fontSize: 14.0,
//                         ),
//                         hintStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 10.0,
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 14.0),
//                     ),
//                     SizedBox(height: 10.0,),
//                     TextField(
//                       controller: modeTextEditingController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: "Mode of travel ",
//                         labelStyle: TextStyle(
//                           fontSize: 14.0,
//                         ),
//                         hintStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 10.0,
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 14.0),
//                     ),
//                     SizedBox(height: 10.0,),
//                     TextField(
//                       controller: travelMonthTextEditingController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: "Travel Month",
//                         labelStyle: TextStyle(
//                           fontSize: 14.0,
//                         ),
//                         hintStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 10.0,
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 14.0),
//                     ),
//                     SizedBox(height: 10.0,),
//                     TextField(
//                       controller: toTextEditingController,
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         labelText: "To ",
//                         labelStyle: TextStyle(
//                           fontSize: 14.0,
//                         ),
//                         hintStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 10.0,
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 14.0),
//                     ),
//                     SizedBox(height: 10.0,),
//                     TextField(
//                       controller: fromTextEditingController,
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         labelText: "From",
//                         labelStyle: TextStyle(
//                           fontSize: 14.0,
//                         ),
//                         hintStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 10.0,
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 14.0),
//                     ),
//                     SizedBox(height: 10.0,),
//                     TextField(
//                       controller: linkTextEditingController,
//                       enableInteractiveSelection: true,
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//
//                         labelText: "Link",
//                         labelStyle: TextStyle(
//                           fontSize: 14.0,
//                         ),
//                         hintStyle: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 10.0,
//                         ),
//                       ),
//                       style: TextStyle(fontSize: 14.0),
//                     ),
//                     buildPaste(),
//                     ElevatedButton(
//                       // color: Colors.blueAccent,
//                       // textColor: Colors.white,
//                       child: Container(
//                         height: 50.0,
//                         child: Center(
//                           child: Text(
//                             "Select Image",
//                             style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
//                           ),
//                         ),
//                       ),
//                       // shape: new RoundedRectangleBorder(
//                       //   borderRadius: new BorderRadius.circular(24.0),
//                       // ),
//                       onPressed: (){
//                         selectImage();
//
//                       },
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Route Topography'),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(right: 40.0),
//                             child: Center(child: Text('Riverside')),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: TextFormField(
//                               textAlign: TextAlign.center,
//                               controller: rpref,
//                               keyboardType: TextInputType.numberWithOptions(
//                                   decimal: false, signed: false),
//                               inputFormatters: <TextInputFormatter>[
//                                 WhitelistingTextInputFormatter.digitsOnly
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_up),
//                                 onPressed: () {
//                                   if(rpref.text==""){
//                                     rpref.text="0";
//                                   }
//
//                                   int currentValue = int.parse(rpref.text);
//                                   setState(() {
//                                     currentValue++;
//                                     rpref.text =
//                                         (currentValue).toString(); // incrementing value
//                                   });
//                                 },
//                               ),
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_down),
//                                 onPressed: () {
//                                   if(int.parse(rpref.text)>0){
//                                     int currentValue = int.parse(rpref.text);
//                                     setState(() {
//                                       print("Setting state");
//                                       currentValue--;
//                                       rpref.text =
//                                           (currentValue).toString(); // decrementing value
//                                     });
//                                   }
//                                   else{
//                                     print('0 already');
//                                   }
//
//                                 },
//                               ),
//                             ],
//                           ),
//
//
//                         ],
//                       ),
//
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(right: 40.0),
//                             child: Center(child: Text('Pilgrimage')),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: TextFormField(
//                               controller: ppref,
//                               textAlign: TextAlign.center,
//                               keyboardType: TextInputType.numberWithOptions(
//                                   decimal: false, signed: false),
//                               inputFormatters: <TextInputFormatter>[
//                                 WhitelistingTextInputFormatter.digitsOnly
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_up),
//                                 onPressed: () {
//                                   if(ppref.text==""){
//                                    ppref.text="0";
//                                   }
//
//                                   int currentValue = int.parse(ppref.text);
//                                   setState(() {
//                                     currentValue++;
//                                     ppref.text =
//                                         (currentValue).toString(); // incrementing value
//                                   });
//                                 },
//                               ),
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_down),
//                                 onPressed: () {
//                                   if(int.parse(ppref.text)>0){
//                                     int currentValue = int.parse(ppref.text);
//                                     setState(() {
//                                       print("Setting state");
//                                       currentValue--;
//                                       ppref.text =
//                                           (currentValue).toString(); // decrementing value
//                                     });
//                                   }
//                                   else{
//                                     print('0 already');
//                                   }
//
//                                 },
//                               ),
//                             ],
//                           ),
//
//
//                         ],
//                       ),
//
//                     ),//Pilgrimage
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(right: 40.0),
//                             child: Center(child: Text('Highway')),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: TextFormField(
//                               controller: hpref,
//                               textAlign: TextAlign.center,
//                               keyboardType: TextInputType.numberWithOptions(
//                                   decimal: false, signed: false),
//                               inputFormatters: <TextInputFormatter>[
//                                 WhitelistingTextInputFormatter.digitsOnly
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_up),
//                                 onPressed: () {
//                                   if(hpref.text==""){
//                                     hpref.text="0";
//                                   }
//
//                                   int currentValue = int.parse(hpref.text);
//                                   setState(() {
//                                     currentValue++;
//                                     hpref.text =
//                                         (currentValue).toString(); // incrementing value
//                                   });
//                                 },
//                               ),
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_down),
//                                 onPressed: () {
//                                   if(int.parse(hpref.text)>0){
//                                     int currentValue = int.parse(hpref.text);
//                                     setState(() {
//                                       print("Setting state");
//                                       currentValue--;
//                                       hpref.text =
//                                           (currentValue).toString(); // decrementing value
//                                     });
//                                   }
//                                   else{
//                                     print('0 already');
//                                   }
//
//                                 },
//                               ),
//                             ],
//                           ),
//
//
//                         ],
//                       ),
//
//                     ),//highway
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(right: 40.0),
//                             child: Center(child: Text('Forest')),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: TextFormField(
//                               controller: fpref,
//                               textAlign: TextAlign.center,
//                               keyboardType: TextInputType.numberWithOptions(
//                                   decimal: false, signed: false),
//                               inputFormatters: <TextInputFormatter>[
//                                 WhitelistingTextInputFormatter.digitsOnly
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_up),
//                                 onPressed: () {
//                                   if(fpref.text==""){
//                                     fpref.text="0";
//                                   }
//
//                                   int currentValue = int.parse(fpref.text);
//                                   setState(() {
//                                     currentValue++;
//                                     fpref.text =
//                                         (currentValue).toString(); // incrementing value
//                                   });
//                                 },
//                               ),
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_down),
//                                 onPressed: () {
//                                   if(int.parse(fpref.text)>0){
//                                     int currentValue = int.parse(fpref.text);
//                                     setState(() {
//                                       print("Setting state");
//                                       currentValue--;
//                                       fpref.text =
//                                           (currentValue).toString(); // decrementing value
//                                     });
//                                   }
//                                   else{
//                                     print('0 already');
//                                   }
//
//                                 },
//                               ),
//                             ],
//                           ),
//
//                         ],
//                       ),
//
//                     ),//Forest
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(right: 40.0),
//                             child: Center(child: Text('Desert')),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: TextFormField(
//                               textAlign: TextAlign.center,
//                               controller: dpref,
//                               keyboardType: TextInputType.numberWithOptions(
//                                   decimal: false, signed: false),
//                               inputFormatters: <TextInputFormatter>[
//                                 WhitelistingTextInputFormatter.digitsOnly
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_up),
//                                 onPressed: () {
//                                   if(dpref.text==""){
//                                     dpref.text="0";
//                                   }
//
//                                   int currentValue = int.parse(dpref.text);
//                                   setState(() {
//                                     currentValue++;
//                                     dpref.text =
//                                         (currentValue).toString(); // incrementing value
//                                   });
//                                 },
//                               ),
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_down),
//                                 onPressed: () {
//                                   if(int.parse(dpref.text)>0){
//                                     int currentValue = int.parse(dpref.text);
//                                     setState(() {
//                                       print("Setting state");
//                                       currentValue--;
//                                       dpref.text =
//                                           (currentValue).toString(); // decrementing value
//                                     });
//                                   }
//                                   else{
//                                     print('0 already');
//                                   }
//
//                                 },
//                               ),
//                             ],
//                           ),
//
//                         ],
//                       ),
//
//                     ),//Desert preference
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(right: 40.0),
//                             child: Center(child: Text('Mountain')),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: TextFormField(
//                               textAlign: TextAlign.center,
//                               controller: mpref,
//                               keyboardType: TextInputType.numberWithOptions(
//                                   decimal: false, signed: false),
//                               inputFormatters: <TextInputFormatter>[
//                                 WhitelistingTextInputFormatter.digitsOnly
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_up),
//                                 onPressed: () {
//                                   if(mpref.text==""){
//                                     mpref.text="0";
//                                   }
//
//                                   int currentValue = int.parse(mpref.text);
//                                   setState(() {
//                                     currentValue++;
//                                     mpref.text =
//                                         (currentValue).toString(); // incrementing value
//                                   });
//                                 },
//                               ),
//                               MaterialButton(
//                                 minWidth: 5.0,
//                                 child: Icon(Icons.arrow_drop_down),
//                                 onPressed: () {
//                                   if(int.parse(mpref.text)>0){
//                                     int currentValue = int.parse(mpref.text);
//                                     setState(() {
//                                       print("Setting state");
//                                       currentValue--;
//                                       mpref.text =
//                                           (currentValue).toString(); // decrementing value
//                                     });
//                                   }
//                                   else{
//                                     print('0 already');
//                                   }
//
//                                 },
//                               ),
//                             ],
//                           ),
//
//
//                         ],
//                       ),
//
//                     ),//Mountain Preference
//                    // NumberInputWithIncrementDecrement(),
//                     // Padding(
//                     //   padding: const EdgeInsets.all(20.0),
//                     //   child: Center(
//                     //     child: Container(
//                     //       width: 60.0,
//                     //       foregroundDecoration: BoxDecoration(
//                     //         borderRadius: BorderRadius.circular(5.0),
//                     //         border: Border.all(
//                     //           color: Colors.blueGrey,
//                     //           width: 2.0,
//                     //         ),
//                     //       ),
//                     //       child: Row(
//                     //         children: <Widget>[
//                     //           Expanded(
//                     //             flex: 1,
//                     //             child: TextFormField(
//                     //               textAlign: TextAlign.center,
//                     //               decoration: InputDecoration(
//                     //                 contentPadding: EdgeInsets.all(8.0),
//                     //                 border: OutlineInputBorder(
//                     //                   borderRadius: BorderRadius.circular(5.0),
//                     //                 ),
//                     //               ),
//                     //               controller: pref,
//                     //               keyboardType: TextInputType.numberWithOptions(
//                     //                 decimal: false,
//                     //                 signed: true,
//                     //               ),
//                     //               inputFormatters: <TextInputFormatter>[
//                     //                 WhitelistingTextInputFormatter.digitsOnly
//                     //               ],
//                     //             ),
//                     //           ),
//                     //           Container(
//                     //             height: 38.0,
//                     //             child: Column(
//                     //               crossAxisAlignment: CrossAxisAlignment.center,
//                     //               mainAxisAlignment: MainAxisAlignment.center,
//                     //               children: <Widget>[
//                     //                 Container(
//                     //                   decoration: BoxDecoration(
//                     //                     border: Border(
//                     //                       bottom: BorderSide(
//                     //                         width: 0.5,
//                     //                       ),
//                     //                     ),
//                     //                   ),
//                     //                   child: InkWell(
//                     //                     child: Icon(
//                     //                       Icons.arrow_drop_up,
//                     //                       size: 18.0,
//                     //                     ),
//                     //                     onTap: () {
//                     //                       int currentValue = int.parse(pref.text);
//                     //                       setState(() {
//                     //                         currentValue++;
//                     //                         pref.text = (currentValue)
//                     //                             .toString(); // incrementing value
//                     //                       });
//                     //                     },
//                     //                   ),
//                     //                 ),
//                     //                 InkWell(
//                     //                   child: Icon(
//                     //                     Icons.arrow_drop_down,
//                     //                     size: 18.0,
//                     //                   ),
//                     //                   onTap: () {
//                     //                     int currentValue = int.parse(pref.text);
//                     //                     setState(() {
//                     //                       print("Setting state");
//                     //                       currentValue--;
//                     //                       pref.text =
//                     //                           (currentValue > 0 ? currentValue : 0)
//                     //                               .toString(); // decrementing value
//                     //                     });
//                     //                   },
//                     //                 ),
//                     //               ],
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//
//                     SizedBox(height: 50.0,),
//                     ElevatedButton(
//                       // color: Colors.blueAccent,
//                       // textColor: Colors.white,
//                       child: Container(
//                         height: 50.0,
//                         child: Center(
//                           child: Text(
//                             "Route Upload",
//                             style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
//                           ),
//                         ),
//                       ),
//                       // shape: new RoundedRectangleBorder(
//                       //   borderRadius: new BorderRadius.circular(24.0),
//                       // ),
//                       onPressed: (){
//
//                         uploadImageAndRoute();
//                       },
//                     )
//                   ],
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Widget buildCopy() => Builder(
//   //   builder: (context) => Row(
//   //     children: [
//   //       Expanded(child: TextField(controller: controller)),
//   //       IconButton(
//   //         icon: Icon(Icons.content_copy),
//   //         onPressed: () async {
//   //           await FlutterClipboard.copy(controller.text);
//   //
//   //           Scaffold.of(context).showSnackBar(
//   //             SnackBar(content: Text('✓   Copied to Clipboard')),
//   //           );
//   //         },
//   //       ),
//   //     ],
//   //   ),
//   // );
//
//   Widget buildPaste() => Row(
//     children: [
//       //Expanded(child: Text(paste)),
//       IconButton(
//         icon: Icon(Icons.paste),
//         onPressed: () async {
//           final value = await FlutterClipboard.paste();
//
//           setState(() {
//             linkTextEditingController.text = value;
//           });
//         },
//       )
//     ],
//   );
// }
//
// displayToastMessage(String message, BuildContext context){
//   Fluttertoast.showToast(msg: message);
// }
// class NumberInputWithIncrementDecrement extends StatefulWidget {
//   @override
//   _NumberInputWithIncrementDecrementState createState() =>
//       _NumberInputWithIncrementDecrementState();
// }
//
// class _NumberInputWithIncrementDecrementState
//     extends State<NumberInputWithIncrementDecrement> {
//   TextEditingController _controller = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _controller.text = "0"; // Setting the initial value for the field.
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Number Field increment decrement'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               flex: 1,
//               child: TextFormField(
//                 controller: _controller,
//                 keyboardType: TextInputType.numberWithOptions(
//                     decimal: false, signed: false),
//                 inputFormatters: <TextInputFormatter>[
//                   WhitelistingTextInputFormatter.digitsOnly
//                 ],
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 MaterialButton(
//                   minWidth: 5.0,
//                   child: Icon(Icons.arrow_drop_up),
//                   onPressed: () {
//                     int currentValue = int.parse(_controller.text);
//                     setState(() {
//                       currentValue++;
//                       _controller.text =
//                           (currentValue).toString(); // incrementing value
//                     });
//                   },
//                 ),
//                 MaterialButton(
//                   minWidth: 5.0,
//                   child: Icon(Icons.arrow_drop_down),
//                   onPressed: () {
//                     int currentValue = int.parse(_controller.text);
//                     setState(() {
//                       print("Setting state");
//                       currentValue--;
//                       _controller.text =
//                           (currentValue).toString(); // decrementing value
//                     });
//                   },
//                 ),
//               ],
//             ),
//             Spacer(
//               flex: 2,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }