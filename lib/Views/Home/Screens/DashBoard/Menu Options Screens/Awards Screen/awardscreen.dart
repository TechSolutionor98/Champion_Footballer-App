import 'package:champion_footballer/Model/Api%20Models/usermodel.dart';
import 'package:champion_footballer/Services/RiverPord%20Provider/ref_provider.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import 'dart:math' as math;

// --- Data Classes for Trophy Logic ---
class PlayerLeagueStats {
  final String playerId;
  String playerName;
  String playerPosition;
  int played;
  int wins;
  int draws;
  int losses;
  int goals;
  int assists;
  int motmVotes;
  int teamGoalsConceded;
  int cleanSheets;

  PlayerLeagueStats({
    required this.playerId,
    this.playerName = 'Unknown Player',
    this.playerPosition = 'unknown',
    this.played = 0,
    this.wins = 0,
    this.draws = 0,
    this.losses = 0,
    this.goals = 0,
    this.assists = 0,
    this.motmVotes = 0,
    this.teamGoalsConceded = 0,
    this.cleanSheets = 0,
  });

  int get points => (wins * 3) + draws;
  double get winRatio => played > 0 ? wins / played : 0.0;
  double get averageGoalsConceded => played > 0 && (playerPosition.contains('defender') || playerPosition.contains('goalkeeper')) ? teamGoalsConceded / played : double.infinity;
}

class LeagueTrophyDisplay {
  final String title;
  final String description;
  final String imageAssetPath;
  final Color tbcColor;
  String winnerName;
  String? winnerId;

  LeagueTrophyDisplay({
    required this.title,
    required this.description,
    required this.imageAssetPath,
    required this.tbcColor,
    this.winnerName = "TBC",
    this.winnerId,
  });
}

// --- Personal Badge Data Classes ---
class PersonalBadge {
  final String id;
  final String title;
  final String description;
  final String imageAssetPath;
  final Color color;
  final int currentCount;
  final int targetCount;
  final int xpReward;
  final bool isUnlocked;

  PersonalBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.imageAssetPath,
    required this.color,
    required this.currentCount,
    required this.targetCount,
    required this.xpReward,
    required this.isUnlocked,
  });

  double get progress => currentCount / targetCount;
  String get progressText => '$currentCount/$targetCount';
}

class UserMatchSummary {
  final int goals;
  final int assists;
  final int conceded;
  final String result; // 'W', 'D', 'L'
  final bool hasMotm;

  UserMatchSummary({
    required this.goals,
    required this.assists,
    required this.conceded,
    required this.result,
    required this.hasMotm,
  });
}
// --- End Data Classes ---

class TrophyRoomScreen extends ConsumerStatefulWidget {
  const TrophyRoomScreen({super.key});

  @override
  ConsumerState<TrophyRoomScreen> createState() => _TrophyRoomScreenState();
}

class _TrophyRoomScreenState extends ConsumerState<TrophyRoomScreen> {
  LeaguesJoined? _selectedLeagueForAwards;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDefaultLeagueIfNeeded();
    });
  }

  void _setDefaultLeagueIfNeeded() {
    if (!mounted) return;
    final userDataAsync = ref.read(userDataProvider);
    userDataAsync.whenData((welcomeUser) {
      if (!mounted) return;
      final leaguesList = welcomeUser.leagues ?? [];
      if (_selectedLeagueForAwards == null && leaguesList.isNotEmpty) {
        LeaguesJoined? potentialDefault;
        try {
          potentialDefault = leaguesList.firstWhere((league) => league.active != true);
        } catch (e) {
          potentialDefault = leaguesList.first;
        }
        if (mounted) {
          setState(() {
            _selectedLeagueForAwards = potentialDefault;
          });
        }
      }
    });
  }

  bool _isLeagueConsideredComplete(LeaguesJoined? league) {
    bool isComplete = league?.active != true;
    developer.log("[TrophyDebug] League: ${league?.name}, active: ${league?.active}, isComplete: $isComplete", name: "TrophyRoomScreen");
    return isComplete;
  }

  String _getLeagueDisplayName(LeaguesJoined? league, bool noLeaguesCurrentlyJoined) {
    if (league == null) {
      return noLeaguesCurrentlyJoined ? "NO LEAGUES JOINED" : "SELECT A LEAGUE";
    }
    final name = league.name?.trim() ?? "Unnamed League";
    if (name == "Unnamed League" || name.isEmpty) return name.toUpperCase();

    final parts = name.split(' ').where((p) => p.isNotEmpty);
    final initials = parts.map((p) => p[0].toUpperCase()).join('');
    return "${name.toUpperCase()} ($initials)";
  }

  Map<String, PlayerLeagueStats> _calculatePlayerStatsForLeague(LeaguesJoined league) {
    developer.log("[TrophyDebug] _calculatePlayerStatsForLeague for League: ${league.name}", name: "TrophyRoomScreen");
    Map<String, PlayerLeagueStats> playerStatsMap = {};

    for (var member in league.members ?? []) {
      if (member.id != null) {
        String rawFirstName = member.firstName ?? '';
        String rawLastName = member.lastName ?? '';
        String constructedName = '${rawFirstName} ${rawLastName}'.trim();
        String nameToUse = constructedName.isNotEmpty ? constructedName : 'Unknown Player';

        String serverPosition = member.positionType ?? 'unknown';
        String processedPosition = serverPosition.toLowerCase();

        developer.log("[TrophyDebug] Member: ${member.id}, Name: $nameToUse, ServerPos FROM 'member.positionType': '$serverPosition', ProcessedPos: '$processedPosition'", name: "TrophyRoomScreen");

        playerStatsMap[member.id!] = PlayerLeagueStats(
          playerId: member.id!,
          playerName: nameToUse,
          playerPosition: processedPosition,
        );
      }
    }
    developer.log("[TrophyDebug] Initial playerStatsMap size: ${playerStatsMap.length}", name: "TrophyRoomScreen");

    for (final Match? currentMatch in league.matches ?? []) {
      if (currentMatch == null || currentMatch.status?.toLowerCase() != "completed") {
        continue;
      }

      List<UserElement> homeTeamUsers = currentMatch.homeTeamUsers ?? [];
      List<UserElement> awayTeamUsers = currentMatch.awayTeamUsers ?? [];
      List<String> homePlayerIds = homeTeamUsers.map((p) => p.id ?? '').where((id) => id.isNotEmpty).toList();
      List<String> awayPlayerIds = awayTeamUsers.map((p) => p.id ?? '').where((id) => id.isNotEmpty).toList();
      int homeScore = currentMatch.homeTeamGoals ?? 0;
      int awayScore = currentMatch.awayTeamGoals ?? 0;
      Set<String> allPlayerIdsInMatch = {...homePlayerIds, ...awayPlayerIds};

      for (String playerIdInMatch in allPlayerIdsInMatch) {
        final stats = playerStatsMap[playerIdInMatch];
        if (stats == null) continue;

        stats.played++;
        bool wasHomeTeam = homePlayerIds.contains(playerIdInMatch);

        if (homeScore == awayScore) stats.draws++;
        else if (wasHomeTeam && homeScore > awayScore) stats.wins++;
        else if (!wasHomeTeam && awayScore > homeScore) stats.wins++;
        else stats.losses++;

        stats.teamGoalsConceded += wasHomeTeam ? awayScore : homeScore;

        List<Statistic> matchStatistics = currentMatch.statistics ?? [];
        for (var statEntry in matchStatistics.where((s) => s.userId == playerIdInMatch)) {
          if (statEntry.type == Type.GOALS_SCORED) {
            stats.goals = stats.goals + (statEntry.value ?? 0).toInt();
          } else if (statEntry.type == Type.GOALS_ASSISTED) {
            stats.assists = stats.assists + (statEntry.value ?? 0).toInt();
          }
        }

        List<Vote> matchVotes = currentMatch.votes ?? [];
        for (var voteEntry in matchVotes.where((v) => v.forUserId == playerIdInMatch)) {
          stats.motmVotes++;
        }

        if (stats.playerPosition.contains('goalkeeper')) {
          if ((wasHomeTeam && awayScore == 0) || (!wasHomeTeam && homeScore == 0)) {
            stats.cleanSheets++;
          }
        }
      }
    }
    developer.log("[TrophyDebug] Final playerStatsMap (sample after processing matches): ${playerStatsMap.entries.take(2).map((e) => '${e.key}: played ${e.value.played}, pos ${e.value.playerPosition}').toList()}", name: "TrophyRoomScreen");
    return playerStatsMap;
  }

  List<LeagueTrophyDisplay> _getDefaultDisplayedTrophies(List<Map<String, dynamic>> baseConfig) {
    developer.log("[TrophyDebug] _getDefaultDisplayedTrophies called", name: "TrophyRoomScreen");
    return baseConfig.map((trophyDef) {
      return LeagueTrophyDisplay(
        title: trophyDef['title'] as String,
        description: trophyDef['description'] as String,
        imageAssetPath: trophyDef['image'] as String,
        tbcColor: trophyDef['tbcColor'] as Color,
        winnerName: "TBC",
      );
    }).toList();
  }

  List<LeagueTrophyDisplay> _determineLeagueTrophyWinners(
      Map<String, PlayerLeagueStats> playerStatsMap,
      List<Map<String, dynamic>> baseTrophiesConfig,
      LeaguesJoined currentLeague) {
    developer.log("[TrophyDebug] _determineLeagueTrophyWinners for League: ${currentLeague.name}", name: "TrophyRoomScreen");
    developer.log("[TrophyDebug] playerStatsMap size at entry: ${playerStatsMap.length}", name: "TrophyRoomScreen");

    if (playerStatsMap.isNotEmpty) {
      final Set<String> uniquePositions = playerStatsMap.values.map((p) => p.playerPosition).toSet();
      developer.log("[TrophyDebug] Unique player positions in this league: ${uniquePositions.toList()}", name: "TrophyRoomScreen");
      developer.log("[TrophyDebug] Sample player from playerStatsMap: ID=${playerStatsMap.entries.first.key}, Name=${playerStatsMap.entries.first.value.playerName}, Pos=${playerStatsMap.entries.first.value.playerPosition}, Played=${playerStatsMap.entries.first.value.played}", name: "TrophyRoomScreen");
    }

    List<LeagueTrophyDisplay> calculatedTrophies = [];

    if (playerStatsMap.isEmpty) {
      developer.log("[TrophyDebug] playerStatsMap is EMPTY. All trophies 'No Winner'.", name: "TrophyRoomScreen");
      return baseTrophiesConfig.map((trophyDef) {
        return LeagueTrophyDisplay(
          title: trophyDef['title'] as String,
          description: trophyDef['description'] as String,
          imageAssetPath: trophyDef['image'] as String,
          tbcColor: trophyDef['tbcColor'] as Color,
          winnerName: "No Winner",
        );
      }).toList();
    }

    String getPlayerName(String? playerId) {
      if (playerId == null) return "Unknown";
      return playerStatsMap[playerId]?.playerName ?? "Unknown";
    }

    List<PlayerLeagueStats> leagueTableAllMembers = playerStatsMap.values.toList();
    leagueTableAllMembers.sort((a, b) => b.points.compareTo(a.points));

    List<PlayerLeagueStats> allMembersAsCandidates = playerStatsMap.values.toList();

    for (var trophyConfig in baseTrophiesConfig) {
      String title = trophyConfig['title'] as String;
      PlayerLeagueStats? winnerStats;
      String winnerDisplayName;
      List<PlayerLeagueStats> currentCandidates;

      developer.log("[TrophyDebug] Calculating for Trophy: $title", name: "TrophyRoomScreen");

      switch (title) {
        case "League Champion":
          if (leagueTableAllMembers.isNotEmpty) {
            winnerStats = leagueTableAllMembers.first;
          }
          break;
        case "Runner-Up":
          if (leagueTableAllMembers.length > 1) {
            winnerStats = leagueTableAllMembers[1];
          }
          break;
        case "Ballon D'or":
          currentCandidates = List.from(allMembersAsCandidates);
          if (currentCandidates.isNotEmpty) {
            currentCandidates.sort((a, b) => b.motmVotes.compareTo(a.motmVotes));
            winnerStats = currentCandidates.first;
          }
          break;
        case "GOAT":
          currentCandidates = List.from(allMembersAsCandidates);
          if (currentCandidates.isNotEmpty) {
            currentCandidates.sort((a, b) {
              double ratioA = a.played > 0 ? a.wins / a.played : 0.0;
              double ratioB = b.played > 0 ? b.wins / b.played : 0.0;
              int winRatioComparison = ratioB.compareTo(ratioA);
              if (winRatioComparison != 0) return winRatioComparison;
              return b.motmVotes.compareTo(a.motmVotes);
            });
            winnerStats = currentCandidates.first;
          }
          break;
        case "Golden Boot":
          currentCandidates = List.from(allMembersAsCandidates);
          if (currentCandidates.isNotEmpty) {
            currentCandidates.sort((a, b) => b.goals.compareTo(a.goals));
            winnerStats = currentCandidates.first;
          }
          break;
        case "King Playmaker":
          currentCandidates = List.from(allMembersAsCandidates);
          if (currentCandidates.isNotEmpty) {
            currentCandidates.sort((a, b) => b.assists.compareTo(a.assists));
            winnerStats = currentCandidates.first;
          }
          break;

        case "Legendary Shield":
          developer.log("[TrophyDebug] Shield: All positions in map: ${playerStatsMap.values.map((p) => '${p.playerName}: ${p.playerPosition}').toList()}", name: "TrophyRoomScreen");
          currentCandidates = playerStatsMap.values
              .where((p) => (p.playerPosition.contains('defender') || p.playerPosition.contains('goalkeeper')))
              .toList();
          developer.log("[TrophyDebug] Shield: Found ${currentCandidates.length} candidates (Def/GK). Candidates: ${currentCandidates.map((p) => p.playerName).toList()}", name: "TrophyRoomScreen");
          if (currentCandidates.isNotEmpty) {
            currentCandidates.sort((a, b) => a.averageGoalsConceded.compareTo(b.averageGoalsConceded));
            winnerStats = currentCandidates.first;
          }
          break;

        case "The Dark Horse":
          if (leagueTableAllMembers.length > 3) {
            List<PlayerLeagueStats> outsideTop3 = leagueTableAllMembers.sublist(3);
            if (outsideTop3.isNotEmpty) {
              outsideTop3.sort((a, b) => b.motmVotes.compareTo(a.motmVotes));
              winnerStats = outsideTop3.first;
            }
          }
          break;

        case "Star Keeper":
          developer.log("[TrophyDebug] Keeper: All positions in map: ${playerStatsMap.values.map((p) => '${p.playerName}: ${p.playerPosition}').toList()}", name: "TrophyRoomScreen");
          currentCandidates = playerStatsMap.values
              .where((p) => p.playerPosition.contains('goalkeeper'))
              .toList();
          developer.log("[TrophyDebug] Keeper: Found ${currentCandidates.length} candidates (GK). Candidates: ${currentCandidates.map((p) => p.playerName).toList()}", name: "TrophyRoomScreen");
          if (currentCandidates.isNotEmpty) {
            currentCandidates.sort((a, b) {
              int csComparison = b.cleanSheets.compareTo(a.cleanSheets);
              if (csComparison != 0) return csComparison;
              return a.teamGoalsConceded.compareTo(b.teamGoalsConceded);
            });
            winnerStats = currentCandidates.first;
          }
          break;
      }

      if (winnerStats != null) {
        winnerDisplayName = getPlayerName(winnerStats.playerId);
        developer.log("[TrophyDebug] Trophy: $title, Winner: $winnerDisplayName (ID: ${winnerStats.playerId})", name: "TrophyRoomScreen");
      } else {
        winnerDisplayName = "No Winner";
        developer.log("[TrophyDebug] Trophy: $title, Result: No Winner", name: "TrophyRoomScreen");
      }

      calculatedTrophies.add(LeagueTrophyDisplay(
        title: title,
        description: trophyConfig['description'] as String,
        imageAssetPath: trophyConfig['image'] as String,
        tbcColor: trophyConfig['tbcColor'] as Color,
        winnerName: winnerDisplayName,
        winnerId: winnerStats?.playerId,
      ));
    }
    return calculatedTrophies;
  }

  // --- Personal Badge Calculation Methods ---

  List<UserMatchSummary> _getUserMatchSummaries(WelcomeUser user) {
    final List<UserMatchSummary> summaries = [];
    final userId = user.id;

    if (userId == null) return summaries;

    for (final league in user.leagues ?? []) {
      for (final match in league.matches ?? []) {
        if (match.status?.toLowerCase() != "completed") continue;

        // Check if user played in this match
        final inHomeTeam = match.homeTeamUsers?.any((p) => p.id == userId) ?? false;
        final inAwayTeam = match.awayTeamUsers?.any((p) => p.id == userId) ?? false;

        if (!inHomeTeam && !inAwayTeam) continue;

        // Get user's stats for this match
        int goals = 0;
        int assists = 0;

        for (final stat in match.statistics ?? []) {
          if (stat.userId == userId) {
            if (stat.type == Type.GOALS_SCORED) {
              goals = (stat.value ?? 0).toInt();
            } else if (stat.type == Type.GOALS_ASSISTED) {
              assists = (stat.value ?? 0).toInt();
            }
          }
        }

        // Determine result
        final homeScore = match.homeTeamGoals ?? 0;
        final awayScore = match.awayTeamGoals ?? 0;
        final String result;
        if (inHomeTeam) {
          result = homeScore > awayScore ? 'W' : (homeScore == awayScore ? 'D' : 'L');
        } else {
          result = awayScore > homeScore ? 'W' : (awayScore == awayScore ? 'D' : 'L');
        }

        // Check MOTM
        final hasMotm = match.votes?.any((vote) => vote.forUserId == userId) ?? false;

        // Goals conceded
        final conceded = inHomeTeam ? awayScore : homeScore;

        summaries.add(UserMatchSummary(
          goals: goals,
          assists: assists,
          conceded: conceded,
          result: result,
          hasMotm: hasMotm,
        ));
      }
    }

    return summaries;
  }

  int _calculateLongestStreak(List<UserMatchSummary> matches, bool Function(UserMatchSummary) condition) {
    int longest = 0;
    int current = 0;

    for (final match in matches) {
      if (condition(match)) {
        current++;
        longest = math.max(longest, current);
      } else {
        current = 0;
      }
    }

    return longest;
  }

  List<PersonalBadge> _calculatePersonalBadges(WelcomeUser user) {
    final matches = _getUserMatchSummaries(user);
    if (matches.isEmpty) {
      return _getDefaultBadges(); // Show locked badges
    }

    // Calculate metrics for badges
    final totalGoals = matches.fold(0, (sum, match) => sum + match.goals);
    final totalAssists = matches.fold(0, (sum, match) => sum + match.assists);
    final totalWins = matches.where((m) => m.result == 'W').length;
    final totalMotm = matches.where((m) => m.hasMotm).length;
    final cleanSheets = matches.where((m) => m.conceded == 0).length;
    final hatTricks = matches.where((m) => m.goals >= 3).length;

    // Calculate streaks
    final winStreak = _calculateLongestStreak(matches, (m) => m.result == 'W');
    final scoringStreak = _calculateLongestStreak(matches, (m) => m.goals > 0);
    final assistStreak = _calculateLongestStreak(matches, (m) => m.assists > 0);
    final motmStreak = _calculateLongestStreak(matches, (m) => m.hasMotm);
    final cleanSheetStreak = _calculateLongestStreak(matches, (m) => m.conceded == 0);

    final badges = <PersonalBadge>[
      // Rising Star (Total XP) - Blue badge
      PersonalBadge(
        id: 'rising_star',
        title: 'Rising Star',
        description: 'Your total XP across all matches',
        imageAssetPath: 'assets/badges/blue.png',
        color: const Color(0xFF3B82F6),
        currentCount: totalGoals + totalAssists + totalWins,
        targetCount: 50,
        xpReward: totalGoals + totalAssists + totalWins,
        isUnlocked: true,
      ),

      // Hat-Trick x3 - Brown badge
      PersonalBadge(
        id: 'hat_trick_3',
        title: 'Hat-Trick x3',
        description: 'Score 3+ goals in 3 separate matches',
        imageAssetPath: 'assets/badges/brown.png',
        color: const Color(0xFF8B4513),
        currentCount: hatTricks,
        targetCount: 3,
        xpReward: 100,
        isUnlocked: hatTricks >= 3,
      ),

      // Captain's 5 Wins - Brown badge
      PersonalBadge(
        id: 'captain_5_wins',
        title: "Captain's 5 Wins",
        description: '5 wins as team captain',
        imageAssetPath: 'assets/badges/brown.png',
        color: const Color(0xFF8B4513),
        currentCount: totalWins,
        targetCount: 5,
        xpReward: 150,
        isUnlocked: totalWins >= 5,
      ),

      // Assist Streak x10 - Brown badge
      PersonalBadge(
        id: 'assist_streak_10',
        title: 'Assist Streak x10',
        description: 'Assist in 10 consecutive matches',
        imageAssetPath: 'assets/badges/brown.png',
        color: const Color(0xFF8B4513),
        currentCount: assistStreak,
        targetCount: 10,
        xpReward: 200,
        isUnlocked: assistStreak >= 10,
      ),

      // Scoring Streak x10 - Brown badge
      PersonalBadge(
        id: 'scoring_streak_10',
        title: 'Scoring Streak x10',
        description: 'Score in 10 consecutive matches',
        imageAssetPath: 'assets/badges/brown.png',
        color: const Color(0xFF8B4513),
        currentCount: scoringStreak,
        targetCount: 10,
        xpReward: 250,
        isUnlocked: scoringStreak >= 10,
      ),

      // Captain's Picks x3 - Brown badge
      PersonalBadge(
        id: 'captain_picks_3',
        title: "Captain's Picks x3",
        description: 'Get 3 captain performance picks',
        imageAssetPath: 'assets/badges/brown.png',
        color: const Color(0xFF8B4513),
        currentCount: totalMotm,
        targetCount: 3,
        xpReward: 300,
        isUnlocked: totalMotm >= 3,
      ),

      // MOTM Streak x4 - Brown badge
      PersonalBadge(
        id: 'motm_streak_4',
        title: 'MOTM Streak x4',
        description: '4 consecutive MOTM performances',
        imageAssetPath: 'assets/badges/brown.png',
        color: const Color(0xFF8B4513),
        currentCount: motmStreak,
        targetCount: 4,
        xpReward: 350,
        isUnlocked: motmStreak >= 4,
      ),

      // Clean-Sheet Win Streak x5 - Brown badge
      PersonalBadge(
        id: 'clean_sheet_win_5',
        title: 'Clean-Sheet Win Streak x5',
        description: '5 consecutive wins with clean sheets',
        imageAssetPath: 'assets/badges/brown.png',
        color: const Color(0xFF8B4513),
        currentCount: cleanSheetStreak,
        targetCount: 5,
        xpReward: 400,
        isUnlocked: cleanSheetStreak >= 5,
      ),

      // Top Spot x10 Matches - Brown badge
      PersonalBadge(
        id: 'top_spot_10',
        title: 'Top Spot x10 Matches',
        description: 'Hold top spot for 10 matches',
        imageAssetPath: 'assets/badges/brown.png',
        color: const Color(0xFF8B4513),
        currentCount: totalWins,
        targetCount: 10,
        xpReward: 450,
        isUnlocked: totalWins >= 10,
      ),

      // 10 In A Row - Brown badge
      PersonalBadge(
        id: 'ten_in_row',
        title: '10 In A Row',
        description: '10 consecutive victories',
        imageAssetPath: 'assets/badges/brown.png',
        color: const Color(0xFF8B4513),
        currentCount: winStreak,
        targetCount: 10,
        xpReward: 500,
        isUnlocked: winStreak >= 10,
      ),
    ];

    return badges;
  }

  List<PersonalBadge> _getDefaultBadges() {
    return [
      PersonalBadge(
        id: 'rising_star',
        title: 'Rising Star',
        description: 'Your total XP across all matches',
        imageAssetPath: 'assets/badges/blue.png',
        color: const Color(0xFF3B82F6),
        currentCount: 0,
        targetCount: 50,
        xpReward: 0,
        isUnlocked: true,
      ),
      PersonalBadge(
        id: 'hat_trick_3',
        title: 'Hat-Trick x3',
        description: 'Score 3+ goals in 3 separate matches',
        imageAssetPath: 'assets/badges/brown.png',
        color: Colors.grey,
        currentCount: 0,
        targetCount: 3,
        xpReward: 100,
        isUnlocked: false,
      ),
      PersonalBadge(
        id: 'captain_5_wins',
        title: "Captain's 5 Wins",
        description: '5 wins as team captain',
        imageAssetPath: 'assets/badges/brown.png',
        color: Colors.grey,
        currentCount: 0,
        targetCount: 5,
        xpReward: 150,
        isUnlocked: false,
      ),
    ];
  }

  // --- Personal Badge Widget (Same layout as All Trophies) ---
  Widget _buildBadgeCard(PersonalBadge badge) {
    return StyledContainer(
      padding: const EdgeInsets.all(6),
      boxShadow: const [],
      borderWidth: 3,
      borderColor: badge.isUnlocked ? badge.color.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                badge.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: badge.isUnlocked ? badge.color : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 3),

              // Description
              Text(
                badge.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),

          // Badge Image
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Image.asset(
                badge.imageAssetPath,
                fit: BoxFit.contain,
                color: badge.isUnlocked ? null : Colors.grey,
              ),
            ),
          ),

          // Progress for non-Rising Star badges
          if (badge.id != 'rising_star')
            Text(
              badge.progressText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: badge.isUnlocked ? badge.color : Colors.grey[600],
              ),
            ),

          // XP Reward for Rising Star
          if (badge.id == 'rising_star')
            Text(
              '${badge.xpReward} XP',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: badge.color,
              ),
            ),

          // Unlock Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: BoxDecoration(
              color: badge.isUnlocked ? badge.color : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              badge.isUnlocked ? 'UNLOCKED' : 'UNLOCK',
              style: TextStyle(
                fontSize: 10,
                color: kdefwhiteColor,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.workspace_premium_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          Text(
            "No Matches Played Yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Text(
            "Play some matches to start earning badges and XP!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Future<void> _showChooseLeagueSheet(List<LeaguesJoined> leaguesList) async {
    final selected = await showModalBottomSheet<LeaguesJoined>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choose League",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor),
                ),
                Divider(color: Colors.grey.shade300, thickness: 1),
                const SizedBox(height: 10),
                Expanded(
                  child: leaguesList.isEmpty
                      ? const Center(child: Text("No leagues available."))
                      : ListView.separated(
                    itemCount: leaguesList.length,
                    separatorBuilder: (_, __) => const SizedBox.shrink(),
                    itemBuilder: (context, index) {
                      final league = leaguesList[index];
                      return LeagueOptionTile(
                        leagueName: league.name ?? "Unnamed League",
                        subtitle: '${league.matches?.length ?? 0} matches, ${league.members?.length ?? 0} players',
                        onTap: () => Navigator.pop(sheetContext, league),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedLeagueForAwards = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataAsync = ref.watch(userDataProvider);

    return DefaultTabController(
      length: 2,
      child: ScaffoldCustom(
        appBar: CustomAppBar(
          titleText: "Trophy Room",
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(229, 106, 22, 1), Color.fromRGBO(207, 35, 38, 1)],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: kdefwhiteColor,
              child: TabBar(
                labelPadding: const EdgeInsets.symmetric(vertical: 5),
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: kPrimaryColor,
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2, offset: Offset(0, 3))],
                ),
                labelColor: kdefwhiteColor,
                labelStyle: const TextStyle(fontSize: 14, fontFamily: "Inter", fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: "Inter"),
                unselectedLabelColor: kPrimaryColor,
                tabs: const [Center(child: Tab(text: 'All Trophies')), Center(child: Tab(text: 'My Achievements'))],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // All Trophies Tab (existing code)
                  userDataAsync.when(
                      data: (welcomeUser) {
                        final allLeagues = welcomeUser.leagues ?? [];
                        if (_selectedLeagueForAwards == null && allLeagues.isNotEmpty && mounted) {
                          WidgetsBinding.instance.addPostFrameCallback((_) => _setDefaultLeagueIfNeeded());
                        }

                        List<LeagueTrophyDisplay> displayedTrophies;
                        bool isCurrentLeagueComplete = false;

                        developer.log("[TrophyDebug] Building 'All Trophies' tab. Selected League: ${_selectedLeagueForAwards?.name}", name: "TrophyRoomScreen");

                        if (_selectedLeagueForAwards != null) {
                          isCurrentLeagueComplete = _isLeagueConsideredComplete(_selectedLeagueForAwards);
                          developer.log("[TrophyDebug] League ${_selectedLeagueForAwards!.name} is considered complete: $isCurrentLeagueComplete", name: "TrophyRoomScreen");

                          Map<String, PlayerLeagueStats> currentLeaguePlayerStats = _calculatePlayerStatsForLeague(_selectedLeagueForAwards!);
                          developer.log("[TrophyDebug] Calculated player stats for ${_selectedLeagueForAwards!.name}. Map size: ${currentLeaguePlayerStats.length}", name: "TrophyRoomScreen");

                          if (isCurrentLeagueComplete) {
                            displayedTrophies = _determineLeagueTrophyWinners(currentLeaguePlayerStats, trophies, _selectedLeagueForAwards!);
                          } else {
                            displayedTrophies = _getDefaultDisplayedTrophies(trophies);
                          }
                        } else {
                          developer.log("[TrophyDebug] No league selected. Displaying default (TBC) trophies.", name: "TrophyRoomScreen");
                          displayedTrophies = _getDefaultDisplayedTrophies(trophies);
                        }

                        return SingleChildScrollView(
                          padding: defaultPadding(vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(width: 40),
                                        Expanded(
                                          child: Text(
                                            _getLeagueDisplayName(_selectedLeagueForAwards, allLeagues.isEmpty),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ktextColor),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (allLeagues.isNotEmpty) {
                                              _showChooseLeagueSheet(allLeagues);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("You haven't joined any leagues yet."))
                                              );
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("Change", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                                                Icon(Icons.arrow_drop_down_circle, color: kPrimaryColor, size: 20),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_selectedLeagueForAwards != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        isCurrentLeagueComplete ? "Final League Standing" : "Current League Standing",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isCurrentLeagueComplete ? Colors.green.shade700 : Colors.blueGrey.shade600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.7,
                                ),
                                itemCount: displayedTrophies.length,
                                itemBuilder: (context, index) {
                                  final trophyData = displayedTrophies[index];
                                  return StyledContainer(
                                    padding: const EdgeInsets.all(6),
                                    boxShadow: const [],
                                    borderWidth: 3,
                                    borderColor: kPrimaryColor.withValues(alpha: .5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(trophyData.title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: trophyData.title == "League Champion" ? trophyData.tbcColor : const Color(0xFF0778A1))),
                                            const SizedBox(height: 3),
                                            Text(trophyData.description, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                                          ],
                                        ),
                                        Expanded(child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                                          child: Image.asset(trophyData.imageAssetPath, fit: BoxFit.contain),
                                        )),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                          decoration: BoxDecoration(color: trophyData.winnerName == "TBC" || trophyData.winnerName == "No Winner" ? Colors.grey : trophyData.tbcColor, borderRadius: BorderRadius.circular(4)),
                                          alignment: Alignment.center,
                                          child: Text(trophyData.winnerName, style: TextStyle(fontSize: 12, color: kdefwhiteColor, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) {
                        developer.log("[TrophyDebug] Error loading user data: $error", name: "TrophyRoomScreen", error: error, stackTrace: stackTrace);
                        return Center(child: Text("Error loading user data: $error"));
                      }
                  ),

                  // My Achievements Tab (Personal Badges with same layout as All Trophies)
                  userDataAsync.when(
                    data: (welcomeUser) {
                      final badges = _calculatePersonalBadges(welcomeUser);

                      return SingleChildScrollView(
                        padding: defaultPadding(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Simple title for My Achievements
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "MY ACHIEVEMENTS",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ktextColor),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Badges Grid with same layout as All Trophies
                            if (badges.isEmpty)
                              _buildEmptyState()
                            else
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 0.7,
                                ),
                                itemCount: badges.length,
                                itemBuilder: (context, index) {
                                  return _buildBadgeCard(badges[index]);
                                },
                              ),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                            const SizedBox(height: 16),
                            Text(
                              "Failed to load achievements",
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> trophies = [
  {
    'title': "League Champion",
    'description': "First Place Player In The League Table",
    'image': 'assets/icons/trophy1.png',
    'tbcColor': const Color(0xFFCA8A04),
  },
  {
    'title': "Runner-Up",
    'description': "Second Place Player In The League Table",
    'image': 'assets/icons/trophy2.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "Ballon D'or",
    'description': "Player With The Most MOTM Awards",
    'image': 'assets/icons/trophy3.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "GOAT",
    'description': "Player With The Highest Win Ratio & Total MOTM Votes",
    'image': 'assets/icons/trophy4.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "Golden Boot",
    'description': "Player With The Highest Number Of Goals Scored",
    'image': 'assets/icons/trophy5.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "King Playmaker",
    'description': "Player With The Highest Number Of Assists",
    'image': 'assets/icons/trophy6.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "Legendary Shield",
    'description': "Defender Or Goalkeeper With The Lowest Average Goal Against",
    'image': 'assets/icons/trophy7.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "The Dark Horse",
    'description': "Player Outside Of The Top 3 League Positions With The Highest MOTM Votes",
    'image': 'assets/icons/trophy8.png',
    'tbcColor': kPrimaryColor,
  },
  {
    'title': "Star Keeper",
    'description': "Goalkeeper with the most clean sheets (or fewest goals conceded)",
    'image': 'assets/badges/blue.png',
    'tbcColor': kPrimaryColor,
  }
];