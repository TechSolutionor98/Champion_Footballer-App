import 'package:toastification/toastification.dart';
import '../../../../../../Services/RiverPord Provider/ref_provider.dart';
import '../../../../../../Utils/packages.dart';

class LeagueSetting extends ConsumerStatefulWidget {
  const LeagueSetting({super.key});

  @override
  ConsumerState<LeagueSetting> createState() => _LeagueSettingsState();
}

class _LeagueSettingsState extends ConsumerState<LeagueSetting> {
  bool _isSaving = false;
  String? _errorMessage;
  List<_LeaguePlayerDisplay> _leaguePlayersDisplayList = [];

  @override
  void initState() {
    super.initState();

    final selectedLeague = ref.read(selectedLeagueProvider);
    if (selectedLeague?.members != null) {
      _leaguePlayersDisplayList = selectedLeague!.members!.map((m) {
        String name = "${m.firstName ?? ''} ${m.lastName ?? ''}".trim();
        if (name.isEmpty) name = m.id ?? "Unknown";
        return _LeaguePlayerDisplay(
          id: m.id!,
          name: name,
          isAdmin: false,
        );
      }).toList();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshLeague();
    });
  }

  Future<void> _refreshLeague() async {
    final selectedLeague = ref.read(selectedLeagueProvider);
    if (selectedLeague == null || selectedLeague.id == null) {
      setState(() => _errorMessage = "No league selected.");
      return;
    }

    final leagueSettingsData =
    await ref.read(leagueSettingsProvider(selectedLeague.id!).future);

    if (leagueSettingsData == null) return;

    final adminIds =
        leagueSettingsData.administrators?.map((a) => a.id).toSet() ?? <String>{};

    setState(() {
      _leaguePlayersDisplayList = leagueSettingsData.members?.map((m) {
        String name = "${m.firstName ?? ''} ${m.lastName ?? ''}".trim();
        if (name.isEmpty) name = m.id ?? "Unknown";
        return _LeaguePlayerDisplay(
          id: m.id!,
          name: name,
          isAdmin: adminIds.contains(m.id),
        );
      }).toList() ??
          [];
    });
  }

  Future<void> _removePlayer(_LeaguePlayerDisplay player) async {
    await Future.delayed(const Duration(seconds: 1));
    toastification.show(
      context: context,
      title: Text("${player.name} would have been removed (simulated)"),
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final league = ref.read(selectedLeagueProvider);

    return ScaffoldCustom(
      appBar: CustomAppBar(
        titleText: "Setting",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1),
            Color.fromRGBO(207, 35, 38, 1),
          ],
        ),
      ),
      body: _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : _leaguePlayersDisplayList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: defaultPadding(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Center(
              child: Text(
                "League Players",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade100,
                    Colors.green.shade400,
                    Colors.green.shade100,
                  ],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // ✅ Player List
            StyledContainer(
              padding: const EdgeInsets.all(10),
              boxShadow: [],
              borderColor: kPrimaryColor.withOpacity(.5),
              child: _leaguePlayersDisplayList.isEmpty
                  ? const Center(
                child: Text(
                  "No players in this league yet.",
                  style: TextStyle(fontSize: 12),
                ),
              )
                  : Column(
                children: _leaguePlayersDisplayList
                    .asMap()
                    .entries
                    .map((entry) {
                  final player = entry.value;
                  final isLast = entry.key ==
                      _leaguePlayersDisplayList.length - 1;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              player.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: player.isAdmin
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (player.isAdmin)
                            const Text(
                              "League Admin",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: () =>
                                  _removePlayer(player),
                              child: Image.asset(
                                "assets/icons/delete.png",
                                width: 22,
                                height: 22,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                      if (!isLast)
                        Divider(
                          color: Colors.grey.shade200,
                          thickness: 2,
                          height: 20,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Leave this league",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            // ✅ Leave Button (small height)
            SizedBox(
              height: 23,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kredColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () async {
                  if (league == null || league.id == null) return;

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Leave League?"),
                      content: Text(
                          "Are you sure you want to leave '${league.name}'?"),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(true),
                          child: const Text(
                            "Leave",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await leaveLeague(
                        ref: ref, leagueId: league.id!);
                  }
                },
                child: Text(
                  "Leave ${league?.name ?? "League"}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaguePlayerDisplay {
  final String id;
  final String name;
  final bool isAdmin;

  _LeaguePlayerDisplay({
    required this.id,
    required this.name,
    required this.isAdmin,
  });
}
