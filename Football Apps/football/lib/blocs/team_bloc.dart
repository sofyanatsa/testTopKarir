import 'dart:convert';
import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';
import '../models/team_model.dart';

class TeamBloc {
  final _repository = Repository();
  final _fetcher = BehaviorSubject<TeamModel>();
  final _fetcherSearch = BehaviorSubject<TeamModel>();
  final _fetcherDetail = BehaviorSubject<Team>();
  final _fetcherLeague = BehaviorSubject<LeagueModel>();
  final _fetcherEvent = BehaviorSubject<EventModel>();

  Observable<TeamModel> get teams => _fetcher.stream;
  Observable<TeamModel> get searchteams => _fetcherSearch.stream;
  Observable<Team> get customerDetail => _fetcherDetail.stream;
  Observable<LeagueModel> get leagues => _fetcherLeague.stream;
  Observable<EventModel> get events => _fetcherEvent.stream;

  getTeamList() async {
    TeamModel t = await _repository.getTeamList();
    _fetcher.sink.add(t);
  }

  getTeamListBy(String c) async {
    TeamModel team = await _repository.getTeamListBy(c);
    _fetcher.sink.add(team);
  }

  searchTeam(String t) async {
    TeamModel team = await _repository.searchTeam(t);
    _fetcherSearch.sink.add(team);
  }

  getLeagueList() async {
    LeagueModel t = await _repository.getLeagueList();
    _fetcherLeague.sink.add(t);
  }

  getEventListByLeagueId(String id, bool past) async {
    EventModel team = await _repository.getEventListByLeagueId(id, past);
    _fetcherEvent.sink.add(team);
  }

  dispose() {
    _fetcher.close();
    _fetcherSearch.close();
    _fetcherDetail.close();
    _fetcherLeague.close();
    _fetcherEvent.close();
  }
}
