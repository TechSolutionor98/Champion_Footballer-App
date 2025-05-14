// ignore_for_file: use_build_context_synchronously

import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/aboutus.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/contactus.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/gamerules.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/howtoplay.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/privacypolicy.dart';
import 'package:champion_footballer/Views/Drawer%20Screens/terms_condtion.dart';
import 'package:champion_footballer/Widgets/buttonwithicon.dart';
import 'package:champion_footballer/Widgets/secondarytextfield.dart';
import 'package:toastification/toastification.dart';

import '../../Controllers/profileprovider.dart';
import '../../Model/Api Models/createleague_model.dart';
import '../../Model/Api Models/joinleagueinvite_model.dart';
import '../../Services/RiverPord Provider/logoutptovider.dart';
import '../../Services/RiverPord Provider/ref_provider.dart';
import '../../Utils/packages.dart';

class DashboardScreen2 extends ConsumerStatefulWidget {
  const DashboardScreen2({super.key});
  @override
  ConsumerState<DashboardScreen2> createState() => _DashboardScreen2State();
}

class _DashboardScreen2State extends ConsumerState<DashboardScreen2> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // void _showJoinLeagueDialog() {
  //   final inviteCodeController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierColor: Colors.black.withValues(alpha: 0.6), // Dimmed background
  //     builder: (context) {
  //       return Dialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //         child: Stack(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(20),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(
  //                     "Enter Invite Code",
  //                     style: TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.bold,
  //                         color: kPrimaryColor),
  //                   ),
  //                   16.0.heightbox,
  //                   PrimaryTextField(
  //                     controller: inviteCodeController,
  //                     hintText: "Invite Code",
  //                   ),
  //                   20.0.heightbox,
  //                   PrimaryButton(
  //                     buttonText: "Join League",
  //                     fontSize: 12,
  //                     width: context.width * 0.4,
  //                     onPressFunction: () async {
  //                       final code = inviteCodeController.text.trim();
  //                       if (code.isEmpty) {
  //                         toastification.show(
  //                           context: context,
  //                           type: ToastificationType.error,
  //                           style: ToastificationStyle.fillColored,
  //                           title: const Text("Invite code is required"),
  //                         );
  //                         return;
  //                       }

  //                       Navigator.pop(context);

  //                       final prefs = await SharedPreferences.getInstance();
  //                       final token = prefs.getString('auth_token') ?? '';

  //                       final request =
  //                           JoinLeagueRequest(inviteCode: code, token: token);
  //                       try {
  //                         final success = await ref
  //                             .read(joinLeagueProvider(request).future);
  //                         if (success) {
  //                           toastification.show(
  //                             context: context,
  //                             type: ToastificationType.success,
  //                             style: ToastificationStyle.fillColored,
  //                             title: const Text("Joined league successfully"),
  //                           );
  //                         } else {
  //                           toastification.show(
  //                             context: context,
  //                             type: ToastificationType.error,
  //                             style: ToastificationStyle.fillColored,
  //                             title: const Text("Failed to join league"),
  //                           );
  //                         }
  //                       } catch (e) {
  //                         toastification.show(
  //                           context: context,
  //                           type: ToastificationType.error,
  //                           style: ToastificationStyle.fillColored,
  //                           title: Text("Error: ${e.toString()}"),
  //                         );
  //                       }
  //                     },
  //                   )
  //                 ],
  //               ),
  //             ),

  //             // Close (X) button
  //             Positioned(
  //               right: 8,
  //               top: 6,
  //               child: GestureDetector(
  //                 onTap: () => Navigator.of(context).pop(),
  //                 child: CircleAvatar(
  //                   radius: 10,
  //                   backgroundColor: kPrimaryColor.withValues(alpha: 0.8),
  //                   child: Icon(Icons.close, size: 14, color: kdefwhiteColor),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  void _showJoinLeagueDialog() {
    final inviteCodeController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // prevent dismiss while loading
      barrierColor: Colors.black.withValues(alpha: .6),
      builder: (context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Enter Invite Code",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        16.0.heightbox,
                        PrimaryTextField(
                          controller: inviteCodeController,
                          hintText: "Invite Code",
                          enablestate: !isLoading,
                        ),
                        20.0.heightbox,
                        // if loading, show spinner, else show button
                        if (isLoading)
                          const CircularProgressIndicator()
                        else
                          PrimaryButton(
                            buttonText: "Join League",
                            fontSize: 12,
                            width: context.width * 0.4,
                            onPressFunction: () async {
                              final code = inviteCodeController.text.trim();
                              if (code.isEmpty) {
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.error,
                                  style: ToastificationStyle.fillColored,
                                  title: const Text("Invite code is required"),
                                );
                                return;
                              }

                              // start loading
                              setState(() => isLoading = true);

                              final prefs =
                                  await SharedPreferences.getInstance();
                              final token = prefs.getString('auth_token') ?? '';
                              final request = JoinLeagueRequest(
                                  inviteCode: code, token: token);

                              try {
                                final success = await ref
                                    .read(joinLeagueProvider(request).future);
                                Navigator.pop(context); // close the dialog
                                toastification.show(
                                  context: context,
                                  type: success
                                      ? ToastificationType.success
                                      : ToastificationType.error,
                                  style: ToastificationStyle.fillColored,
                                  title: Text(
                                    success
                                        ? "Joined league successfully"
                                        : "Failed to join league",
                                  ),
                                );
                              } catch (e) {
                                Navigator.pop(context);
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.error,
                                  style: ToastificationStyle.fillColored,
                                  title: Text("Error: ${e.toString()}"),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  ),

                  // Close (X) button — only when not loading
                  if (!isLoading)
                    Positioned(
                      right: 8,
                      top: 6,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: kPrimaryColor.withValues(alpha: .8),
                          child: Icon(Icons.close,
                              size: 14, color: kdefwhiteColor),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
  Widget build(BuildContext context) {
    final cardAttrStyle = TextStyle(
      fontSize: 10,
      color: kdefwhiteColor,
      fontWeight: FontWeight.w600,
    );

    final userAsync = ref.watch(userDataProvider);
    final profileNotifier = ref.read(profileProvider.notifier);
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
                onTap: _showJoinLeagueDialog,
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
              Center(
                  child: Container(
                      height: context.height * 0.58,
                      padding: defaultPadding(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/dashback1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(children: [
                        userAsync.when(
                            loading: () => SizedBox(
                                  height: context.height * .15,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                            error: (err, _) => SizedBox(
                                  height: context.height * 0.15,
                                  child: Center(child: Text("Failed to load")),
                                ),
                            data: (user) {
                              final attributes = user.attributes;
                              final attrList = [
                                attributes?.pace,
                                attributes?.shooting,
                                attributes?.passing,
                                attributes?.defending,
                                attributes?.dribbling,
                                attributes?.physical,
                              ].whereType<int>().toList();

                              final avgCRX = attrList.isNotEmpty
                                  ? (attrList.reduce((a, b) => a + b) /
                                          attrList.length)
                                      .round()
                                  : 0;
                              final footLetter = user.preferredFoot?.name
                                      .substring(0, 1)
                                      .toUpperCase() ??
                                  "-";

                              return Container(
                                height: context.height * 0.32,
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
                                            "NO. ${user.shirtNumber ?? "--"}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: kdefwhiteColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          10.0.heightbox,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    '$avgCRX',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: kdefwhiteColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),

                                                  Container(
                                                    width: 25,
                                                    height: 1,
                                                    color: kdefwhiteColor,
                                                  ),
                                                  Text(
                                                    'CRX',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: kdefwhiteColor,
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                        footLetter,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: kdefwhiteColor,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              40.0.widthbox,
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      profileNotifier
                                                          .showOptions(
                                                              ref.context, ref);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color:
                                                                kdefwhiteColor,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: user.pictureKey !=
                                                                null
                                                            ? Image.network(
                                                                'https://api.championfootballer.com/uploads/${user.pictureKey}',
                                                                height: 40,
                                                                width: 40,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder: (context,
                                                                        error,
                                                                        stackTrace) =>
                                                                    Icon(
                                                                        Icons
                                                                            .person,
                                                                        size:
                                                                            40,
                                                                        color: Colors
                                                                            .white),
                                                              )
                                                            : Icon(Icons.person,
                                                                size: 40,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          10.0.heightbox,
                                          Text(
                                            user.firstName!.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: kdefwhiteColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            (user.chemistryStyle ?? '')
                                                .toUpperCase(),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                      "DRI ${attributes!.dribbling}",
                                                      style: cardAttrStyle),
                                                  Text(
                                                      "SHO ${attributes.shooting}",
                                                      style: cardAttrStyle),
                                                  Text(
                                                      "PAS ${attributes.passing}",
                                                      style: cardAttrStyle),
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
                                                  Text("PAC ${attributes.pace}",
                                                      style: cardAttrStyle),
                                                  Text(
                                                      "DEF ${attributes.defending}",
                                                      style: cardAttrStyle),
                                                  Text(
                                                      "PHY ${attributes.physical}",
                                                      style: cardAttrStyle),
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
                              );
                            }),
                        60.0.heightbox,
                        userAsync.when(
                            loading: () => SizedBox(
                                  height: context.height * 0.32,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                            error: (err, _) => SizedBox(
                                  height: context.height * 0.32,
                                  child: Center(child: Text("Failed to load")),
                                ),
                            data: (user) {
                              return Container(
                                  padding: defaultPadding(vertical: 10),
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
                                              text: user.firstName,
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
                                        "Your Current League in which you stand.",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: ktextColor),
                                        textAlign: TextAlign.center,
                                      ),
                                      8.0.heightbox,
                                      // Show first joined league (or message if empty)
                                      if (user.leaguesJoined!.isNotEmpty)
                                        GestureDetector(
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                            );
                                            await Future.delayed(const Duration(
                                                milliseconds: 500));
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                            ref
                                                    .read(selectedLeagueProvider
                                                        .notifier)
                                                    .state =
                                                user.leaguesJoined!.first;
                                            context
                                                .route(const MatchesScreen());
                                          },
                                          child: StyledContainer(
                                            padding:
                                                defaultPadding(vertical: 10),
                                            backgroundColor: kPrimaryColor,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/home1.png",
                                                  width: 15,
                                                  height: 15,
                                                ),
                                                10.0.widthbox,
                                                Text(
                                                  user.leaguesJoined!.first
                                                      .name!
                                                      .trim(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: kdefwhiteColor,
                                                  ),
                                                ),
                                                10.0.widthbox,
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: kdefwhiteColor,
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      else
                                        Text(
                                          "You haven’t joined any league yet.",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ));
                            })
                      ]))),
              20.0.heightbox,
              Form(
                key: formKey,
                child: Container(
                  height: context.height * 0.32,
                  padding: defaultPadding(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Colors.black26)
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/dashback2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      5.0.heightbox,
                      ButtonWithIcon(
                          buttonText: "Create New League",
                          leadingWidget: Image.asset(
                            AppImages.plus,
                            width: 15,
                            height: 15,
                            color: kdefwhiteColor,
                          ),
                          buttonColor: kblueColor,
                          onPressFunction: () {
                            final leagueNameController =
                                TextEditingController();
                            showDialog(
                              context: context,
                              builder: (context) {
                                CreateLeagueRequest? lastRequest;
                                return Consumer(builder: (context, ref, _) {
                                  final isLoading = lastRequest != null
                                      ? ref
                                          .watch(createLeagueProvider(
                                              lastRequest!))
                                          .isLoading
                                      : false;

                                  void createLeague() async {
                                    final name =
                                        leagueNameController.text.trim();
                                    if (name.isEmpty) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.error,
                                        style: ToastificationStyle.fillColored,
                                        title: const Text(
                                            "League name is required"),
                                      );
                                      return;
                                    }

                                    final request =
                                        CreateLeagueRequest(name: name);
                                    lastRequest = request;

                                    try {
                                      await ref.read(
                                          createLeagueProvider(request).future);
                                      if (!context.mounted) return;

                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.success,
                                        style: ToastificationStyle.fillColored,
                                        title: const Text(
                                            "League created successfully"),
                                      );

                                      Navigator.pop(context); // close dialog
                                      // Optionally refresh league list here using ref.invalidate(...)
                                    } catch (e) {
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.error,
                                        style: ToastificationStyle.fillColored,
                                        title: Text(e.toString()),
                                      );
                                    }
                                  }

                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: StyledContainer(
                                      padding: defaultPadding(vertical: 10),
                                      boxShadow: [],
                                      borderColor:
                                          kPrimaryColor.withValues(alpha: .2),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              24.0.widthbox,
                                              Text(
                                                "Create a League",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Inter",
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () =>
                                                    Navigator.pop(context),
                                                child: Container(
                                                    padding: EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          Colors.grey.shade200,
                                                    ),
                                                    child: Text(
                                                      String.fromCharCode(Icons
                                                          .close.codePoint),
                                                      style: TextStyle(
                                                        fontFamily: Icons
                                                            .close.fontFamily,
                                                        package: Icons
                                                            .close.fontPackage,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kdefblackColor,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                          5.0.heightbox,
                                          Container(
                                            height: 1,
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
                                          // League Name Field
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "League Name",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: ktextColor,
                                              ),
                                            ),
                                          ),
                                          6.0.heightbox,
                                          PrimaryTextField(
                                            hintText: "",
                                            bordercolor: ktextColor.withValues(
                                                alpha: .4),
                                            controller: leagueNameController,
                                          ),
                                          16.0.heightbox,

                                          // Create League Button
                                          SizedBox(
                                            width: context.width / 2.5,
                                            child: isLoading
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : PrimaryButton(
                                                    buttonText: 'Create League',
                                                    fontSize: 12,
                                                    onPressFunction: () {
                                                      createLeague();
                                                    },
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                            );
                          }),
                      30.0.heightbox,
                      GestureDetector(
                        onTap: _showJoinLeagueDialog,
                        child: Stack(
                          children: [
                            SecondaryTextField(
                              hintText: 'Enter Invite Code',
                              hintfontSize: 14,
                              onChanged: (p0) {},
                              radius: BorderRadius.circular(6),
                              enabledfield: false,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      AppImages.add,
                                      width: 20,
                                      height: 20,
                                      color: kdefwhiteColor,
                                    ),
                                    6.0.widthbox,
                                    Text(
                                      "Join League",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: kdefwhiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.0.heightbox,
                      Text(
                        'Create new or join a league to make the most of Champion Footballer.',
                        style: TextStyle(
                          fontSize: 12,
                          color: kdefwhiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      20.0.heightbox,
                      PrimaryButton(
                        buttonText: "Continue To DashBoard",
                        onPressFunction: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );

                          // Delay slightly to allow UI update
                          await Future.delayed(
                              const Duration(milliseconds: 500));

                          // Remove loading dialog
                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          // Set the bottom navigation index to Dashboard
                          ref
                              .read(bottomNavigationProvider.notifier)
                              .setTabIndex(4);

                          // Navigate to Dashboard screen
                          context.route(Home());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              10.0.heightbox,
            ],
          ),
        ),
      ),
    );
  }
}
