import 'package:champion_footballer/Services/RiverPord%20Provider/logoutptovider.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/aboutus.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/contactus.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/gamerules.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/howtoplay.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/privacypolicy.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/terms_condtion.dart';
import 'package:champion_footballer/Views/Profile%20Making%20Screen/profilemakingscreen.dart';
import '../../Utils/packages.dart';

class StartPage extends ConsumerWidget {
  StartPage({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void showBackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: kdefwhiteColor),
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Are you sure?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kdefblackColor,
                      ),
                    ),
                  ],
                ),
                10.0.heightbox,
                const Text('Do you want to exit the App?'),
                20.0.heightbox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              color: kdefwhiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: kdefwhiteColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kdefgreyColor),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(
                              color: kdefgreyColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        showBackDialog(context);
        return;
      },
      child: ScaffoldCustom(
        scaffoldKey: scaffoldKey,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          foregroundColor: kdefwhiteColor,
          toolbarHeight: 50,
          title: Image.asset("assets/icons/appbarlogo.png", width: 220),
          centerTitle: true,

          leading: GestureDetector(
            onTap: () {
              if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
                scaffoldKey.currentState?.closeDrawer();
              } else {
                scaffoldKey.currentState?.openDrawer();
              }
            },
            child: Icon(
              Icons.more_vert,
              size: 20,
            ),
          ),
          // actions: [
          //   //menu icon
          //   Padding(
          //     padding: const EdgeInsets.only(right: 8.0),
          //     child: GestureDetector(
          //       onTap: () {
          //         context.route(MenuOptions());
          //       },
          //       child: Icon(Icons.more_vert),
          //     ),
          //   ),
          // ],
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: defaultPadding(),
                child: Image.asset(
                  AppImages.logo,
                  width: 150,
                ),
              ),
              20.0.heightbox,

              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade100,
                      Colors.green.shade700,
                      Colors.green.shade100,
                    ],
                    stops: [0.0, 0.5, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),

              20.0.heightbox,
              GestureDetector(
                onTap: () {
                  context.route(HowToPlayScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.info,
                      fit: BoxFit.contain,
                      width: 15,
                      height: 15,
                    ),
                    10.0.widthbox,
                    Text(
                      'How To Play',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              20.0.heightbox,
              GestureDetector(
                onTap: () {
                  context.route(GameRulesScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.rule,
                      fit: BoxFit.contain,
                      width: 15,
                      height: 15,
                    ),
                    20.0.widthbox,
                    Text(
                      'Game Rules',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              20.0.heightbox,
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade100,
                      Colors.green.shade700,
                      Colors.green.shade100,
                    ],
                    stops: [0.0, 0.5, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              20.0.heightbox,
              GestureDetector(
                onTap: () {
                  context.route(TermsAndConditionsScreen());
                },
                child: Text(
                  'Term & Conditions',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              20.0.heightbox,
              GestureDetector(
                onTap: () {
                  context.route(PrivacyPolicy());
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              20.0.heightbox,
              GestureDetector(
                onTap: () {
                  context.route(ContactUsScreen());
                },
                child: Text(
                  'Contact Us',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              20.0.heightbox,
              GestureDetector(
                onTap: () {
                  context.route(AboutUs());
                },
                child: Text(
                  'About Us',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              20.0.heightbox,
              GestureDetector(
                onTap: () async {
                  final logout = ref.read(logoutProvider);
                  await logout.logout(context);
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              // Button at the end
              20.0.heightbox,
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .3),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      )
                    ],
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(9),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF00D09F), Color(0xFF00785C)],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Join League",
                      style: TextStyle(
                          color: kdefwhiteColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: defaultPadding(vertical: 10),
          child: Column(
            children: [
              Container(
                height: context.height * 0.85,
                padding: defaultPadding(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/dashback1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: context.height * 0.31,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/card.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                10.0.heightbox,
                                Text(
                                  'NO.00',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kdefwhiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                10.0.heightbox,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '00',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: kdefwhiteColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),

                                        Container(
                                          width: 25,
                                          height: 1,
                                          color: kdefwhiteColor,
                                        ),

                                        Text(
                                          'XXX',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: kdefwhiteColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        //add a container as divider here
                                        Container(
                                          width: 25,
                                          height: 1,
                                          color: kdefwhiteColor,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/foot.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                            5.0.widthbox,
                                            Text(
                                              'R',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: kdefwhiteColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    40.0.widthbox,
                                    Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: kdefwhiteColor,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.asset(
                                              'assets/images/editpic.png',
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                10.0.heightbox,
                                Text(
                                  'WAQAR'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kdefwhiteColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'level'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kdefwhiteColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                5.0.heightbox,
                                Container(
                                  width: 60,
                                  height: 1,
                                  color: kdefwhiteColor,
                                ),
                                10.0.heightbox,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '00 DRI',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: kdefwhiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '00 SHO',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: kdefwhiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '00 PAS',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: kdefwhiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    10.0.widthbox,
                                    Container(
                                      width: 1.5,
                                      height: 30,
                                      color: kdefwhiteColor,
                                    ),
                                    10.0.widthbox,
                                    Column(
                                      children: [
                                        Text(
                                          '00 PAC',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: kdefwhiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '00 DEF',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: kdefwhiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '00 PHY',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: kdefwhiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                10.0.heightbox,
                                Container(
                                  width: 30,
                                  height: 1,
                                  color: kdefwhiteColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.0.heightbox,
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Welcome, ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ktextColor,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Waqar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ktextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          10.0.heightbox,
                          Container(
                            height: 2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade100,
                                  Colors.green.shade300,
                                  Colors.green.shade100,
                                ],
                                stops: [0.0, 0.5, 1.0],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                          10.0.heightbox,
                          Text(
                            "You haven't setup your Player Card yet.Let's Create that!",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: ktextColor),
                            textAlign: TextAlign.center,
                          ),
                          8.0.heightbox,
                          GestureDetector(
                            onTap: () {
                              context.route(PlayerMakingScreen());
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kPrimaryColor,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Create Player Card',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kdefwhiteColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  8.0.widthbox,
                                  Image.asset(
                                    "assets/icons/edit.png",
                                    width: 15,
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
