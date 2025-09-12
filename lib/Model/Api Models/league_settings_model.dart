import 'dart:convert';

LeagueSettingsResponse leagueSettingsResponseFromJson(String str) => LeagueSettingsResponse.fromJson(json.decode(str));
String leagueSettingsResponseToJson(LeagueSettingsResponse data) => json.encode(data.toJson());

class LeagueSettingsResponse {
    bool? success;
    LeagueDetails? league;

    LeagueSettingsResponse({
        this.success,
        this.league,
    });

    factory LeagueSettingsResponse.fromJson(Map<String, dynamic> json) => LeagueSettingsResponse(
        success: json["success"],
        league: json["league"] == null ? null : LeagueDetails.fromJson(json["league"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "league": league?.toJson(),
    };
}

class LeagueDetails {
    String? id;
    String? name;
    String? inviteCode;
    bool? active;
    int? maxGames;
    bool? showPoints;
    List<LeagueAdminInfo>? administrators;
    List<LeagueMemberInfo>? members;

    LeagueDetails({
        this.id,
        this.name,
        this.inviteCode,
        this.active,
        this.maxGames,
        this.showPoints,
        this.administrators,
        this.members,
    });

    factory LeagueDetails.fromJson(Map<String, dynamic> json) => LeagueDetails(
        id: json["id"],
        name: json["name"],
        inviteCode: json["inviteCode"],
        active: json["active"],
        maxGames: json["maxGames"],
        showPoints: json["showPoints"],
        administrators: json["administrators"] == null 
            ? [] 
            : List<LeagueAdminInfo>.from(json["administrators"].map((x) => LeagueAdminInfo.fromJson(x))),
        members: json["members"] == null 
            ? [] 
            : List<LeagueMemberInfo>.from(json["members"].map((x) => LeagueMemberInfo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "inviteCode": inviteCode,
        "active": active,
        "maxGames": maxGames,
        "showPoints": showPoints,
        "administrators": administrators == null ? [] : List<dynamic>.from(administrators!.map((x) => x.toJson())),
        "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x.toJson())),
    };
}


class LeagueAdminInfo {
    String? id;
    String? firstName;
    String? lastName;
    String? email;

    LeagueAdminInfo({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
    });

    factory LeagueAdminInfo.fromJson(Map<String, dynamic> json) => LeagueAdminInfo(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
    };
}

class LeagueMemberInfo {
    String? id;
    String? firstName;
    String? lastName;
    String? email;

    LeagueMemberInfo({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
    });

    factory LeagueMemberInfo.fromJson(Map<String, dynamic> json) => LeagueMemberInfo(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
    };
}
