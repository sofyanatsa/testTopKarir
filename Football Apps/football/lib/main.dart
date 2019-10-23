import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football/blocs/team_bloc_provider.dart';
import 'package:football/listLeague.dart';
import 'package:football/listTeamByCountry.dart';
import 'package:football/searchTeam.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TeamBlocProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Football Apps'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    var onClickNo1 = () {
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new ListTeamCountry(),
      ));
    };

    var onClickNo2 = () {
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new ListLeague(),
      ));
    };

    var onClickNo3 = () {
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new TeamSearch(),
      ));
    };

    var categoryIcon = () {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 20.0),
        alignment: AlignmentDirectional.centerStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 20.0,
              ),
              child: Text(
                "Menu",
                style: TextStyle(
                    fontSize: 13.5,
                    fontFamily: "Sans",
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 15,
            ),
            CategoryIconValue(
                title1: "1. Team\nby Country",
                tap1: onClickNo1,
                icon1: Icon(
                  FontAwesomeIcons.flag,
                  size: 32,
                ),
                title2: '2. Event',
                tap2: onClickNo2,
                icon2: Icon(
                  FontAwesomeIcons.calendar,
                  size: 32,
                ),
                title3: '3. Search Team',
                tap3: onClickNo3,
                icon3: Icon(
                  FontAwesomeIcons.search,
                  size: 32,
                ),
                title4: '',
                tap4: () {},
                icon4: SizedBox(
                  width: 32,
                )),
            Padding(padding: EdgeInsets.only(bottom: 30.0))
          ],
        ),
      );
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          categoryIcon(),
          Center(
            child: Text(
              "Developed by: sofyansaid24@gmail.com\n",
              style: TextStyle(color: Colors.black12),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CategoryIconValue extends StatelessWidget {
  Widget icon1, icon2, icon3, icon4;
  String title1, title2, title3, title4;
  GestureTapCallback tap1, tap2, tap3, tap4;

  CategoryIconValue(
      {this.icon1,
      this.tap1,
      this.icon2,
      this.tap2,
      this.icon3,
      this.tap3,
      this.icon4,
      this.tap4,
      this.title1,
      this.title2,
      this.title3,
      this.title4});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: tap1,
          child: Column(
            children: <Widget>[
              icon1,
              Padding(padding: EdgeInsets.only(top: 7.0)),
              Text(
                title1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: tap2,
          child: Column(
            children: <Widget>[
              icon2,
              Padding(padding: EdgeInsets.only(top: 7.0)),
              Text(
                title2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: tap3,
          child: Column(
            children: <Widget>[
              icon3,
              Padding(padding: EdgeInsets.only(top: 7.0)),
              Text(
                title3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: tap4,
          child: Column(
            children: <Widget>[
              icon4,
              Padding(padding: EdgeInsets.only(top: 7.0)),
              Text(
                title4,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
