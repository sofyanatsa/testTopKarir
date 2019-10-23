import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football/blocs/team_bloc_provider.dart';
import 'package:football/listEvent.dart';
import 'package:football/models/team_model.dart';
import 'package:scoped_model/scoped_model.dart';
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
  fontSize: 14,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

class QueryModel extends Model {
  String _query = '';
  String get query => _query;
  void changeQuery(String q) {
    _query = q;
    notifyListeners();
  }
}

class ListLeague extends StatefulWidget {
  ListLeague({Key key}) : super(key: key);

  @override
  _ListLeagueState createState() => _ListLeagueState();
}

class _ListLeagueState extends State<ListLeague> {
  Widget appBarTitle = new Text(
    "Select League",
    style: new TextStyle(color: Colors.white),
  );

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  final TextEditingController _controller = new TextEditingController();
  List<League> _list;
  bool _isSearching;
  bool _notfound = false;
  List searchresult = new List();
  TeamBloc teamBloc;
  bool retryDisp = false;

  QueryModel queryModel = QueryModel();

  final recLimit = 50;

  _ListLeagueState() {
    _controller.addListener(() {
      print("_controller.text.isEmpty ${_controller.text}");
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = true;
  }

  @override
  void didChangeDependencies() {
    teamBloc = TeamBlocProvider.of(context);
    teamBloc.getLeagueList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var listunit = (League _item) {
      return Column(
        children: <Widget>[
          ListTile(
            // isThreeLine: true,
            title: Text(
              '${_item.league}',
              style: _txtCustomHead.copyWith(color: Colors.black),
            ),
            leading: Icon(FontAwesomeIcons.calendar, size: 30),
            subtitle: Wrap(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '${_item.sport}',
                      style: _txtCustomSub,
                    ),
                    SizedBox(width: 4),
                    Text(' - ${_item.league}',
                        style: _txtCustomSub,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ],
                ),
                Text('${_item.alternate}',
                    style: _txtCustomSub,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ],
            ),
            onTap: () async {
              print('Selected Team: ${_item.league}');
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => ListEvent(_item)));
            },
          ),
          Divider(
            height: 1,
          ),
        ],
      );
    };

    var dispNotFoundSearchAndEmpty = (bool search) {
      return Padding(
        padding: const EdgeInsets.all(36),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.flipboard, size: 48, color: Colors.black26),
            Padding(
              padding: const EdgeInsets.only(top: 10),
            ),
            Text(
              search ? 'League not found' : 'List is empty',
              style: _txtCustomHead.copyWith(color: Colors.black26),
            ),
            Divider(
              height: 1,
            ),
            search
                ? Text(
                    'Your search does not match any league.',
                    style: _txtCustomSub,
                  )
                : Container(),
          ],
        )),
      );
    };

    return ScopedModel<QueryModel>(
      model: queryModel,
      child: ScopedModelDescendant<QueryModel>(
        builder: (context, child, model) {
          return Scaffold(
            appBar: buildAppBar(context),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () {
                  teamBloc.teams;
                  teamBloc.getLeagueList();
                  Completer<Null> completer = new Completer<Null>();
                  Future.delayed(Duration(seconds: 3)).then((_) {
                    completer.complete();
                  });
                  return completer.future;
                },
                child: StreamBuilder(
                  stream: teamBloc.leagues,
                  builder: (BuildContext context,
                      AsyncSnapshot<LeagueModel> snapshot) {
                    print('snapshot hasdata? ${snapshot.hasData}.');
                    if (snapshot.hasData) {
                      retryDisp = false;
                      int _dataCount = snapshot.data.results.length;
                      print("_dataCount $_dataCount");
                      if (_dataCount >= 0) {
                        _list = List();
                        _list.clear();
                        for (League _item in snapshot.data.results) {
                          _list.add(_item);
                        }
                        if (_dataCount == 0) {
                          return dispNotFoundSearchAndEmpty(false);
                        }
                      }
                      return _notfound
                          ? dispNotFoundSearchAndEmpty(true)
                          : searchresult.length != 0 ||
                                  _controller.text.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: searchresult.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    League listData = searchresult[index];
                                    return listunit(listData);
                                  },
                                )
                              : ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: _list.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return listunit(_list[index]);
                                  },
                                );
                    }

                    if (retryDisp) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                            ),
                            Text(
                              'Request time out',
                              style: _txtCustomHead.copyWith(
                                  color: Colors.black26),
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
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 25),
                              child: InkWell(
                                onTap: () {
                                  teamBloc.getLeagueList();
                                  setState(() {
                                    retryDisp = false;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0))),
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
                    }

                    Future.delayed(const Duration(seconds: env.REQUEST_TIME),
                        () {
                      if (!snapshot.hasData && !retryDisp) {
                        print('Request Time Out');
                        setState(() {
                          retryDisp = true;
                        });
                      }
                    });

                    teamBloc.getLeagueList();
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        // icon: Icon(Icons.close, color: Colors.black),
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(Icons.close, color: Colors.white);
              this.appBarTitle = new TextField(
                autofocus: true,
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search league...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: searchOperation,
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
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    // print("result: ${searchresult.length} list: ${_list.length}");
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Select League",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _notfound = false;
      searchresult = _list;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    print('searchOperation ${_isSearching != null} ${_list.length}');
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        League data = _list[i];
        // print(
        //     'SEARCH: ${searchText} >< ${data.name} = ${data.name.toLowerCase().contains(searchText.toLowerCase())} -> ${_list.length} ${searchresult.length}');
        if (data.league.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            _notfound = false;
            searchresult.add(data);
          });
        }
      }
      if (searchresult.length <= 0) {
        setState(() {
          _notfound = true;
        });
      }
    }
    print("VALUE: $searchText ${searchresult.length}");
  }
}
