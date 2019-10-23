import 'package:flutter/material.dart';

import 'team_bloc.dart';
export 'team_bloc.dart';

class TeamBlocProvider extends InheritedWidget {
  final TeamBloc bloc;

  TeamBlocProvider({Key key, Widget child})
      : bloc = TeamBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static TeamBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(TeamBlocProvider)
            as TeamBlocProvider)
        .bloc;
  }
}
