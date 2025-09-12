
import 'dart:convert';

DreamTeamResponse dreamTeamResponseFromJson(String str) => DreamTeamResponse.fromJson(json.decode(str));

String dreamTeamResponseToJson(DreamTeamResponse data) => json.encode(data.toJson());

class DreamTeamResponse {
    bool? success;
    DreamTeamData? dreamTeam;
    int? totalPlayers;

    DreamTeamResponse({
        this.success,
        this.dreamTeam,
        this.totalPlayers,
    });

    factory DreamTeamResponse.fromJson(Map<String, dynamic> json) => DreamTeamResponse(
        success: json["success"],
        dreamTeam: json["dreamTeam"] == null ? null : DreamTeamData.fromJson(json["dreamTeam"]),
        totalPlayers: json["totalPlayers"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "dreamTeam": dreamTeam?.toJson(),
        "totalPlayers": totalPlayers,
    };
}

class DreamTeamData {
    List<DreamPlayer>? goalkeeper;
    List<DreamPlayer>? defenders;
    List<DreamPlayer>? midfielders;
    List<DreamPlayer>? forwards;

    DreamTeamData({
        this.goalkeeper,
        this.defenders,
        this.midfielders,
        this.forwards,
    });

    factory DreamTeamData.fromJson(Map<String, dynamic> json) => DreamTeamData(
        goalkeeper: json["goalkeeper"] == null ? [] : List<DreamPlayer>.from(json["goalkeeper"]!.map((x) => DreamPlayer.fromJson(x))),
        defenders: json["defenders"] == null ? [] : List<DreamPlayer>.from(json["defenders"]!.map((x) => DreamPlayer.fromJson(x))),
        midfielders: json["midfielders"] == null ? [] : List<DreamPlayer>.from(json["midfielders"]!.map((x) => DreamPlayer.fromJson(x))),
        forwards: json["forwards"] == null ? [] : List<DreamPlayer>.from(json["forwards"]!.map((x) => DreamPlayer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "goalkeeper": goalkeeper == null ? [] : List<dynamic>.from(goalkeeper!.map((x) => x.toJson())),
        "defenders": defenders == null ? [] : List<dynamic>.from(defenders!.map((x) => x.toJson())),
        "midfielders": midfielders == null ? [] : List<dynamic>.from(midfielders!.map((x) => x.toJson())),
        "forwards": forwards == null ? [] : List<dynamic>.from(forwards!.map((x) => x.toJson())),
    };
}

class DreamPlayer {
    String? id;
    String? firstName;
    String? lastName;
    String? position;
    String? profilePicture;
    int? xp;
    List<dynamic>? achievements;
    DreamPlayerStats? stats;

    DreamPlayer({
        this.id,
        this.firstName,
        this.lastName,
        this.position,
        this.profilePicture,
        this.xp,
        this.achievements,
        this.stats,
    });

    factory DreamPlayer.fromJson(Map<String, dynamic> json) => DreamPlayer(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        position: json["position"],
        profilePicture: json["profilePicture"],
        xp: json["xp"],
        achievements: json["achievements"] == null ? [] : List<dynamic>.from(json["achievements"]!.map((x) => x)),
        stats: json["stats"] == null ? null : DreamPlayerStats.fromJson(json["stats"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "position": position,
        "profilePicture": profilePicture,
        "xp": xp,
        "achievements": achievements == null ? [] : List<dynamic>.from(achievements!.map((x) => x)),
        "stats": stats?.toJson(),
    };

    String get displayName => [firstName, lastName].where((s) => s != null && s.isNotEmpty).join(" ").trim();
}

class DreamPlayerStats {
    int? matchesPlayed;
    int? goals;
    int? assists;
    int? cleanSheets;
    int? motm;
    double? winPercentage;
    int? points;

    DreamPlayerStats({
        this.matchesPlayed,
        this.goals,
        this.assists,
        this.cleanSheets,
        this.motm,
        this.winPercentage,
        this.points,
    });

    factory DreamPlayerStats.fromJson(Map<String, dynamic> json) => DreamPlayerStats(
        matchesPlayed: json["matchesPlayed"],
        goals: json["goals"],
        assists: json["assists"],
        cleanSheets: json["cleanSheets"],
        motm: json["motm"],
        winPercentage: (json["winPercentage"] as num?)?.toDouble(),
        points: json["points"],
    );

    Map<String, dynamic> toJson() => {
        "matchesPlayed": matchesPlayed,
        "goals": goals,
        "assists": assists,
        "cleanSheets": cleanSheets,
        "motm": motm,
        "winPercentage": winPercentage,
        "points": points,
    };
}
