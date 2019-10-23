import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

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
  fontSize: 14,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

var _txtCustom = TextStyle(
  color: Colors.black54,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

var _txtCustomOrder = TextStyle(
  color: Colors.black45,
  fontSize: 13.5,
  fontWeight: FontWeight.w600,
  fontFamily: "Gotik",
);

class TeamSearch extends StatefulWidget {
  final bool start;
  const TeamSearch({Key key, this.start}) : super(key: key);
  @override
  _TeamSearchState createState() => _TeamSearchState();
}

class _TeamSearchState extends State<TeamSearch> {
  final TextEditingController _controller = new TextEditingController();

  List<Team> _list;
  bool _isSearching = false;
  bool _loadData = true;
  bool _notfound = false;
  bool _dispOnData = false;
  bool _loadWFilter = false;
  String _searchText = "";
  String filter = '0';
  String startDate = "1900-01-01 00:00:00.000";
  String endDate = "2900-01-01 00:00:00.000";
  String status = 'X';
  String _lastSearchText = "";
  String _lastFilter = "";
  String _lastStartDate = "";
  String _lastEndDate = "";
  String _lastStatus = "";
  bool _init = true;
  List searchresult = new List();
  bool retryDisp = false;

  TeamBloc bloc;

  @override
  void didChangeDependencies() {
    print('_dispOnData: $_dispOnData ${widget.start}');
    if (_init) {
      _dispOnData = widget.start;
    }
    bloc = TeamBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // TeamBloc bloc = TeamBlocProvider.of(context);
    TextEditingController qryController = TextEditingController();
    QueryModel queryModel = QueryModel();
    LoadModel _loadModel = LoadModel();
    ScrollController scrController;

    int _recLimit = 50;

    var listunit = (Team _item) {
      return Column(
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            title: Text(
              '${_item.team}',
              style: _txtCustomHead.copyWith(color: Colors.black),
            ),
            leading: Icon(FontAwesomeIcons.flagCheckered, size: 30),
            subtitle: Wrap(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '${_item.sport}',
                      style: _txtCustomSub,
                    ),
                    SizedBox(width: 4),
                    Text(' - ${_item.alternate}',
                        style: _txtCustomSub,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ],
                ),
                Text('${_item.league}',
                    style: _txtCustomSub,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      );
    };

    var initDisp = () {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(FontAwesomeIcons.search, size: 48, color: Colors.black26),
              Padding(
                padding: const EdgeInsets.only(top: 15),
              ),
              Text(
                'Type the keyword !',
                style: _txtCustomHead.copyWith(color: Colors.black26),
              ),
            ],
          ),
        ),
      );
    };

    var loadingDisp = () {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text(
              ' Please wait... ',
              style: _txtCustomSub,
            ),
          ],
        ),
      );
    };

    return ScopedModel<QueryModel>(
      model: queryModel,
      child: ScopedModelDescendant<QueryModel>(
          builder: (context, child, QueryModel model) {
        fetchData() async {
          bloc.searchTeam(_searchText);
          Completer<Null> completer = new Completer<Null>();
          Future.delayed(Duration(seconds: 5)).then((_) {
            _loadModel.changeState(false);
            completer.complete();
          });
          return completer.future;
        }

        void startLoader() {
          _loadModel.changeState(true);
          _recLimit += 20;
          fetchData();
        }

        void _scrollListener() {
          if (scrController.position.pixels ==
              scrController.position.maxScrollExtent) {
            startLoader();
          }
        }

        scrController = ScrollController()..addListener(_scrollListener);

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: TextField(
              autofocus: true,
              controller: _controller,
              style: new TextStyle(
                color: Colors.white,
              ),
              decoration: new InputDecoration(
                hintText: "Search team ...",
                hintStyle: new TextStyle(color: Colors.white),
                suffixIcon: Wrap(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        if (_searchText == "") {
                          setState(() {
                            _searchText = "all";
                          });
                        }

                        setState(() {
                          _isSearching = true;
                          _loadData = false;
                          _lastSearchText = _searchText.replaceAll(
                              new RegExp('[^a-zA-Z0-9]'), '');
                          _lastStatus = status;
                          _lastFilter = filter;
                          _lastStartDate = startDate;
                          _lastEndDate = endDate;
                          _dispOnData = false;
                        });

                        print("REGEX: $_lastSearchText");
                        bloc.searchTeam(_searchText);
                        FocusScope.of(context).requestFocus(new FocusNode());
                        print("SEARCH: $_searchText ");
                      },
                    ),
                  ],
                ),
              ),
              onChanged: (String q) {
                setState(() {
                  _searchText = q;
                });
                print(
                    "query: $q - $_searchText - ${model.query} - isSearching: $_isSearching");
              },
              onSubmitted: (String q) {
                model.changeQuery(_searchText);
                int _recLimit = 50;
                if (_searchText == "") {
                  setState(() {
                    _searchText = "all";
                  });
                }

                setState(() {
                  _isSearching = true;
                  _loadData = false;
                  _lastSearchText =
                      _searchText.replaceAll(new RegExp('[^a-zA-Z0-9]'), '');
                  _lastStatus = status;
                  _lastFilter = filter;
                  _lastStartDate = startDate;
                  _lastEndDate = endDate;
                  _dispOnData = false;
                });

                print("REGEX: $_lastSearchText");
                bloc.searchTeam(_searchText);
                FocusScope.of(context).requestFocus(new FocusNode());
                print("SEARCH: $_searchText ");
              },
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                StreamBuilder(
                  stream: bloc.searchteams,
                  builder: (BuildContext context,
                      AsyncSnapshot<TeamModel> snapshot) {
                    print(
                        'hasdata = ${snapshot.hasData} - loaddata: $_loadData');
                    if (snapshot.hasData) {
                      retryDisp = false;
                      // print(
                      //     'length src: ${snapshot.data.results.length}, last search: $_lastSearchText >< ${snapshot.data.results.last.searchText}');

                      final Team _item = snapshot.data.results.last;

                      // if (_lastSearchText == _item.searchText &&
                      //     _lastStatus == _item.evalCodeSearch &&
                      //     _lastFilter == _item.dateFilter &&
                      //     _lastStartDate == _item.startDate.toString() &&
                      //     _lastEndDate == _item.endDate.toString()) {
                      _loadData = true;
                      //   _lastSearchText = _item.searchText;
                      //   _lastFilter = _item.dateFilter;
                      //   _lastStatus = _item.evalCodeSearch;
                      //   _lastStartDate = _item.startDate.toString();
                      //   _lastEndDate = _item.endDate.toString();
                      // } else {
                      //   _loadData = false;
                      // }
                      if (snapshot.data.results.length <= 1 && _loadData) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.tint,
                                  size: 48, color: Colors.black26),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                              ),
                              Text(
                                'Your search did not match any thing.',
                                style: _txtCustomHead.copyWith(
                                    color: Colors.black26),
                              ),
                              Divider(
                                height: 1,
                              ),
                              Text(
                                'Try different keywords or filter.',
                                style: _txtCustomSub,
                              ),
                            ],
                          )),
                        );
                      }

                      print(
                          "_loaddata2: $_loadData - _dispOnData: $_dispOnData - _isSearching: $_isSearching");
                      if (_loadData) {
                        _dispOnData = false;
                        return Scrollbar(
                          child: ListView.builder(
                            controller: scrController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: snapshot.data.results.length -
                                1, // dikurangi 1 karena pada API ada -> "search_text": "isisearchtextnya" (agar tidak muncul)
                            itemBuilder: (BuildContext context, int index) {
                              return listunit(snapshot.data.results[index]);
                            },
                          ),
                        );
                      }

                      if (_dispOnData) {
                        return initDisp();
                      }

                      return loadingDisp();
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
                              'Request time out or not found',
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
                                  bloc.searchTeam(_searchText);
                                  setState(() {
                                    retryDisp = false;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      // color: Color(0xFF87BDB1),
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

                    if (_isSearching) {
                      Future.delayed(const Duration(seconds: env.REQUEST_TIME),
                          () {
                        if (!snapshot.hasData) {
                          print('Request Time Out');
                          setState(() {
                            retryDisp = true;
                          });
                          // Toast.show("Request time out", context,
                          //     duration: 3, gravity: Toast.CENTER);
                        }
                      });
                      return loadingDisp();
                    }

                    return initDisp();
                  },
                ),
                // ScopedModel<LoadModel>(
                //   model: _loadModel,
                //   child: ScopedModelDescendant<LoadModel>(
                //     builder: (context, child, model) {
                //       return model.isLoading
                //           ? Align(
                //               child: LinearProgressIndicator(),
                //               alignment: FractionalOffset.bottomCenter,
                //             )
                //           : Container();
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: Color(0xFF87BDB1),
          //   child: Icon(Icons.filter_list),
          //   onPressed: () {
          //     _navigateAndDisplayFilter(context);
          //   },
          // ),
        );
      }),
    );
  }
}

class QueryModel extends Model {
  String _query = '';
  String get query => _query;
  void changeQuery(String q) {
    _query = q;
    notifyListeners();
  }
}

class LoadModel extends Model {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void changeState(bool q) {
    _isLoading = q;
    notifyListeners();
  }
}

class Filter extends Model {
  String selectedDate = 'Sample';
  int valSelectedDate = 1;
  DateTime valDate;
  // bool get isLoading => _isLoading;
  void changeState(bool q) {
    // _isLoading = q;
    notifyListeners();
  }
}
