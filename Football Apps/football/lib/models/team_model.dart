import 'package:scoped_model/scoped_model.dart';

// TEAM
class TeamModel {
  List<Team> _results = [];

  TeamModel.fromJSON(Map<String, dynamic> json) {
    List<Team> temp = [];
    for (int i = 0; i < json['teams'].length; i++) {
      Team result = Team(json['teams'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<Team> get results => _results;
}

class Team extends Model {
  String idTeam; 
  String team; 
  String alternate;
  String formedYear; 
  String sport;
  String league;
  String idLeague;
  String stadium;
  String keywords;

  Team(data) {
    idTeam = data['idTeam'] ?? '';
    team = data['strTeam'] ?? ''; 
    alternate = data['strAlternate'] ?? '';
    formedYear = data['intFormedYear'] ?? '';
    sport = data['strSport'] ?? '';
    league = data['strLeague'] ?? '';
    idLeague = data['idLeague'] ?? '';
    stadium = data['strStadium'] ?? '';
    keywords = data['strKeywords'] ?? '';
  }

  notifyListeners();
}

// LEAGUE
class LeagueModel {
  List<League> _results = [];

  LeagueModel.fromJSON(Map<String, dynamic> json) {
    List<League> temp = [];
    for (int i = 0; i < json['leagues'].length; i++) {
      League result = League(json['leagues'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<League> get results => _results;
}

class League extends Model {
  String idLeague;
  String league;
  String sport;
  String alternate; 

  League(data) {
    idLeague = data['idLeague'] ?? '';
    league = data['strLeague'] ?? '';
    sport = data['strSport'] ?? '';
    alternate = data['strLeagueAlternate'] ?? '';

    notifyListeners();
  }
}

// EVENT
class EventModel {
  List<Event> _results = [];

  EventModel.fromJSON(Map<String, dynamic> json) {
    List<Event> temp = [];
    for (int i = 0; i < json['events'].length; i++) {
      Event result = Event(json['events'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<Event> get results => _results;
}

class Event extends Model {
  String idEvent;
  String event;
  String dateEvent;
  String time; 

  Event(data) {
    idEvent = data['idEvent'] ?? '';
    event = data['strEvent'] ?? '';
    dateEvent = data['dateEvent'] ?? '';
    time = data['strTime'] ?? '';

    notifyListeners();
  }

}
