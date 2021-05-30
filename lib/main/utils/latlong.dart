// import 'dart:convert';
// import 'package:sticky_headers/sticky_headers.dart';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:puppeteer/puppeteer.dart';
// import 'package:url_launcher/url_launcher.dart';
// // //------------------------allMatches Example---------------------------------
//
//
//
//
// String getLatLongString="";
// List midPoint=[];
// double toLat=0.0;
// double toLong=0.0;
// double fromLat=0.0;
// double fromLong=0.0;
//
// List eateries = ['Eateries'];
// List fuel =['Gas Station'];
// double i = 1;
// double i1 = 1;
// int _value = 1;
// int _value1 = 1;
//
// bool _eateriesIsSelected=false;
// bool _gasStationIsSelected=false;
// var pblat;
// var pblng;
//
// getExpandedUrl(encryptedUrl)async{
//   var response = await http.get(
//     Uri.parse("http://expandurl.com/api/v1/?url=$encryptedUrl"),
//   );
//   String jsonResponse = response.body.toString();
//   return(jsonResponse);
// }
//
//
// getLatLong(strr){
//   String str1=strr.toString();
//   RegExp reg1 = new RegExp(r"![0-9][a-zA-Z]([0-9\.]{5,})");
// String y="";
// List<String> route=[];
// Iterable allMatches = reg1.allMatches(str1);
// int i=0;
// allMatches.forEach((match) {
// y=(str1.substring(match.start, match.end));
// route.add(y.substring(3,));
// });
// print(route);
// return route;
// }
//
// getMidP(List latlonglist){
//   fromLat=double.parse(latlonglist[0]);
//   fromLong=double.parse(latlonglist[1]);
//   toLat=double.parse(latlonglist[latlonglist.length-2]);
//   toLong=double.parse(latlonglist[latlonglist.length-1]);
//
//   var lat=(double.parse(latlonglist[0])+double.parse(latlonglist[latlonglist.length-2]))/2;
//   var long=(double.parse(latlonglist[1])+double.parse(latlonglist[latlonglist.length-1]))/2;
//   return [lat,long];
// }
// // available configuration for multiple choice
// List<int> value = [2];
//
// getMidPoint(String shortenedUri)async{
//   var x=await getExpandedUrl(shortenedUri);
//   return(getMidP(getLatLong(x)));
// }
// getPetrolBunks()async{
//   Map data={
//     'client_id':'XXXHYXS01GX50KRXM53HD12NB00CL4RTPODV34RLQTOW1VM0',
//     'client_secret':'PCDGO5DYACJ1BAHD0QVNRYKZ5FYYTQ0IQ4S3UHEYWTWWGZ2W',
//     'v':'20210525',
//     'll':'${midPoint[0]},${midPoint[1]}',
//     'radius':'30000',
//     'query':'petrol bunk'
//
//   };
//
//   var response = await http.post(
//       Uri.parse("https://api.foursquare.com/v2/venues/search"),
//       body: data
//   );
//   var jsonResponse = json.decode(response.body);
//
//
//     print(jsonResponse['response']['venues'][0]['name']);
//      print(jsonResponse['response']['venues'][0]['location']['lat']);
//      print(jsonResponse['response']['venues'][0]['location']['lng']);
//   return[jsonResponse['response']['venues'][0]['name'],jsonResponse['response']['venues'][0]['location']['lat'],jsonResponse['response']['venues'][0]['location']['lng']];
//
//
// }
// getEateries()async{
//   Map data={
//     'client_id':'XXXHYXS01GX50KRXM53HD12NB00CL4RTPODV34RLQTOW1VM0',
//     'client_secret':'PCDGO5DYACJ1BAHD0QVNRYKZ5FYYTQ0IQ4S3UHEYWTWWGZ2W',
//     'v':'20210525',
//     'll':'${midPoint[0]},${midPoint[1]}',
//     'radius':'20000',
//     'query':'restaurant'
//
//   };
//
//   var response = await http.post(
//       Uri.parse("https://api.foursquare.com/v2/venues/search"),
//       body: data
//   );
//   //print(response.body);
//
//   var jsonResponse = json.decode(response.body);
//   //print(jsonResponse);
//   jsonResponse['response']['venues'].forEach((element) {
//      print(element['name']);
//     // print(element['location']['lat']);
//     // print(element['location']['lng']);
//   });
//   return[jsonResponse['response']['venues'][0]['name'],jsonResponse['response']['venues'][0]['location']['lat'],jsonResponse['response']['venues'][0]['location']['lng']];
//
// }
//
// class Hello extends StatefulWidget {
//   @override
//   _HelloState createState() => _HelloState();
// }
//
// class _HelloState extends State<Hello> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             ElevatedButton(onPressed: ()async{
//                 print(_eateriesIsSelected);
//                 print(_gasStationIsSelected);
//                 var x=await getExpandedUrl('https://maps.app.goo.gl/cm4VyhpdtVPk6UN78');
//                 await getLatLong(x);
//             }, child: Text('Expand url')),
//             Row(
//               children: [
//                 ElevatedButton(onPressed: (){
//                   getMidPoint('https://maps.app.goo.gl/cm4VyhpdtVPk6UN78').then((latLong) {
//                     print(latLong);
//                     setState(() {
//                       midPoint=latLong;
//                     });
//                   });
//
//                 }, child: Text('LatLong')),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text('$midPoint'),
//                 )
//               ],
//             ),
//            LabeledCheckbox(
//              label: 'Eateries',
//              padding: const EdgeInsets.symmetric(horizontal: 20.0),
//              value: _eateriesIsSelected,
//              onChanged: (bool newValue) {
//                setState(() {
//                  _eateriesIsSelected = newValue;
//                });
//              },
//            ),
//             LabeledCheckbox(
//               label: 'Gas Station',
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               value: _gasStationIsSelected,
//               onChanged: (bool newValue) {
//                 setState(() {
//                   _gasStationIsSelected = newValue;
//                 });
//               },
//             ),
//             ElevatedButton(onPressed: () async {
//               String a="/\'$fromLat"+",$fromLong\'";
//               String c="/\'${midPoint[0]}"+",${midPoint[1]}\'";
//               String b="/\'$toLat"+",$toLong\'";
//               String pb="";
//               String eat="";
//               var y=await getEateries();
//               var x=await getPetrolBunks();
//               print(y);
//               print(x);
//               if(_eateriesIsSelected==true){
//                 eat="/\'${y[1].toString()}"+",${y[2].toString()}\'";
//               }
//               if(_gasStationIsSelected==true){
//                 pb="/\'${x[1].toString()}"+",${x[2].toString()}\'";
//               }
//               String xx="https://www.google.com/maps/dir$a$eat$pb$b";
//                 await launch(xx);
//
//
//
//             }, child: Text('Get Route')),
//             ElevatedButton(onPressed: ()  {
//               getEateries();
//             }, child: Text('Get Eateries')),
//             ElevatedButton(onPressed: ()  {
//               getPetrolBunks();
//             }, child: Text('Get Petrol Bunk')),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class LabeledCheckbox extends StatelessWidget {
//   const LabeledCheckbox({
//     this.label,
//      this.padding,
//     this.value,
//     this.onChanged,
//   }) ;
//
//   final String label;
//   final EdgeInsets padding;
//   final bool value;
//   final Function onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         onChanged(!value);
//       },
//       child: Padding(
//         padding: padding,
//         child: Row(
//           children: <Widget>[
//             Expanded(child: Text(label)),
//             Checkbox(
//               value: value,
//               onChanged: ( newValue) {
//                 onChanged(newValue);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
