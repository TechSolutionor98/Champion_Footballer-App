class CreateMatchRequest {
  final String leagueId;
  final String homeTeamName;
  final String awayTeamName;
  final DateTime start;
  final DateTime end;
  final String location;
  final int homeTeamGoals;
  final int awayTeamGoals;
  final String notes;
  final List<String> homeTeamUsers;
  final List<String> awayTeamUsers;
  final String token;

  CreateMatchRequest({
    required this.leagueId,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.start,
    required this.end,
    required this.location,
    required this.homeTeamGoals,
    required this.awayTeamGoals,
    required this.notes,
    required this.homeTeamUsers,
    required this.awayTeamUsers,
    required this.token,
  });
}
