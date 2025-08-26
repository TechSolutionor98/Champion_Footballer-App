/*import 'package:champion_footballer/Model/Api%20Models/leaguemodel.dart';
class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? position;
  final String? preferredFoot;
  final String? chemistryStyle;
  final int? shirtNumber;
  final int age;
  final String? pictureKey;
  final Map<String, int> attributes;
  final List<League> leaguesJoined; // ✅ new field
  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.age,
    this.position,
    this.preferredFoot,
    this.chemistryStyle,
    this.shirtNumber,
    this.pictureKey,
    required this.attributes,
   required this.leaguesJoined,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      position: json['position'],
      preferredFoot: json['preferredFoot'],
      chemistryStyle: json['chemistryStyle'],
      shirtNumber: json['shirtNumber'],
      age: json['age'],
      pictureKey: json['pictureKey'],
      attributes: Map<String, int>.from(json['attributes'] ?? {}),
        leaguesJoined: (json['leaguesJoined'] as List<dynamic>?)
              ?.map((e) => League.fromJson(e))
              .toList() ??
          [],
    );
  }
}
To parse this JSON data, do*/


import 'dart:ui';

class Welcome {
  WelcomeUser? user;

  Welcome({
    this.user,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        user: json["user"] == null ? null : WelcomeUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };
}

class WelcomeUser {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? displayName;
  String? position;
  int? xp;
  PreferredFoot? preferredFoot;
  String? chemistryStyle;
  String? shirtNumber;
  AdminAttributes? attributes;
  int? age;
  String? ipAddress;
  String? gender;
  PictureKey? pictureKey;
  dynamic matchGuestForId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<LeaguesJoined>? leagues;
  List<Statistic>? matchStatistics;

  WelcomeUser({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.displayName,
    this.position,
    this.xp,
    this.preferredFoot,
    this.chemistryStyle,
    this.shirtNumber,
    this.attributes,
    this.age,
    this.ipAddress,
    this.gender,
    this.pictureKey,
    this.matchGuestForId,
    this.createdAt,
    this.updatedAt,
    this.leagues,
    this.matchStatistics,
  });

  factory WelcomeUser.fromJson(Map<String, dynamic> json) => WelcomeUser(
    id: json["id"],
    email: json["email"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    displayName: json["displayName"],
    position: json["position"],
    preferredFoot: preferredFootValues.map[json["preferredFoot"]],
    chemistryStyle: json["chemistryStyle"],
    shirtNumber: json["shirtNumber"],
    attributes: json["skills"] == null
        ? null
        : AdminAttributes.fromJson(json["skills"]),
    age: json["age"],
    xp: json["xp"],
    ipAddress: json["ipAddress"],
    gender: json["gender"],
    pictureKey: pictureKeyValues.map[json["pictureKey"]],
    matchGuestForId: json["matchGuestForId"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    leagues: json["leagues"] == null
        ? []
        : List<LeaguesJoined>.from(
        json["leagues"]!.map((x) => LeaguesJoined.fromJson(x))),
    matchStatistics: json["matchStatistics"] == null
        ? []
        : List<Statistic>.from(
        json["matchStatistics"]!.map((x) => Statistic.fromJson(x))),
  );


  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "displayName": displayName,
        "position": position,
        "preferredFoot": preferredFootValues.reverse[preferredFoot],
        "chemistryStyle": chemistryStyle,
        "shirtNumber": shirtNumber,
        "attributes": attributes?.toJson(),
        "age": age,
        "ipAddress": ipAddress,
        "gender": gender,
        "pictureKey": pictureKeyValues.reverse[pictureKey],
        "matchGuestForId": matchGuestForId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "leagues": leagues == null
            ? []
            : List<dynamic>.from(leagues!.map((x) => x.toJson())),
        "matchStatistics": matchStatistics == null
            ? []
            : List<dynamic>.from(matchStatistics!.map((x) => x.toJson())),
      };
}

class AdminAttributes {
  int? pace;
  int? passing;
  int? physical;
  int? shooting;
  int? defending;
  int? dribbling;

  AdminAttributes({
    this.pace,
    this.passing,
    this.physical,
    this.shooting,
    this.defending,
    this.dribbling,
  });

  factory AdminAttributes.fromJson(Map<String, dynamic> json) => AdminAttributes(
    pace: json["pace"] ?? json["Pace"],
    passing: json["passing"] ?? json["Passing"],
    physical: json["physical"] ?? json["Physical"],
    shooting: json["shooting"] ?? json["Shooting"],
    defending: json["defending"] ?? json["Defending"],
    dribbling: json["dribbling"] ?? json["Dribbling"],
  );


  Map<String, dynamic> toJson() => {
        "Pace": pace,
        "Passing": passing,
        "Physical": physical,
        "Shooting": shooting,
        "Defending": defending,
        "Dribbling": dribbling,
      };
}

class LeaguesJoined {
  String? id;
  String? name;
  bool? active;
  String? inviteCode;
  int? maxGames;
  bool? showPoints;
  DateTime? createdAt;
  String? image;
  DateTime? updatedAt;
  List<Admin>? admins;
  List<Match>? matches;
  List<UserElement>? users;

  LeaguesJoined({
    this.id,
    this.name,
    this.active,
    this.inviteCode,
    this.maxGames,
    this.showPoints,
    this.createdAt,
    this.updatedAt,
    this.admins,
    this.matches,
    this.users,
    this.image
  });

  factory LeaguesJoined.fromJson(Map<String, dynamic> json) => LeaguesJoined(
        id: json["id"],
        name: json["name"],
        active: json["active"],
        inviteCode: json["inviteCode"],
        maxGames: json["maxGames"],
        showPoints: json["showPoints"],
        image: json["image"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        admins: json["admins"] == null
            ? []
            : List<Admin>.from(json["admins"]!.map((x) => Admin.fromJson(x))),
        matches: json["matches"] == null
            ? []
            : List<Match>.from(json["matches"]!.map((x) => Match.fromJson(x))),
        users: json["users"] == null
            ? []
            : List<UserElement>.from(
                json["users"]!.map((x) => UserElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "active": active,
        "inviteCode": inviteCode,
        "maxGames": maxGames,
        "image": image,
        "showPoints": showPoints,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "admins": admins == null
            ? []
            : List<dynamic>.from(admins!.map((x) => x.toJson())),
        "matches": matches == null
            ? []
            : List<dynamic>.from(matches!.map((x) => x.toJson())),
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class Admin {
  String? id;
  String? firstName;
  String? lastName;
  String? displayName;
  String? position;
  PreferredFoot? preferredFoot;
  String? chemistryStyle;
  int? shirtNumber;
  AdminAttributes? attributes;
  PictureKey? pictureKey;
  String? password;
  String? matchGuestForId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Admin({
    this.id,
    this.firstName,
    this.lastName,
    this.displayName,
    this.position,
    this.preferredFoot,
    this.chemistryStyle,
    this.shirtNumber,
    this.attributes,
    this.pictureKey,
    this.password,
    this.matchGuestForId,
    this.createdAt,
    this.updatedAt,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        displayName: json["displayName"],
        position: json["position"],
        preferredFoot: preferredFootValues.map[json["preferredFoot"]],
        chemistryStyle: json["chemistryStyle"],
        shirtNumber: json["shirtNumber"],
        attributes: json["attributes"] == null
            ? null
            : AdminAttributes.fromJson(json["attributes"]),
        pictureKey: pictureKeyValues.map[json["pictureKey"]],
        password: json["password"],
        matchGuestForId: json["matchGuestForId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "displayName": displayName,
        "position": position,
        "preferredFoot": preferredFootValues.reverse[preferredFoot],
        "chemistryStyle": chemistryStyle,
        "shirtNumber": shirtNumber,
        "attributes": attributes?.toJson(),
        "pictureKey": pictureKeyValues.reverse[pictureKey],
        "password": password,
        "matchGuestForId": matchGuestForId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

enum PictureKey {
  E32917_D0_A0_C4_11_EF_817_E_6105_AD9_F2594_PIC_JPG,
  THE_0_A3_F4660_A407_11_EF_B823_A171_DF239315_IMAGE_24_PNG
}

final pictureKeyValues = EnumValues({
  "e32917d0-a0c4-11ef-817e-6105ad9f2594/pic.jpg":
      PictureKey.E32917_D0_A0_C4_11_EF_817_E_6105_AD9_F2594_PIC_JPG,
  "0a3f4660-a407-11ef-b823-a171df239315/image 24.png":
      PictureKey.THE_0_A3_F4660_A407_11_EF_B823_A171_DF239315_IMAGE_24_PNG
});

enum PreferredFoot { LEFT, RIGHT }

final preferredFootValues =
    EnumValues({"Left": PreferredFoot.LEFT, "Right": PreferredFoot.RIGHT});

/*class Match {
  String? id;
  DateTime? start;
  DateTime? end;
  DateTime? date;
  String? location;
  String? notes;
  String? leagueId;
  String? homeTeamName;
  int? homeTeamGoals;
  String? awayTeamName;
  int? awayTeamGoals;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Admin>? availableUsers;
  List<UserElement>? homeTeamUsers;
  List<UserElement>? awayTeamUsers;
  List<Vote>? votes;
  List<Statistic>? statistics;

  Match({
    this.id,
    this.start,
    this.end,
    this.date,
    this.location,
    this.notes,
    this.leagueId,
    this.homeTeamName,
    this.homeTeamGoals,
    this.awayTeamName,
    this.awayTeamGoals,
    this.createdAt,
    this.updatedAt,
    this.availableUsers,
    this.homeTeamUsers,
    this.awayTeamUsers,
    this.votes,
    this.statistics,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        id: json["id"],
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        location: json["location"],
        notes: json["notes"],
        leagueId: json["leagueId"],
        homeTeamName: json["homeTeamName"],
        homeTeamGoals: json["homeTeamGoals"],
        awayTeamName: json["awayTeamName"],
        awayTeamGoals: json["awayTeamGoals"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        availableUsers: json["availableUsers"] == null
            ? []
            : List<Admin>.from(
                json["availableUsers"]!.map((x) => Admin.fromJson(x))),
        homeTeamUsers: json["homeTeamUsers"] == null
            ? []
            : List<UserElement>.from(
                json["homeTeamUsers"]!.map((x) => UserElement.fromJson(x))),
        awayTeamUsers: json["awayTeamUsers"] == null
            ? []
            : List<UserElement>.from(
                json["awayTeamUsers"]!.map((x) => UserElement.fromJson(x))),
        votes: json["votes"] == null
            ? []
            : List<Vote>.from(json["votes"]!.map((x) => Vote.fromJson(x))),
        statistics: json["statistics"] == null
            ? []
            : List<Statistic>.from(
                json["statistics"]!.map((x) => Statistic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
        "location": location,
        "notes": notes,
        "leagueId": leagueId,
        "homeTeamName": homeTeamName,
        "homeTeamGoals": homeTeamGoals,
        "awayTeamName": awayTeamName,
        "awayTeamGoals": awayTeamGoals,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "availableUsers": availableUsers == null
            ? []
            : List<dynamic>.from(availableUsers!.map((x) => x.toJson())),
        "homeTeamUsers": homeTeamUsers == null
            ? []
            : List<dynamic>.from(homeTeamUsers!.map((x) => x.toJson())),
        "awayTeamUsers": awayTeamUsers == null
            ? []
            : List<dynamic>.from(awayTeamUsers!.map((x) => x.toJson())),
        "votes": votes == null
            ? []
            : List<dynamic>.from(votes!.map((x) => x.toJson())),
        "statistics": statistics == null
            ? []
            : List<dynamic>.from(statistics!.map((x) => x.toJson())),
      };
}*/

int? _parseToInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _parseDateTime(String? dateString) {
  if (dateString == null) return null;
  return DateTime.tryParse(dateString);
}
class Match {
  String? id;
  DateTime? date;
  String? location;
  String? status;
  dynamic score; // Can be null, String, or a structured object. Dynamic is safest initially.
  // Consider creating a Score model if it's structured e.g. {"home": 1, "away": 0}
  String? leagueId;
  String? homeTeamName;
  String? awayTeamName;
  int? homeTeamGoals;
  int? awayTeamGoals;
  DateTime? start;
  DateTime? end;
  String? notes;
  String? homeCaptainId;
  String? awayCaptainId;
  String? homeTeamImage;
  String? awayTeamImage;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<UserElement>? availableUsers;
  List<UserElement>? homeTeamUsers;
  List<UserElement>? awayTeamUsers;
  List<Statistic>? statistics;
  List<Vote>? votes; // Included as it was in your previous model, make it optional

  Match({
    this.id,
    this.date,
    this.location,
    this.status,
    this.score,
    this.leagueId,
    this.homeTeamName,
    this.awayTeamName,
    this.homeTeamGoals,
    this.awayTeamGoals,
    this.start,
    this.end,
    this.notes,
    this.homeCaptainId,
    this.awayCaptainId,
    this.homeTeamImage,
    this.awayTeamImage,
    this.createdAt,
    this.updatedAt,
    this.availableUsers,
    this.homeTeamUsers,
    this.awayTeamUsers,
    this.statistics,
    this.votes,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json["id"],
      date: _parseDateTime(json["date"]),
      location: json["location"],
      status: json["status"],
      score: json["score"], // Assign directly, handle its type in UI or with a dedicated model
      leagueId: json["leagueId"],
      homeTeamName: json["homeTeamName"],
      awayTeamName: json["awayTeamName"],
      homeTeamGoals: _parseToInt(json["homeTeamGoals"]),
      awayTeamGoals: _parseToInt(json["awayTeamGoals"]),
      start: _parseDateTime(json["start"]),
      end: _parseDateTime(json["end"]),
      notes: json["notes"],
      homeCaptainId: json["homeCaptainId"],
      awayCaptainId: json["awayCaptainId"],
      homeTeamImage: json["homeTeamImage"],
      awayTeamImage: json["awayTeamImage"],
      createdAt: _parseDateTime(json["createdAt"]),
      updatedAt: _parseDateTime(json["updatedAt"]),
      availableUsers: json["availableUsers"] == null
          ? []
          : List<UserElement>.from(
          json["availableUsers"]!.map((x) => UserElement.fromJson(x))),
      homeTeamUsers: json["homeTeamUsers"] == null
          ? []
          : List<UserElement>.from(
          json["homeTeamUsers"]!.map((x) => UserElement.fromJson(x))),
      awayTeamUsers: json["awayTeamUsers"] == null
          ? []
          : List<UserElement>.from(
          json["awayTeamUsers"]!.map((x) => UserElement.fromJson(x))),
      statistics: json["statistics"] == null
          ? []
          : List<Statistic>.from(
          json["statistics"]!.map((x) => Statistic.fromJson(x))),
      votes: json["votes"] == null // If "votes" might be missing from JSON
          ? []
          : List<Vote>.from(
          json["votes"]!.map((x) => Vote.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date?.toIso8601String(),
    "location": location,
    "status": status,
    "score": score,
    "leagueId": leagueId,
    "homeTeamName": homeTeamName,
    "awayTeamName": awayTeamName,
    "homeTeamGoals": homeTeamGoals,
    "awayTeamGoals": awayTeamGoals,
    "start": start?.toIso8601String(),
    "end": end?.toIso8601String(),
    "notes": notes,
    "homeCaptainId": homeCaptainId,
    "awayCaptainId": awayCaptainId,
    "homeTeamImage": homeTeamImage,
    "awayTeamImage": awayTeamImage,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "availableUsers": availableUsers == null
        ? []
        : List<dynamic>.from(availableUsers!.map((x) => x.toJson())),
    "homeTeamUsers": homeTeamUsers == null
        ? []
        : List<dynamic>.from(homeTeamUsers!.map((x) => x.toJson())),
    "awayTeamUsers": awayTeamUsers == null
        ? []
        : List<dynamic>.from(awayTeamUsers!.map((x) => x.toJson())),
    "statistics": statistics == null
        ? []
        : List<dynamic>.from(statistics!.map((x) => x.toJson())),
    "votes": votes == null
        ? []
        : List<dynamic>.from(votes!.map((x) => x.toJson())),
  };
}

/*class Match {
  String? id;
  DateTime? start;
  DateTime? end;
  DateTime? date;
  String? location;
  String? notes;
  String? leagueId;
  String? homeTeamName;
  String? awayTeamName;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Admin>? availableUsers;
  List<UserElement>? homeTeamUsers;
  List<UserElement>? awayTeamUsers;
  List<Vote>? votes;
  List<Statistic>? statistics;

  MatchStatus? status; // 🔹 Match status
  Score? score;        // 🔹 Match score

  Match({
    this.id,
    this.start,
    this.end,
    this.date,
    this.location,
    this.notes,
    this.leagueId,
    this.homeTeamName,
    this.awayTeamName,
    this.createdAt,
    this.updatedAt,
    this.availableUsers,
    this.homeTeamUsers,
    this.awayTeamUsers,
    this.votes,
    this.statistics,
    this.status,
    this.score,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    id: json["id"],
    start: json["start"] == null ? null : DateTime.parse(json["start"]),
    end: json["end"] == null ? null : DateTime.parse(json["end"]),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    location: json["location"],
    notes: json["notes"],
    leagueId: json["leagueId"],
    homeTeamName: json["homeTeamName"],
    awayTeamName: json["awayTeamName"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    availableUsers: json["availableUsers"] == null
        ? []
        : List<Admin>.from(
        json["availableUsers"]!.map((x) => Admin.fromJson(x))),
    homeTeamUsers: json["homeTeamUsers"] == null
        ? []
        : List<UserElement>.from(
        json["homeTeamUsers"]!.map((x) => UserElement.fromJson(x))),
    awayTeamUsers: json["awayTeamUsers"] == null
        ? []
        : List<UserElement>.from(
        json["awayTeamUsers"]!.map((x) => UserElement.fromJson(x))),
    votes: json["votes"] == null
        ? []
        : List<Vote>.from(json["votes"]!.map((x) => Vote.fromJson(x))),
    statistics: json["statistics"] == null
        ? []
        : List<Statistic>.from(
        json["statistics"]!.map((x) => Statistic.fromJson(x))),
    status: _statusFromString(json["status"]),
    score: json["score"] == null ? null : Score.fromJson(json["score"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start": start?.toIso8601String(),
    "end": end?.toIso8601String(),
    "location": location,
    "notes": notes,
    "leagueId": leagueId,
    "homeTeamName": homeTeamName,
    "awayTeamName": awayTeamName,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "availableUsers": availableUsers == null
        ? []
        : List<dynamic>.from(availableUsers!.map((x) => x.toJson())),
    "homeTeamUsers": homeTeamUsers == null
        ? []
        : List<dynamic>.from(homeTeamUsers!.map((x) => x.toJson())),
    "awayTeamUsers": awayTeamUsers == null
        ? []
        : List<dynamic>.from(awayTeamUsers!.map((x) => x.toJson())),
    "votes": votes == null
        ? []
        : List<dynamic>.from(votes!.map((x) => x.toJson())),
    "statistics": statistics == null
        ? []
        : List<dynamic>.from(statistics!.map((x) => x.toJson())),
    "status": _statusToString(status),
    "score": score?.toJson(),
  };

  static MatchStatus? _statusFromString(String? status) {
    switch (status) {
      case 'scheduled':
        return MatchStatus.scheduled;
      case 'in_progress':
        return MatchStatus.inProgress;
      case 'completed':
        return MatchStatus.completed;
      case 'cancelled':
        return MatchStatus.cancelled;
      default:
        return null;
    }
  }

  static String? _statusToString(MatchStatus? status) {
    switch (status) {
      case MatchStatus.scheduled:
        return 'scheduled';
      case MatchStatus.inProgress:
        return 'in_progress';
      case MatchStatus.completed:
        return 'completed';
      case MatchStatus.cancelled:
        return 'cancelled';
      default:
        return null;
    }
  }
}

enum MatchStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
}

class Score {
  final int home;
  final int away;

  Score({
    required this.home,
    required this.away,
  });

  factory Score.fromJson(Map<String, dynamic> json) => Score(
    home: json["home"] ?? 0,
    away: json["away"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "home": home,
    "away": away,
  };
}*/





class UserElement {
  String? id;
  String? firstName;
  String? lastName;
  String? displayName;
  String? position;
  PreferredFoot? preferredFoot;
  String? chemistryStyle;
  String? shirtNumber;
  AwayTeamUserAttributes? attributes;
  PictureKey? pictureKey;
  String? password;
  String? matchGuestForId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Statistic>? matchStatistics;

  UserElement({
    this.id,
    this.firstName,
    this.lastName,
    this.displayName,
    this.position,
    this.preferredFoot,
    this.chemistryStyle,
    this.shirtNumber,
    this.attributes,
    this.pictureKey,
    this.password,
    this.matchGuestForId,
    this.createdAt,
    this.updatedAt,
    this.matchStatistics,
  });

  factory UserElement.fromJson(Map<String, dynamic> json) => UserElement(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        displayName: json["displayName"],
        position: json["position"],
        preferredFoot: preferredFootValues.map[json["preferredFoot"]],
        chemistryStyle: json["chemistryStyle"],
        shirtNumber: json["shirtNumber"],
        attributes: json["attributes"] == null
            ? null
            : AwayTeamUserAttributes.fromJson(json["attributes"]),
        pictureKey: pictureKeyValues.map[json["pictureKey"]],
        password: json["password"],
        matchGuestForId: json["matchGuestForId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        matchStatistics: json["matchStatistics"] == null
            ? []
            : List<Statistic>.from(
                json["matchStatistics"]!.map((x) => Statistic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "displayName": displayName,
        "position": position,
        "preferredFoot": preferredFootValues.reverse[preferredFoot],
        "chemistryStyle": chemistryStyle,
        "shirtNumber": shirtNumber,
        "attributes": attributes?.toJson(),
        "pictureKey": pictureKeyValues.reverse[pictureKey],
        "password": password,
        "matchGuestForId": matchGuestForId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "matchStatistics": matchStatistics == null
            ? []
            : List<dynamic>.from(matchStatistics!.map((x) => x.toJson())),
      };
}

class AwayTeamUserAttributes {
  int? pace;
  int? passing;
  int? physical;
  int? shooting;
  int? defending;
  int? dribbling;
  int? speed;
  int? diving;
  int? kicking;
  int? handling;
  int? reflexes;
  int? positioning;

  AwayTeamUserAttributes({
    this.pace,
    this.passing,
    this.physical,
    this.shooting,
    this.defending,
    this.dribbling,
    this.speed,
    this.diving,
    this.kicking,
    this.handling,
    this.reflexes,
    this.positioning,
  });

  factory AwayTeamUserAttributes.fromJson(Map<String, dynamic> json) =>
      AwayTeamUserAttributes(
        pace: json["Pace"],
        passing: json["Passing"],
        physical: json["Physical"],
        shooting: json["Shooting"],
        defending: json["Defending"],
        dribbling: json["Dribbling"],
        speed: json["Speed"],
        diving: json["Diving"],
        kicking: json["Kicking"],
        handling: json["Handling"],
        reflexes: json["Reflexes"],
        positioning: json["Positioning"],
      );

  Map<String, dynamic> toJson() => {
        "Pace": pace,
        "Passing": passing,
        "Physical": physical,
        "Shooting": shooting,
        "Defending": defending,
        "Dribbling": dribbling,
        "Speed": speed,
        "Diving": diving,
        "Kicking": kicking,
        "Handling": handling,
        "Reflexes": reflexes,
        "Positioning": positioning,
      };
}

class Statistic {
  String? id;
  String? matchId;
  String? userId;
  int? value;
  Type? type;
  DateTime? createdAt;

  Statistic({
    this.id,
    this.matchId,
    this.userId,
    this.value,
    this.type,
    this.createdAt,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        id: json["id"],
        matchId: json["matchId"],
        userId: json["userId"],
        value: json["value"],
        type: typeValues.map[json["type"]]!,
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "matchId": matchId,
        "userId": userId,
        "value": value,
        "type": typeValues.reverse[type],
        "createdAt": createdAt?.toIso8601String(),
      };
}

enum Type { CLEAN_SHEETS, FREE_KICKS, GOALS_ASSISTED, GOALS_SCORED, PENALTIES }

final typeValues = EnumValues({
  "CleanSheets": Type.CLEAN_SHEETS,
  "FreeKicks": Type.FREE_KICKS,
  "GoalsAssisted": Type.GOALS_ASSISTED,
  "GoalsScored": Type.GOALS_SCORED,
  "Penalties": Type.PENALTIES
});

class Vote {
  String? id;
  String? matchId;
  String? forUserId;
  String? byUserId;
  DateTime? createdAt;

  Vote({
    this.id,
    this.matchId,
    this.forUserId,
    this.byUserId,
    this.createdAt,
  });

  factory Vote.fromJson(Map<String, dynamic> json) => Vote(
        id: json["id"],
        matchId: json["matchId"],
        forUserId: json["forUserId"],
        byUserId: json["byUserId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "matchId": matchId,
        "forUserId": forUserId,
        "byUserId": byUserId,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class Level {
  final int level;
  final int min;
  final int max;
  final String title;
  final String color;

  Level({
    required this.level,
    required this.min,
    required this.max,
    required this.title,
    required this.color,
  });
}
