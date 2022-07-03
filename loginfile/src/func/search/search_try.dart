import 'package:flutter/material.dart';
import 'package:flutter_login_signup/src/Widget/bezierContainer.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView.builder(
          itemCount: listData.length, itemBuilder: this._getListData),
    );
  }

  Widget _getListData(context, index) {
    return ListTile(
        title: Text(listData[index]["title"]),
        subtitle: Text(listData[index]["author"]));
  }
}

/*class _SearchPageState extends State<SearchPage> {
  Widget _getListData(context, index) {
    return ListTile(
        title: Text(listData[index]["title"]),
        subtitle: Text(listData[index]["author"]));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: listData.length, itemBuilder: this._getListData);
  }
}*/

List listData = [
  {
    "title": 'Candy Shop',
    "author": 'Mohamed Chahin, ',
  },
  {
    "title": 'Childhood in a picture',
    "author": 'Google',
  },
  {
    "title": 'Alibaba Shop',
    "author": 'Alibaba',
  },
  {
    "title": 'Candy Shop',
    "author": 'Mohamed Chahin',
  },
  {
    "title": 'Tornado',
    "author": 'Mohamed Chahin',
  },
  {
    "title": 'Undo',
    "author": 'Mohamed Chahin',
  },
  {
    "title": 'Undo',
    "author": 'Mohamed Chahin',
  },
  {
    "title": 'Undo',
    "author": 'Mohamed Chahin',
  },
  {
    "title": 'Undo',
    "author": 'Mohamed Chahin',
  },
  {
    "title": 'Undo',
    "author": 'Mohamed Chahin',
  },  {
    "title": 'Undo',
    "author": 'Mohamed Chahin',
  },

  {
    "title": 'white-dragon',
    "author": 'Mohamed Chahin',
  }
];