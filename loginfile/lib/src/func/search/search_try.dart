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
      body:

                  CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      snap: false,
                      centerTitle: false,
                      backgroundColor: Colors.transparent,

                        title: Container(
                          width: double.infinity,
                          height: 40,
                          color: Colors.white,

                          child: Center(
                            child: TextField(
                              decoration: InputDecoration(

                                  hintText: 'Searching',
                                  prefixIcon: Icon(Icons.search),
                                  suffixIcon: Icon(Icons.nfc_sharp)),
                            ),
                          ),
                        ),
                    ),
                    // Other Sliver Widgets
                     SliverList(
                        delegate: SliverChildListDelegate([

                          Container(
                            height: 400,
                            child: Center(
                              child: Text(
                                'All the books list here',
                                style: GoogleFonts.portLligatSans(
                                  textStyle: Theme.of(context).textTheme.headline1,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xfff7892b),
                                ),
                              ),
                            ),
                          ),
                       ]),
                    ),
                  ],
                ),

        );


  }
}