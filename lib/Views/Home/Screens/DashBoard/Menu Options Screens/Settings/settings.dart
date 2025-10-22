import 'package:champion_footballer/Model/Api%20Models/league_settings_model.dart';
import 'package:champion_footballer/Model/Api%20Models/usermodel.dart'; // For LeaguesJoined
import 'package:champion_footballer/Services/RiverPord%20Provider/ref_provider.dart';
import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

class _DropdownDisplayItem {
  final String id;
  final String name;
  _DropdownDisplayItem({required this.id, required this.name});
}

class _LeaguePlayerDisplay {
  final String id;
  final String name;
  final bool isAdmin;
  _LeaguePlayerDisplay({required this.id, required this.name, required this.isAdmin});
}

class LeagueSettings extends ConsumerStatefulWidget {
  const LeagueSettings({super.key});

  @override
  ConsumerState<LeagueSettings> createState() => LeagueSettingsState();
}

class LeagueSettingsState extends ConsumerState<LeagueSettings> {
  String? _selectedAdminId;
  late TextEditingController _leagueNameController;
  late TextEditingController _maxMatchesController;
  String _leagueNameDisplay = "Loading League...";
  String _inviteCodeDisplay = "N/A";
  String _selectedStatus = "Active";
  bool _isAdvanceScoringEnabled = false;

  List<_DropdownDisplayItem> _membersForAdminSelectionDropdown = [];
  List<_LeaguePlayerDisplay> _leaguePlayersDisplayList = [];

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _leagueNameController = TextEditingController(text: "Loading...");
    _maxMatchesController = TextEditingController(text: "10");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLeagueSelection();
    });
  }

  void _initializeLeagueSelection() {
    if (!mounted) return;
    final currentSelectedLeague = ref.read(selectedLeagueProvider);
    if (currentSelectedLeague == null) {
      final userLeaguesAsync = ref.read(userStatusLeaguesProvider);
      userLeaguesAsync.whenData((leaguesList) {
        if (!mounted) return;
        if (leaguesList.isNotEmpty) {
          // ✅ Changed from .first to .last to select most recently created/joined league
          ref.read(selectedLeagueProvider.notifier).state = leaguesList.last;
        } else {
          setState(() {
            _isLoading = false;
            _leagueNameDisplay = "No leagues joined";
            _leagueNameController.text = "";
            _maxMatchesController.text = "";
            _errorMessage = "You haven't joined any leagues to see settings.";
          });
        }
      });
    }
  }

  void _updateStateWithApiData(LeagueDetails leagueDetails) {
    if (!mounted) return;
    setState(() {
      _leagueNameController.text = leagueDetails.name ?? "";
      _leagueNameDisplay = leagueDetails.name ?? "N/A";
      _inviteCodeDisplay = leagueDetails.inviteCode ?? "N/A";
      _selectedStatus = leagueDetails.active == true ? "Active" : "Inactive";
      _maxMatchesController.text = leagueDetails.maxGames?.toString() ?? "10";
      _isAdvanceScoringEnabled = leagueDetails.showPoints ?? false;

      _membersForAdminSelectionDropdown = leagueDetails.members?.map((member) {
        String memberName = "${member.firstName ?? ''} ${member.lastName ?? ''}".trim();
        if (memberName.isEmpty) memberName = member.email ?? member.id ?? 'Unknown Member';
        return _DropdownDisplayItem(id: member.id!, name: memberName);
      }).toList() ?? [];

      final currentActualAdmin = leagueDetails.administrators?.isNotEmpty ?? false
          ? leagueDetails.administrators!.first
          : null;
      _selectedAdminId = currentActualAdmin?.id;

      final adminIds = leagueDetails.administrators?.map((a) => a.id).toSet() ?? <String>{};
      _leaguePlayersDisplayList = leagueDetails.members?.map((member) {
        String memberName = "${member.firstName ?? ''} ${member.lastName ?? ''}".trim();
        if (memberName.isEmpty) memberName = member.email ?? member.id ?? 'Unknown Player';
        return _LeaguePlayerDisplay(
          id: member.id!,
          name: memberName,
          isAdmin: adminIds.contains(member.id!),
        );
      }).toList() ?? [];

      _isLoading = false;
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    _leagueNameController.dispose();
    _maxMatchesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    final currentLeagueId = selectedLeague?.id;
    final userDataAsyncValue = ref.watch(userDataProvider); // Kept for potential other uses

    ref.listen<String?>(selectedLeagueProvider.select((s) => s?.id), (previousLeagueId, newLeagueId) {
      if (!mounted) return;
      if (newLeagueId != null && newLeagueId != previousLeagueId) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
          _leagueNameController.text = "Loading...";
          _maxMatchesController.text = "";
          _leagueNameDisplay = "Loading League...";
          _inviteCodeDisplay = "N/A";
          _selectedAdminId = null;
          _membersForAdminSelectionDropdown = [];
          _leaguePlayersDisplayList = [];
        });
      }
      else if (newLeagueId == null && previousLeagueId != null) {
        setState(() {
           _isLoading = true;
           _errorMessage = null;
           _leagueNameController.text = "Loading...";
           _maxMatchesController.text = "";
           _leagueNameDisplay = "Loading League...";
           _inviteCodeDisplay = "N/A";
           _selectedAdminId = null;
           _membersForAdminSelectionDropdown = [];
           _leaguePlayersDisplayList = [];
        });
      }
    });

    if (currentLeagueId == null && !userDataAsyncValue.isLoading && !userDataAsyncValue.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
         if (mounted && _isLoading) {
            _initializeLeagueSelection();
         }
      });
    }

    if (currentLeagueId != null) {
      final leagueSettingsData = ref.watch(leagueSettingsProvider(currentLeagueId));
      leagueSettingsData.when(
        data: (details) {
          if (details != null && _isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _updateStateWithApiData(details);
              }
            });
          } else if (details == null && _isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _errorMessage = "League details not found.";
                  _isLoading = false;
                });
              }
            });
          }
        },
        loading: () {
          if (mounted && !_isLoading) {
             WidgetsBinding.instance.addPostFrameCallback((_) {
                if(mounted){
                    if(!_isLoading) setState(() { _isLoading = true; _errorMessage = null; });
                }
            });
          }
        },
        error: (err, stack) {
           if (mounted && _isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _errorMessage = "Error loading settings: ${err.toString()}";
                  _isLoading = false;
                });
              }
            });
          }
        },
      );
    } else {
        final userLeaguesAsync = ref.watch(userStatusLeaguesProvider);
        userLeaguesAsync.when(
            data: (leaguesList) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _isLoading) {
                        if (leaguesList.isEmpty) {
                             setState(() {
                                _isLoading = false;
                                _leagueNameDisplay = "No leagues joined";
                                _leagueNameController.text = "";
                                _maxMatchesController.text = "";
                                _errorMessage = "Please join or create a league to manage settings.";
                                _inviteCodeDisplay = "N/A";
                                _selectedAdminId = null;
                                _membersForAdminSelectionDropdown = [];
                                _leaguePlayersDisplayList = [];
                            });
                        } else if (ref.read(selectedLeagueProvider) == null) {
                            _initializeLeagueSelection();
                        }
                    }
                });
            },
            loading: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !_isLoading) {
                        setState(() { _isLoading = true; _errorMessage = null; });
                    }
                });
            },
            error: (err, stack) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _isLoading) {
                        setState(() {
                            _errorMessage = "Error loading league list: ${err.toString()}";
                            _isLoading = false;
                        });
                    }
                });
            }
        );
    }


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
      body: SingleChildScrollView(
        padding: defaultPadding(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text("Manage League Settings",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            10.0.heightbox,
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
            10.0.heightbox,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(AppImages.trophy, width: 18, height: 18, color: ktextColor),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedLeague?.name?.toUpperCase() ?? _leagueNameDisplay,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ktextColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    LeaguesJoined? selectedLeagueFromSheet = await showModalBottomSheet<LeaguesJoined?>(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      backgroundColor: Colors.white,
                      builder: (context) {
                        final leaguesDataAsync = ref.watch(userStatusLeaguesProvider);
                        return leaguesDataAsync.when(
                            data: (leaguesList) {
                              if (leaguesList.isEmpty) {
                                  return Container(
                                      padding: EdgeInsets.all(20),
                                      child: Center(child: Text("You haven't joined any leagues yet.", textAlign: TextAlign.center)),
                                  );
                              }
                              return SafeArea(
                                  child: Container(
                                  padding: EdgeInsets.all(16),
                                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                      Text("Choose League", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                                      Divider(color: Colors.grey.shade300, thickness: 1),
                                      10.0.heightbox,
                                      Expanded(
                                          child: ListView.separated(
                                          itemCount: leaguesList.length,
                                          separatorBuilder: (_, __) => SizedBox.shrink(),
                                          itemBuilder: (context, index) {
                                              final league = leaguesList[index];
                                              return LeagueOptionTile(
                                                leagueName: league.name ?? "Unnamed League",
                                                subtitle: '${league.matches?.length ?? 0} matches, ${league.members?.length ?? 0} members',
                                                onTap: () {
                                                    Navigator.pop(context, league);
                                                },
                                              );
                                          },
                                          ),
                                      ),
                                      10.0.heightbox,
                                      ],
                                  ),
                                  ),
                              );
                            },
                            loading: () => Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator())),
                            error: (e, _) => Padding(padding: const EdgeInsets.all(16), child: Text('Error loading leagues: $e')),
                        );
                      },
                    );

                    if (selectedLeagueFromSheet != null && selectedLeagueFromSheet.id != ref.read(selectedLeagueProvider)?.id) {
                        ref.read(selectedLeagueProvider.notifier).state = selectedLeagueFromSheet;
                    }
                  },
                  child: Row(
                    children: [
                      Text(" Change", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                      Icon(Icons.arrow_drop_down_circle, color: kPrimaryColor, size: 20),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Invite Code: $_inviteCodeDisplay", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            20.0.heightbox,
            if (_isSaving)
              Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 20.0), child: CircularProgressIndicator()))
            else if (_isLoading)
              Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 20.0), child:CircularProgressIndicator(color: kPrimaryColor)))
            else if (_errorMessage != null)
              Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text(_errorMessage!, style: TextStyle(color: Colors.red, fontSize: 16), textAlign: TextAlign.center)))
            else ...[
              Text("Select league admin", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              05.0.heightbox,
              StyledContainer(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                boxShadow: [],
                borderColor: kPrimaryColor.withOpacity(.5),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAdminId,
                    hint: Text(_membersForAdminSelectionDropdown.isEmpty ? "No members available" : "Select Admin"),
                    isExpanded: true,
                    isDense: true,
                    onChanged: (newValue) {
                      if(newValue != null) setState(() => _selectedAdminId = newValue);
                    },
                    items: _membersForAdminSelectionDropdown.map((member) {
                      return DropdownMenuItem<String>(
                        value: member.id,
                        child: Text(member.name, style: TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    disabledHint: Text(_membersForAdminSelectionDropdown.isEmpty ? "No members in league" : "Cannot change admin yet"),
                  ),
                ),
              ),
              15.0.heightbox,
              PrimaryTextField(
                controller: _leagueNameController,
                hintText: "League name",
                labelText: "League Name",
                bordercolor: kPrimaryColor.withOpacity(.5),
              ),
              15.0.heightbox,
              Text("Change league active status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              05.0.heightbox,
              StyledContainer(
                boxShadow: [],
                borderColor: kPrimaryColor.withOpacity(.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _selectedStatus = "Active"),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                        child: Row(children: [
                          Container(width: 15, height: 15, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ktextColor.withOpacity(.4), width: 2)), child: _selectedStatus == "Active" ? Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor))) : null),
                          10.0.widthbox,
                          Text("Active", style: TextStyle(color: ktextColor, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: "Inter")),
                        ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _selectedStatus = "Inactive"),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                        child: Row(children: [
                          Container(width: 15, height: 15, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ktextColor.withOpacity(.4), width: 2)), child: _selectedStatus == "Inactive" ? Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor))) : null),
                          10.0.widthbox,
                          Text("Inactive", style: TextStyle(color: ktextColor, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: "Inter")),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              15.0.heightbox,
              Text("Maximum number of matches", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              05.0.heightbox,
              PrimaryTextField(
                controller: _maxMatchesController,
                hintText: "Enter max matches (e.g., 10)",
                keyboardType: TextInputType.number,
                bordercolor: kPrimaryColor.withOpacity(.5),
              ),
              15.0.heightbox,
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isAdvanceScoringEnabled = !_isAdvanceScoringEnabled),
                    child: Container(
                      width: 45, height: 20,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: LinearGradient(colors: [Color(0xFF00D09F), Color(0xFF00785C)], begin: Alignment.topCenter, end: Alignment.bottomCenter), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.3), blurRadius: 5, spreadRadius: 2, offset: Offset(0, 4))]),
                      child: AnimatedAlign(
                        duration: Duration(milliseconds: 200), curve: Curves.easeInOut,
                        alignment: _isAdvanceScoringEnabled ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Container(width: 22, height: 22, decoration: BoxDecoration(shape: BoxShape.circle, color: _isAdvanceScoringEnabled ? kdefwhiteColor : Color(0xFFFFFACD), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.3), blurRadius: 3, offset: Offset(0, 1))])),
                        ),
                      ),
                    ),
                  ),
                  10.0.widthbox,
                  Text("CF Advance Point Scoring", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
              30.0.heightbox,
              Row(
                children: [
                  Expanded(child: SecondaryButton(fontSize: 14, buttonText: "Update League", onPressFunction: () async {
                    final leagueIdToUpdate = ref.read(selectedLeagueProvider)?.id;
                    if (leagueIdToUpdate == null) {
                      if (!mounted) return;
                      toastification.show(
                        context: context,
                        title: Text("Please select a league first."),
                        type: ToastificationType.warning,
                        style: ToastificationStyle.fillColored,
                        autoCloseDuration: const Duration(seconds: 2),
                      );
                      return;
                    }

                    if (_leagueNameController.text.trim().isEmpty) {
                        if (!mounted) return;
                        toastification.show(
                          context: context,
                          title: Text("League name cannot be empty."),
                          type: ToastificationType.warning,
                          style: ToastificationStyle.fillColored,
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                        return;
                    }

                    final maxMatchesInput = _maxMatchesController.text.trim();
                    int? maxMatches;
                    if (maxMatchesInput.isNotEmpty) {
                      maxMatches = int.tryParse(maxMatchesInput);
                      if (maxMatches == null) {
                        if (!mounted) return;
                        toastification.show(
                          context: context,
                          title: Text("Invalid number for maximum matches."),
                          type: ToastificationType.warning,
                          style: ToastificationStyle.fillColored,
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                        return;
                      }
                    }

                    final String? newAdminIdOptimistic = _selectedAdminId;

                    if (mounted) setState(() => _isSaving = true);

                    try {
                      await updateLeagueSettings(
                        ref: ref,
                        leagueId: leagueIdToUpdate,
                        name: _leagueNameController.text.trim(),
                        active: _selectedStatus == "Active",
                        maxGames: maxMatches,
                        showPoints: _isAdvanceScoringEnabled,
                        administratorIds: _selectedAdminId != null ? [_selectedAdminId!] : null,
                      );

                      if (mounted) {
                        toastification.show(
                          context: context,
                          title: Text("League settings updated successfully!"),
                          type: ToastificationType.success,
                          style: ToastificationStyle.fillColored,
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                        setState(() {
                          _leagueNameDisplay = _leagueNameController.text.trim();
                          if (newAdminIdOptimistic != null) {
                            _leaguePlayersDisplayList = _leaguePlayersDisplayList.map((player) {
                              return _LeaguePlayerDisplay(
                                id: player.id,
                                name: player.name,
                                isAdmin: player.id == newAdminIdOptimistic,
                              );
                            }).toList();
                          } else {
                             _leaguePlayersDisplayList = _leaguePlayersDisplayList.map((player) {
                              return _LeaguePlayerDisplay(
                                id: player.id,
                                name: player.name,
                                isAdmin: false,
                              );
                            }).toList();
                          }
                        });
                      }
                    } catch (e) {
                      if (!mounted) return;
                      toastification.show(
                        context: context,
                        title: Text("Failed to update settings"),
                        description: Text(e.toString()),
                        type: ToastificationType.error,
                        style: ToastificationStyle.fillColored,
                        autoCloseDuration: const Duration(seconds: 2),
                      );
                    } finally {
                      if (mounted) setState(() => _isSaving = false);
                    }
                  })),
                  40.0.widthbox,
                  Expanded(child: SecondaryButton(
                    buttonColor: kredColor,
                    fontSize: 14,
                    buttonText: "Leave League",
                    onPressFunction: () async {
                      final leagueToLeave = ref.read(selectedLeagueProvider);
                      if (leagueToLeave == null || leagueToLeave.id == null) {
                        if (!mounted) return;
                        toastification.show(
                          context: context,
                          title: Text("No league selected."),
                          type: ToastificationType.warning,
                          style: ToastificationStyle.fillColored,
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                        return;
                      }

                      final leagueName = leagueToLeave.name ?? "this league";
                      final bool? confirmed = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text("Leave League?"),
                            content: Text("Are you sure you want to leave '$leagueName'?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () => Navigator.of(dialogContext).pop(false),
                              ),
                              TextButton(
                                child: Text("Leave", style: TextStyle(color: Colors.red)),
                                onPressed: () => Navigator.of(dialogContext).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true) {
                        if (!mounted) return;
                        setState(() => _isSaving = true);
                        try {
                          await leaveLeague(ref: ref, leagueId: leagueToLeave.id!);
                          if (!mounted) return;
                          toastification.show(
                            context: context,
                            title: Text("Successfully left '$leagueName'"),
                            type: ToastificationType.success,
                            style: ToastificationStyle.fillColored,
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                          ref.invalidate(userStatusLeaguesProvider);
                          ref.read(selectedLeagueProvider.notifier).state = null;
                          _initializeLeagueSelection();
                        } catch (e) {
                          if (!mounted) return;
                          toastification.show(
                            context: context,
                            title: Text("Failed to leave league"),
                            description: Text(e.toString()),
                            type: ToastificationType.error,
                            style: ToastificationStyle.fillColored,
                            autoCloseDuration: const Duration(seconds: 2),
                          );
                        } finally {
                          if (mounted) setState(() => _isSaving = false);
                        }
                      }
                    }
                  )),
                ],
              ),
              20.0.heightbox,
                  Text("League Players", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  StyledContainer(
                    padding: EdgeInsets.all(10),
                    boxShadow: [],
                    borderColor: kPrimaryColor.withOpacity(.5),
                    child: _leaguePlayersDisplayList.isEmpty
                        ? Center(
                      child: Text(
                        "No players in this league yet.",
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                        : Column(
                      children: _leaguePlayersDisplayList.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final player = entry.value;

                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    player.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: player.isAdmin ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (player.isAdmin)
                                  Text(
                                    "League Admin",
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                else
                                  GestureDetector(
                                    onTap: () {
                                      toastification.show(
                                        context: context,
                                        title: Text("${player.name} remove action (not implemented)"),
                                        type: ToastificationType.info,
                                        style: ToastificationStyle.fillColored,
                                        autoCloseDuration: const Duration(seconds: 2),
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/icons/delete.png",
                                      width: 22,
                                      height: 22,
                                      color: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                            if (index != _leaguePlayersDisplayList.length - 1)
                              Divider(color: Colors.grey.shade200, thickness: 2, height: 20),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
              20.0.heightbox,
              Text("Delete this league", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              10.0.heightbox,
              PrimaryButton(width: 130, height: 30, fontSize: 14, onPressFunction: () async {
                final leagueToDelete = ref.read(selectedLeagueProvider);
                if (leagueToDelete == null || leagueToDelete.id == null) {
                  if (!mounted) return;
                  toastification.show(
                    context: context,
                    title: Text("No league selected or league ID is missing."),
                    type: ToastificationType.warning,
                    style: ToastificationStyle.fillColored,
                    autoCloseDuration: const Duration(seconds: 2),
                  );
                  return;
                }

                final leagueName = leagueToDelete.name ?? "this league";
                final bool? confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text("Delete League?"),
                      content: Text("Are you sure you want to delete '$leagueName'? This action cannot be undone."),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () => Navigator.of(dialogContext).pop(false),
                        ),
                        TextButton(
                          child: Text("Delete", style: TextStyle(color: Colors.red)),
                          onPressed: () => Navigator.of(dialogContext).pop(true),
                        ),
                      ],
                    );
                  },
                );

                if (confirmed == true) {
                  if (!mounted) return;
                  setState(() => _isSaving = true);
                  try {
                    await deleteLeague(ref: ref, leagueId: leagueToDelete.id!);
                    if (!mounted) return;
                    toastification.show(
                      context: context,
                      title: Text("League '$leagueName' deleted successfully!"),
                      type: ToastificationType.success,
                      style: ToastificationStyle.fillColored,
                      autoCloseDuration: const Duration(seconds: 2),
                    );
                    ref.invalidate(userStatusLeaguesProvider); // Invalidate here
                    ref.read(selectedLeagueProvider.notifier).state = null;
                    _initializeLeagueSelection();
                  } catch (e) {
                    if (!mounted) return;
                    toastification.show(
                      context: context,
                      title: Text("Failed to delete league"),
                      description: Text(e.toString()),
                      type: ToastificationType.error,
                      style: ToastificationStyle.fillColored,
                      autoCloseDuration: const Duration(seconds: 2),
                    );
                  } finally {
                    if (mounted) setState(() => _isSaving = false);
                  }
                }
              }, buttonText: "Delete League", buttonColor: kredColor),
            ],
            30.0.heightbox,
          ],
        ),
      ),
    );
  }
}
