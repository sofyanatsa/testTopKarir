import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client, Response;
import 'package:http/http.dart' as http;
import 'package:football/models/team_model.dart';

import '../utils/env.dart';
import 'repository.dart';

class PapApiProvider implements Source {
  Client client = Client();

  Future<TeamModel> getTeamList() async {
    try {
      final response = await client
          .get('$API_BASE_URL/search_all_teams.php?s=Soccer&c=England');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        print("getUserTeamList: ${response.statusCode}");
        return TeamModel.fromJSON(responseJson);
      } else {
        throw Exception('Failed fetching list of user team list.');
      }
    } catch (e) {
      print('$e');
    }
    return null;
  }

  Future<TeamModel> getTeamListBy(String c) async {
    print("getTeamListBy data $c");
    try {
      final response =
          await client.get('$API_BASE_URL/search_all_teams.php?s=Soccer&c=$c');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        print("getTeamListBy: ${response.statusCode}");
        return TeamModel.fromJSON(responseJson);
      } else {
        throw Exception('Failed fetching list of team list by $c.');
      }
    } catch (e) {
      print('$e');
    }
    return null;
  }

  Future<TeamModel> searchTeam(String text) async {
    try {
      final response =
          await client.get('$API_BASE_URL/searchteams.php?t=$text');
      // print('text: $text -  STATUS = ${response.statusCode}');
      // print('BODY = ${response.body}');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        // Team team = Team(responseJson);
        return TeamModel.fromJSON(responseJson);
      } else {
        throw Exception('Failed team $text search.');
      }
    } catch (e) {}
    return null;
  }

  Future<LeagueModel> getLeagueList() async {
    try {
      final response = await client.get('$API_BASE_URL/all_leagues.php');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        print("getLeagueList: ${response.statusCode}");
        return LeagueModel.fromJSON(responseJson);
      } else {
        throw Exception('Failed fetching list of leagye team list.');
      }
    } catch (e) {
      print('$e');
    }
    return null;
  }

  Future<EventModel> getEventListByLeagueId(String id, bool past) async {
    try {
      final response = await client.get(past
          ? '$API_BASE_URL/eventspastleague.php?id=$id'
          : '$API_BASE_URL/eventsnextleague.php?id=$id');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        print("getEventListByLeagueId: ${response.statusCode}");
        return EventModel.fromJSON(responseJson);
      } else {
        throw Exception('Failed fetching list of event list.');
      }
    } catch (e) {
      print('$e');
    }
    return null;
  }
}
