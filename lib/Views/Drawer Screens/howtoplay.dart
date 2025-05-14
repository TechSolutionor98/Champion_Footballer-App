import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "How to Play",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(29.0),
        child: StyledContainer(
          padding: defaultPadding(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading 1
              Text(
                'Developing your Player Card',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
              ),

              RichText(
                text: TextSpan(
                  text:
                      "Player Card Will Be Set To Zero By Default After Registering To CF. It Is Advisable Players In The League Set Their",
                  style: TextStyle(
                    color: ktext2Color,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(
                      text: ' Player Card',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktextColor,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          height: 1.3,
                          fontSize: 16),
                    ),
                    TextSpan(
                      text: "  Before Being Added To A Match.\n\n",
                      style: TextStyle(
                        color: ktext2Color,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                        height: 1.3,
                      ),
                    ),
                    TextSpan(
                      text:
                          "To Set Your Play Card, Simply Use The Scrolling Bar To Set Your Skill Levels.\nAll Skill Levels Added To Your Player Card Are Important As They Will Determine Team Balance And Match Predictions.",
                      style: TextStyle(
                        color: ktext2Color,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Inter",
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              10.0.heightbox,

              Center(
                child: Image.asset(
                  AppImages.htp1,
                  fit: BoxFit.cover,
                  width: 250,
                ),
              ),
              20.0.heightbox,

              Text(
                'Create and Join Leagues',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      "You Can Create Or Join An Existing League To Participate In Playing Matches With Your Friends. If You Are Joining A League, Either Use An",
                  style: TextStyle(
                    color: ktext2Color,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(
                      text: ' invite code ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text: 'Or Use The',
                    ),
                    TextSpan(
                      text: ' Join League Hyperlink ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text: 'Into Your Browser.',
                    ),
                  ],
                ),
              ),
              10.0.heightbox,
              Center(
                child: Image.asset(
                  AppImages.htp2,
                  fit: BoxFit.cover,
                  width: 250,
                ),
              ),
              10.0.heightbox,
              RichText(
                text: TextSpan(
                  text: "If You Are Creating A New League, Click On The",
                  style: TextStyle(
                    color: ktext2Color,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(
                      text: ' Create New League ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text:
                          'Button On The Home Page. You Will Then Be Asked To Add A League Name. To Switched Between Multiple Leagues, Use The League',
                    ),
                    TextSpan(
                      text: ' Drop-Down Box.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                  ],
                ),
              ),

              10.0.heightbox,
              Center(
                child: Image.asset(
                  AppImages.htp3,
                  fit: BoxFit.cover,
                  width: 250,
                ),
              ),
              10.0.heightbox,
              RichText(
                text: TextSpan(
                  text:
                      "By Default, Once You Have Created A New League You Will Be Assigned As League",
                  style: TextStyle(
                    color: ktext2Color,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(
                      text: ' Admin ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text:
                          'The League Admin Will Be Given Full Control Over Selecting Teams, Creating New Matches And Adding In Match Scores. You Can Always Switch The League Admin Anytime With Another Player In The Same League By Going Through The League Setting Option.',
                    ),
                  ],
                ),
              ),
              10.0.heightbox,
              Center(
                child: Image.asset(
                  AppImages.htp4,
                  fit: BoxFit.cover,
                  width: 250,
                ),
              ),
              10.0.heightbox,
              Text(
                "In The League Setting As The League Admin, It Is Good Practice To Enter The Total Number Of Matches To Be Played In The League. Once You Have Reached The Maximum Number Of Games In The League, Virtual Awards Will Be Finalised On The Home Page.",
                style: TextStyle(
                  color: ktext2Color,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter",
                  height: 1.3,
                ),
              ),
              20.0.heightbox,

              // Heading 3
              Text(
                'Creating Matches and Selecting Teams',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      "As A League Admin You Can Create Matches And Select Teams.\n\n",
                  style: TextStyle(
                    color: ktext2Color,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(
                      text: 'To Create A New Match,',
                    ),
                    TextSpan(
                      text: ' Select Matches > ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text: 'Click On To',
                    ),
                    TextSpan(
                      text: ' Add New Match ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text: 'And Enter The Relevant Match Details',
                    ),
                    TextSpan(
                      text: ' > Save Match.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                        text:
                            'The New Match Will Be Visible To All Players In The League.'),
                    TextSpan(
                      text: '\n\n',
                    ),
                    TextSpan(
                      text:
                          'Players Can Select Their Availability To Play The Match By Logging In To Their Home Page > Click On To',
                    ),
                    TextSpan(
                      text: ' Matches > Mark Yourself As Available.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              10.0.heightbox,
              Center(
                child: Image.asset(
                  AppImages.htp5,
                  fit: BoxFit.cover,
                  width: 250,
                ),
              ),
              10.0.heightbox,
              RichText(
                text: TextSpan(
                  text: "To ",
                  style: TextStyle(
                    color: ktext2Color,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(
                      text: 'Select Teams, ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text:
                          'Players That Have Made Themselves Available To Play The Match Will Appear In Real-Time. League Admin Can Select The Teams By Going Into',
                    ),
                    TextSpan(
                      text: ' Matches > Edit Match ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text: 'And From The.',
                    ),
                    TextSpan(
                      text: ' Choose Out Of These Players ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text: 'List To Select Teams.',
                    ),
                  ],
                ),
              ),

              20.0.heightbox,

              // Heading 4
              Text(
                'League Table',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      "Once A Match Has Been Played And Scores Has Been Uploaded By The League Admin, Players On The",
                  style: TextStyle(
                    color: ktext2Color,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(
                      text: ' Winning ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text:
                          'As Players Play Their Matches, Their Points, Goals, Assists, And Rebounds Will Be Taken Into Account In The League Table.',
                    ),
                    TextSpan(
                      text:
                          'Team Will Be Allocated 3 Points And 1 For Drawing. All Players Can View Match Results. The Player With The Most Matches Won In A League Becomes The',
                    ),
                    TextSpan(
                      text: ' Champion Footballer.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text: '\n\n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text:
                          'You Can Track Each Player’s Game Stats By Clicking Onto Player Name From League Table.',
                    ),
                  ],
                ),
              ),

              10.0.heightbox,

              Center(
                child: Image.asset(
                  AppImages.htp6,
                  fit: BoxFit.cover,
                  width: 250,
                ),
              ),
              20.0.heightbox,

              Text(
                'Awards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      "After Each Match, Players Can Select Their Player Of The Match. You Can Do This By Going Into",
                  style: TextStyle(
                    color: ktext2Color,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(
                      text: ' Matches > ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ktext2Color,
                          letterSpacing: 0.5,
                          fontFamily: "Inter",
                          fontSize: 16),
                    ),
                    TextSpan(
                      text:
                          'Click On To The Match You Have Played > Scroll Down To Where You Are Able To View The Teams > Vote Your MOTM By Clicking On To The Player.',
                    ),
                  ],
                ),
              ),
              20.0.heightbox,
              Text(
                'League Admin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
              ),
              Text(
                "League Admin Will Have A Slightly Different View On Champion Football To The Rest Of The Players In The League. League Admin Can Be Interchangeable Between League Players.\n\nThe League Admin Will Act As The League Manager And Will Be Passed On The Responsibility To Keep The League Running By Creating Matches, Selecting Teams, Adding Scores.\n\nThe League Admin Can Alter Changes To The League Such As League/Team Names, Number Of Games To Be Played And Adding Guest Players To Matches.",
                style: TextStyle(
                  color: ktext2Color,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter",
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
