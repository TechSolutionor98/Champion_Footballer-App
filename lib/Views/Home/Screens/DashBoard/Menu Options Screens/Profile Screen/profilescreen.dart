import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';

import '../../../../../../Model/Api Models/usermodel.dart';
import '../../../../../../Services/RiverPord Provider/ref_provider.dart';

class PlayerProfileScreen extends StatelessWidget {
  const PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer(builder: (context, ref, _) {
      final userAsync = ref.watch(userDataProvider);
      return userAsync.when(
        data: (user) {
          final dribbling = user.attributes?.dribbling ?? 0;
          final levelInfo = getSkillLevelAndColor(dribbling);

          final shooting = user.attributes?.shooting ?? 0;
          final shootingInfo = getSkillLevelAndColor(shooting);
          final passing = user.attributes?.passing ?? 0;
          final passingInfo = getSkillLevelAndColor(passing);
          final pace = user.attributes?.pace ?? 0;
          final paceInfo = getSkillLevelAndColor(pace);
          final defending = user.attributes?.defending ?? 0;
          final defendingInfo = getSkillLevelAndColor(defending);
          final physical = user.attributes?.physical ?? 0;
          final physicalInfo = getSkillLevelAndColor(physical);

          return ScaffoldCustom(
            appBar: CustomAppBar(
              titleText: "Profile",
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(229, 106, 22, 1),
                  Color.fromRGBO(207, 35, 38, 1),
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: defaultPadding(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            10.0.heightbox,
                            _buildField(
                                "Name", "${user.firstName} ${user.lastName}"),
                            _buildField("Age", "${user.age}"),
                            _buildField("Email", user.email ?? "N/A"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              "Profile Pic",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: ktextColor,
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kdefwhiteColor,
                                border: Border.all(
                                  color: ktexfieldborderColor,
                                  width: 2,
                                ),
                              ),
                              padding: EdgeInsets.all(3),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: (user.pictureKey != null && user.pictureKey!.isNotEmpty)
                                    ? Image.network(
                                        user.pictureKey!,
                                        fit: BoxFit.cover,
                                        width: double.infinity, 
                                        height: double.infinity,
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                  : null,
                                              strokeWidth: 2,
                                            ),
                                          );
                                        },
                                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                          print("Error loading profile image in ProfileScreen: $error");
                                          return Icon(Icons.person, size: 40, color: Colors.grey[400]);
                                        },
                                      )
                                    : Icon(Icons.person, size: 40, color: Colors.grey[400]),
                              ),
                            ),
                            8.0.heightbox,
                            GestureDetector(
                              onTap: () {
                                context.route(EditProfileScreen());
                              },
                              child: Container(
                                padding:
                                    defaultPadding(vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF0388E3),
                                      Color(0xFF024B7D)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kdefwhiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  10.0.heightbox,
                  _buildFieldSpaced("Position Type", user.positionType ?? "N/A"),
                  _buildFieldSpaced("Position", user.position ?? "N/A"),
                  _buildFieldSpaced("Playing Style", user.chemistryStyle ?? "N/A"),
                  _buildFieldSpaced(
                      "Preferred Foot", user.preferredFoot?.name ?? "N/A"),
                  _buildFieldSpaced(
                      "Shirt Number", user.shirtNumber?.toString() ?? "N/A"),
                  _buildAttribute("Dribbling (DRI)", dribbling,
                      levelInfo["level"], levelInfo["color"]),
                  _buildAttribute("Shooting (SHO)", shooting,
                      shootingInfo["level"], shootingInfo["color"]),
                  _buildAttribute("Passing (PAS)", passing,
                      passingInfo["level"], passingInfo["color"]),
                  _buildAttribute(
                      "Pace (PAC)", pace, paceInfo["level"], paceInfo["color"]),
                  _buildAttribute("Defending (DEF)", defending,
                      defendingInfo["level"], defendingInfo["color"]),
                  _buildAttribute("Physical (PHY)", physical,
                      physicalInfo["level"], physicalInfo["color"]),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: ${err.toString()}")),
      );
    });
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: ktextColor,
              ),
            ),
          ),

          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kdefwhiteColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: kdefgreyColor.withValues(alpha: .5),
                  width: 1.5,
                ),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: ktexthintColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildFieldSpaced(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        SizedBox(
          width: 180,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: ktextColor,
            ),
          ),
        ),

        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kdefwhiteColor,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: kdefgreyColor.withValues(alpha: .5),
                width: 1.5,
              ),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: ktexthintColor,
                fontWeight: FontWeight.w500,
              ),
              // softWrap: true, // Default, text should wrap
              // overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildAttribute(String title, int value, String level, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: ktextColor,
              ),
            ),
          ),
          Text(
            "$value ",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: color,
            ),
          ),
          Text(
            level,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> getSkillLevelAndColor(int value) {
    if (value >= 85) {
      return {
        "level": "Elite",
        "color": Color(0xFFEF444C),
      };
    } else if (value >= 70) {
      return {
        "level": "Professional",
        "color": Color(0xFF3B82F6),
      };
    } else {
      return {
        "level": "Amateur",
        "color": Color(0xFF0D9601),
      };
    }
  }
}
