import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      appBar: CustomAppBar(titleText: "About CF"),
      body: SingleChildScrollView(
        padding: defaultPadding(vertical: 10),
        child: Column(
          children: [
            StyledContainer(
              boxShadow: [],
              borderColor: kPrimaryColor.withValues(alpha: .5),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CF helps organise and records your football matches including number of games won, lost and goals scored when playing football matches with your friends. It’s a free service which allows you to connect your passion for football with other football enthusiast.\n\nCF can be used for all occasions, whether playing a 5 or 7 aside football matches on an artificial pitch, weekend kick around at the park or playing in your local “cage” to showcase your lethal ball skills. Why not make it rewarding and competitive!\n\nCF platform provides user friendly features to easily arrange football matches with your friends. Including; adding date/time, location of match and picking teams from a real-time player availability list.\n\nOn CF you can have fun in setting up your player card, arrange a series of matches, mix up the teams every time you play and see who comes up on top with the greatest number of wins!\n\nAfter each match is played, you can go ahead and rate your best player on the pitch and win virtual awards.\n\nCF can help you have fun playing the world’s most loved sport, providing you with a unique experience that connects football fans all around the world. It’s a fun way to bring social media experience and playing football together!.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ktextColor,
                    ),
                  ),
                  10.0.heightbox,
                  Text(
                    'Become Champion Footballer!',
                    style: TextStyle(
                        fontSize: 18,
                        color: ktextColor,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  10.0.heightbox,
                  Text(
                    'CF is for everyone at all playing levels, who would like to relish the chance to become their local champion! Sign-up now to join an existing league or create a new league/group and invite your friends to play.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ktextColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            20.0.heightbox,
          ],
        ),
      ),
    );
  }
}
