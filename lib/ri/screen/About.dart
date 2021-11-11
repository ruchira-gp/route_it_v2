import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Version : v1.0'),
            SizedBox(height: 10,),
            Text('Guide : Dr.BS Mahanand'),
            SizedBox(height: 10,),
            Text('Creators:'),
            SizedBox(height: 10,),
            Text('Nikhil Govindaraju'),
            Text('Rohit A R'),
            Text('Ruchira G'),
            Text('Sumanth Mahishi'),

          ],
        ),
      ),
    );
  }
}
