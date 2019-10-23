import 'package:http/http.dart';
import 'package:football/models/team_model.dart';
import 'pap_api_provider.dart';

class Repository {
  final papApiProvider = PapApiProvider();

  List<Source> sources = <Source>[
    PapApiProvider(),
  ];

  // List<Cache> caches = <Cache>[
  //   // PapDbProvider(),
  // ];

  // CUSTOMER & PIC
  Future<TeamModel> getTeamList() => papApiProvider.getTeamList();
  Future<TeamModel> getTeamListBy(String c) => papApiProvider.getTeamListBy(c);
  Future<TeamModel> searchTeam(String t) => papApiProvider.searchTeam(t);
  Future<LeagueModel> getLeagueList() => papApiProvider.getLeagueList();
  Future<EventModel> getEventListByLeagueId(String id, bool past) =>
      papApiProvider.getEventListByLeagueId(id, past);

  // CACHES
  // clearCache() async {
  //   for (var cache in caches) {
  //     await cache.clear();
  //   }
  // }
}

abstract class Source {
  // Future<UnitModel> fetchUnitList({String customerId});
  // Future<UnitModel> searchUnit(String query, {int limit});
}

// abstract class Cache {
//   Future<int> addUnit(Unit item);
//   Future<int> clear();
// }
