import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Model/Api Models/usermodel.dart';

final leaguesProvider =
StateNotifierProvider<LeaguesNotifier, List<LeaguesJoined>>(
        (ref) => LeaguesNotifier());

class LeaguesNotifier extends StateNotifier<List<LeaguesJoined>> {
  LeaguesNotifier() : super([]);

  void addLeague(LeaguesJoined league) {
    state = [league, ...state];
  }

  void setLeagues(List<LeaguesJoined> leagues) {
    state = leagues;
  }
}
