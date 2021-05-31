import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'historypage.dart';
import 'upcomingpage.dart';

class HomePage extends StatefulWidget {
  final String imgDetail;
  final String title;

  const HomePage({Key key, this.imgDetail, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = new PageController();

  List<Widget> _list = <Widget>[
    new Center(child: UpcomingPage()),
    new Center(child: HistoryPage()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Space X",
          style: GoogleFonts.orbitron().copyWith(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned.fill(
                bottom: 500,
                child: Container(
                  // height: size.height * 0.55,
                  child: Carousel(
                    images: [
                      NetworkImage(
                          'https://static01.nyt.com/images/2020/12/11/science/08SPACEX/08SPACEX-mediumSquareAt3X.jpg'),
                      NetworkImage(
                          'https://i.pinimg.com/originals/b3/db/d8/b3dbd80e96464b21a40bca717c5d63be.jpg'),
                      NetworkImage(
                          'https://www.americaspace.com/wp-content/uploads/2015/04/Spx-F9-Landing-Burn.jpg'),
                    ],
                    dotSize: 10.0,
                    dotSpacing: 20.0,
                    dotIncreaseSize: 10,
                    dotVerticalPadding: 20,
                    indicatorBgPadding: 1.0,
                    dotBgColor: Colors.transparent,
                    borderRadius: true,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.60),
                height: size.height * .90,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: PageView.builder(
                        controller: controller,
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          return _list[index];
                        },
                      ),
                    ),
                  ]),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
