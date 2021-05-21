import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
final List<String> quoteList =[
"The journey of a thousand miles begins with a single step.",
"Adventures are the best way to learn.",
"Leave nothing but footprints, take nothing but photos, kill nothing but time.",
"The biggest adventure you can take is to live the life of your dreams",
"Remember that happiness is a way of travel, not a destination."
];
final List<String> imgList = [
  'https://images.unsplash.com/photo-1575406129378-c4e185f200ae?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
  'https://images.unsplash.com/photo-1517400508447-f8dd518b86db?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80'
  'https://images.unsplash.com/photo-1504851149312-7a075b496cc7?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=349&q=80',
  'https://images.unsplash.com/photo-1460627390041-532a28402358?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
  'https://images.unsplash.com/photo-1614858790755-c8b224f3f156?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=355&q=80',
];
class ImageSliderDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image slider demo')),
      body: Container(
          child: CarouselSlider(
            options: CarouselOptions(),
            items: imgList.map((item) => Container(
              child: Center(
                  child: Image.network(item, fit: BoxFit.cover, width: 1000)
              ),
            )).toList(),
          )
      ),
    );
  }
}
final List<Widget> imageSliders = imgList.map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.network(item, fit: BoxFit.cover, width: 1000.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'No. ${imgList.indexOf(item)} image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )
    ),
  ),
)).toList();

class HomePageRI extends StatefulWidget {
  @override
  _HomePageRIState createState() => _HomePageRIState();
}

class _HomePageRIState extends State<HomePageRI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:    Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            options: CarouselOptions(
              height: height,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              // autoPlay: false,
            ),
            items: imgList.map((item) => Container(
              child: Stack(
                children: [
                  Center(
                      child: Image.network(item, fit: BoxFit.cover, height: height,)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:10.0,right: 10.0,top:400),
                    child: Text(
                      quoteList[ imgList.indexOf(item) ],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),
            )).toList(),
          );
        },
      ),
    );
  }
}
