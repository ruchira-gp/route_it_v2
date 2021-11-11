import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:route_it_v2/ri/utils/AllRequiredFunctions.dart';

class DisplaySearchedRoutes extends StatefulWidget {
  @override
  _DisplaySearchedRoutesState createState() => _DisplaySearchedRoutesState();
}

class _DisplaySearchedRoutesState extends State<DisplaySearchedRoutes> {
  List<TripDetails> B = [];
  Widget appBarTitle = Text(
    "Search Routes",
    style: TextStyle(color: Colors.white),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();

  bool _IsSearching;
  bool _filter;
  String _searchText = "";

  _DisplaySearchedRoutesState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  _sort(){
    List<TripDetails> VD = [];
    allRoutesAccordingToPreference.forEach((element) {
      VD.add(TripDetails(desc: element.desc,title: element.title,tripImage: element.tripImage,toCity: element.toCity,fromCity: element.fromCity,expenses: element.expenses,mode:element.mode,link:element.link,likes: element.likes,docid: element.docid,));
    });
    VD.sort((a,b)=>int.parse(a.expenses).compareTo(int.parse(b.expenses)));
    return VD;
  }
  _buildList() {
    List<TripDetails> VD = [];
    allRoutesAccordingToPreference.forEach((element) {
      VD.add(TripDetails(desc: element.desc,title: element.title,tripImage: element.tripImage,toCity: element.toCity,fromCity: element.fromCity,expenses: element.expenses,mode:element.mode,link:element.link,likes: element.likes,docid: element.docid,));
    });

    return VD;
  }

  _buildSearchList() {
    List<TripDetails> VD = [];
    allRoutesAccordingToPreference.forEach((element) {
      VD.add(TripDetails(desc: element.desc,title: element.title,tripImage: element.tripImage,toCity: element.toCity,fromCity: element.fromCity,expenses: element.expenses,mode:element.mode,link:element.link,likes: element.likes,docid: element.docid));
    });
    if (_searchText.isEmpty) {
      return VD;
    } else {
      List<TripDetails> _searchList = [];
      allRoutesAccordingToPreference.forEach((element) {
        if (element.toCity
            .toString()
            .toLowerCase()
            .contains(_searchText.toLowerCase()) ||element.fromCity
            .toString()
            .toLowerCase()
            .contains(_searchText.toLowerCase()))
          _searchList.add(TripDetails(desc: element.desc,title: element.title,tripImage: element.tripImage,toCity: element.toCity,fromCity: element.fromCity,expenses: element.expenses,mode:element.mode,link:element.link,likes: element.likes,docid: element.docid));
      });
      setState(() {
        B = _searchList;
      });
      return _searchList;
    }
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    _filter=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      key: key,
      appBar: buildBar(context),
      body: ListView(
        // gridDelegate:
        // SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: _IsSearching ?  _buildSearchList() : (_filter?_sort():_buildList()),
      ),

    );
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
        // ignore: deprecated_member_use
        leading: FlatButton(child: ( Icon(Icons.filter_list_alt,color: Colors.white,)),
        onPressed: (){
          setState(() {
            _filter=true;
          });

    },),
        centerTitle: true,
        title: appBarTitle,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = TextField(
                    controller: _searchQuery,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.white)),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),

        ]);
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = Text(
        "Search Routes",
        style: TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }
}
