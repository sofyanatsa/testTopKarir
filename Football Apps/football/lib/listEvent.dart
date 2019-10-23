import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'blocs/team_bloc_provider.dart';
import 'models/team_model.dart';
import 'utils/env.dart' as env;

/// Custom Text Header
var _txtCustomHead = TextStyle(
  color: Colors.black54,
  fontSize: 17.0,
  fontWeight: FontWeight.w600,
  fontFamily: "Gotik",
);

/// Custom Text Detail
var _txtCustomSub = TextStyle(
  color: Colors.black38,
  fontSize: 13.5,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

class ListEvent extends StatefulWidget {
  final League league;
  ListEvent(this.league, {Key key}) : super(key: key);
  @override
  ListEventState createState() {
    return new ListEventState();
  }
}

class ListEventState extends State<ListEvent>
    with SingleTickerProviderStateMixin {
  TabController controller;
  TeamBloc bloc;
  int rowId;
  String userId;
  int tabIndex = 0;
  bool retryDisp = false;
  double screenSize;

  final TextEditingController _searchcontroller = new TextEditingController();
  List<Event> _list;
  bool _isSearching;
  bool _notfound = false;

  @override
  didChangeDependencies() async {
    bloc = TeamBlocProvider.of(context);
    // onTabChange(tabIndex);
    super.didChangeDependencies();
  }

  var countryItems = <String>[
    'Past',
    'Next',
  ];

  @override
  void initState() {
    controller = TabController(vsync: this, length: countryItems.length);
    controller.addListener(() {
      setState(() {
        tabIndex = controller.index;
      });
      onTabChange(tabIndex);
    });
    super.initState();
  }

  onTabChange(int index) async {
    bloc.getEventListByLeagueId(widget.league.idLeague, index == 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size.width;
    bloc.getEventListByLeagueId(widget.league.idLeague, tabIndex == 0);

    var retryDisplay = () {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40),
            ),
            Text(
              'Request time out',
              style: _txtCustomHead.copyWith(color: Colors.black26),
            ),
            Divider(
              height: 1,
            ),
            Text(
              'Tap the button below to reload',
              style: _txtCustomSub,
            ),
            // Button Reload
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 25),
              child: InkWell(
                onTap: () {
                  onTabChange(tabIndex);
                  setState(() {
                    retryDisp = false;
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(40.0))),
                  child: Center(
                      child: Icon(
                    FontAwesomeIcons.syncAlt,
                    color: Colors.white,
                  )),
                ),
              ),
            ),
          ],
        ),
      );
    };

    var emptyListDisplay = () {
      return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Icon(FontAwesomeIcons.box, size: 48, color: Colors.black26),
            SizedBox(
              height: 15,
            ),
            Text(
              'List is empty',
              style: _txtCustomHead.copyWith(color: Colors.black26),
            ),
            Divider(
              height: 1,
            ),
            Text(
              'This country has no team',
              style: _txtCustomSub,
            ),
          ],
        ),
      );
    };

    var listunit = (Event _item) {
      return Column(
        children: <Widget>[
          ListTile(
            // isThreeLine: true,
            title: Text(
              '${_item.event}',
              style: _txtCustomHead.copyWith(color: Colors.black),
            ),
            leading: Icon(FontAwesomeIcons.calendarCheck, size: 30),
            subtitle: Wrap(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '${_item.dateEvent}',
                      style: _txtCustomSub,
                    ),
                    SizedBox(width: 4),
                    Text(' - ${_item.time}',
                        style: _txtCustomSub,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ],
                ),
                // Text('${_item.league}',
                //     style: _txtCustomSub,
                //     overflow: TextOverflow.ellipsis,
                //     maxLines: 1),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      );
    };

    var callPkgPage = () {
      return RefreshIndicator(
        onRefresh: () {
          bloc.events;
          onTabChange(tabIndex);
          Completer<Null> completer = new Completer<Null>();
          Future.delayed(Duration(seconds: 3)).then((_) {
            completer.complete();
          });
          return completer.future;
        },
        child: StreamBuilder(
            stream: bloc.events,
            builder: (context, AsyncSnapshot<EventModel> snapshot) {
              if (snapshot.hasData) {
                retryDisp = false;
                final int _dataCount = snapshot.data.results.length;
                if (_dataCount >= 0) {
                  _list = List();
                  _list.clear();
                  for (Event _item in snapshot.data.results) {
                    _list.add(_item);
                  }
                  if (_dataCount == 0) {
                    return emptyListDisplay();
                  }
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return listunit(_list[index]);
                  },
                );
              }

              if (retryDisp) {
                return retryDisplay();
              }

              Future.delayed(const Duration(seconds: env.REQUEST_TIME), () {
                if (!snapshot.hasData && !retryDisp) {
                  print('Request Time Out');
                  setState(() {
                    retryDisp = true;
                  });
                }
              });

              return Center(child: CircularProgressIndicator());
            }),
      );
    };

    return Scaffold(
      appBar: buildAppBar(context),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          for (var item in countryItems) callPkgPage(),
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        widget.league.league,
        style: _txtCustomHead.copyWith(color: Colors.white),
      ),
      elevation: 0.0,
      bottom: TabBar(
        // isScrollable: true,
        controller: controller,
        indicatorColor: Color(0xFF87BDB1),
        tabs: <Widget>[
          for (var item in countryItems)
            Tab(
              text: item,
            ),
        ],
      ),
    );
  }
}
