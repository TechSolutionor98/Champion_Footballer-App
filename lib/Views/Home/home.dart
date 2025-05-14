import 'dart:async';
import 'package:champion_footballer/Views/Home/Screens/DashBoard/menuoptions.dart';
import 'package:champion_footballer/Views/Home/Screens/Stats/stats_screen.dart';
import 'package:champion_footballer/Views/Home/Screens/Tables/tablesscreen.dart';
import '../../Utils/packages.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      // developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  bool get isOffline => _connectionStatus.contains(ConnectivityResult.none);

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(bottomNavigationProvider);
    final navController = ref.read(bottomNavigationProvider.notifier);
    return ScaffoldCustom(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: StyledContainer(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: BottomNavigationBar(
              currentIndex: navState.tabIndex,
            onTap: (index) {
              navController.setTabIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: kPrimaryColor,
            selectedLabelStyle: const TextStyle(
                fontSize: 10,
                color: kdefwhiteColor,
                fontWeight: FontWeight.bold),
            selectedItemColor: kdefwhiteColor,
            unselectedItemColor: kdefwhiteColor,
            unselectedLabelStyle: const TextStyle(
              color: kdefwhiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 8,
            ),
            elevation: 8.0,
            items: const [
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/icons/home1.png")),
                label: 'Leagues',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/icons/home2.png")),
                label: 'Matches',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/icons/home3.png")),
                label: 'Table',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/icons/home4.png")),
                label: 'Add Stats',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/icons/home5.png")),
                label: 'Dashboard',
              ),
            ],
          ),
        ),
      ),
      body: isOffline
          ? const NoconnectionScreen()
          : PageView(
                controller: navState.pageController,
              onPageChanged: navController.setTabIndex,
              children: const [
                LeaguesScreen(),
                MatchesScreen(),
                TableScreen(),
                AddStatsScreen(),
                DashBoard(),
              ],
            ),
    );
  }
}
