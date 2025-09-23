import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:champion_footballer/Utils/packages.dart'; // Assuming this contains kPrimaryColor & CustomAppBar

class WorldRankingScreen extends ConsumerStatefulWidget {
  const WorldRankingScreen({super.key});

  @override
  ConsumerState<WorldRankingScreen> createState() =>
      _WorldRankingScreenState();
}

class _WorldRankingScreenState extends ConsumerState<WorldRankingScreen> {
  String _mode = 'total'; // 'total' or 'avg'
  String? _positionType;
  String? _year;
  String _searchQuery = '';

  final List<String> _years =
  List.generate(10, (index) => (DateTime.now().year - index).toString());

  final List<Map<String, dynamic>> _dummyPlayers = [
    {
      "rank": 1,
      "player": "Lionel Messi",
      "position": "FW",
      "posType": "Goalkeeper",
      "matches": 25,
      "avgXp": 95.2,
      "totalXp": 2380,
    },
    {
      "rank": 2,
      "player": "Cristiano Ronaldo",
      "position": "FW",
      "posType": "Attacking",
      "matches": 27,
      "avgXp": 90.1,
      "totalXp": 2435,
    },
    {
      "rank": 3,
      "player": "Luka Modrić",
      "position": "CM",
      "posType": "Midfield",
      "matches": 22,
      "avgXp": 85.7,
      "totalXp": 1885,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: "World Ranking",
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFilterAndSummaryCard(),
            const SizedBox(height: 24),
            _buildRankingTable(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterAndSummaryCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withOpacity(0.08)),
      ),
      color: const Color(0xFF1F1F1F),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.spaceBetween,
              children: [
                _buildModeToggle(),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildPositionTypeDropdown(),
                    _buildYearDropdown(),
                  ],
                ),
                _buildSearchField(),
              ],
            ),
            if (_hasActiveFilters) ...[
              const SizedBox(height: 12),
              _buildActiveFilterChips(),
            ],
            const SizedBox(height: 16),
            _buildSummaryPills(),
            const SizedBox(height: 16),
            Text(
              'View global performance of all registered players. Your row is highlighted. '
                  'Use Average mode to normalize by matches played. Scroll is auto-focused on you if ranked in the visible list.',
              style: TextStyle(
                fontSize: 11.7,
                color: Colors.grey[400],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MODE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Color(0xFFFF9D55),
          ),
        ),
        const SizedBox(height: 6),
        ToggleButtons(
          isSelected: [_mode == 'total', _mode == 'avg'],
          onPressed: (index) {
            setState(() {
              _mode = index == 0 ? 'total' : 'avg';
            });
          },
          borderRadius: BorderRadius.circular(8),
          selectedColor: Colors.white,
          color: Colors.grey[300],
          fillColor: kPrimaryColor,
          constraints: const BoxConstraints(minHeight: 32, minWidth: 80),
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Total XP',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Avg / Match',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPositionTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'POSITION TYPE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Color(0xFFFF9D55),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 140,
          child: DropdownButton<String>(
            isExpanded: true,
            value: _positionType,
            hint: const Text(
              'All',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            dropdownColor: const Color(0xFF2A2A2A),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            underline: Container(
              height: 1,
              color: Colors.white.withOpacity(0.18),
            ),
            onChanged: (String? newValue) {
              setState(() {
                _positionType = newValue;
              });
            },
            items: <String>['Defensive', 'Midfield', 'Attacking', 'Goalkeeper']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildYearDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'YEAR',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Color(0xFFFF9D55),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 100,
          child: DropdownButton<String>(
            isExpanded: true,
            value: _year,
            hint: const Text(
              'All',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            dropdownColor: const Color(0xFF2A2A2A),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            underline: Container(
              height: 1,
              color: Colors.white.withOpacity(0.18),
            ),
            onChanged: (String? newValue) {
              setState(() {
                _year = newValue;
              });
            },
            items: _years.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SEARCH',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Color(0xFFFF9D55),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            SizedBox(
              width: 160,
              height: 40,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search Player',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.18)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.34)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: _hasActiveFilters
                  ? () {
                setState(() {
                  _positionType = null;
                  _year = null;
                  _searchQuery = '';
                });
              }
                  : null,
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                  BorderSide(color: Colors.white.withOpacity(0.25)),
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.white; // Disabled = White
                    }
                    return const Color(0xFFFF9D55); // Enabled = Orange
                  },
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: const Text(
                'Clear',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool get _hasActiveFilters =>
      _positionType != null || _year != null || _searchQuery.isNotEmpty;

  Widget _buildActiveFilterChips() {
    List<Widget> chips = [];
    if (_positionType != null) {
      chips.add(
        Chip(
          label: Text('Pos: $_positionType'),
          onDeleted: () => setState(() => _positionType = null),
          backgroundColor: kPrimaryColor,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
          deleteIconColor: Colors.white70,
          visualDensity: VisualDensity.compact,
        ),
      );
    }
    if (_year != null) {
      chips.add(
        Chip(
          label: Text('Year: $_year'),
          onDeleted: () => setState(() => _year = null),
          backgroundColor: kPrimaryColor,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
          deleteIconColor: Colors.white70,
          visualDensity: VisualDensity.compact,
        ),
      );
    }
    if (_searchQuery.isNotEmpty) {
      chips.add(
        Chip(
          label: Text('Search: $_searchQuery'),
          onDeleted: () => setState(() => _searchQuery = ''),
          backgroundColor: Colors.grey[700],
          labelStyle: const TextStyle(color: Colors.white),
          deleteIconColor: Colors.white70,
        ),
      );
    }
    return Wrap(spacing: 8, runSpacing: 0, children: chips);
  }

  Widget _buildSummaryPills() {
    return Wrap(
      spacing: 4,
      runSpacing: 5,
      children: [
        _summaryPill(
            'Mode', _mode == 'total' ? 'Total XP' : 'Average XP/Match'),
        _summaryPill('Players', _dummyPlayers.length.toString()),
        _summaryPill('Updated', TimeOfDay.now().format(context)),
      ],
    );
  }

  Widget _summaryPill(String label, String value, {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        color: highlight ? kPrimaryColor : Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlight
              ? kPrimaryColor.withOpacity(0.8)
              : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 0.8,
              color: highlight ? Colors.white : Colors.grey[400],
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingTable() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4B4B4B)),
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF111111)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(229, 106, 22, 1),
                  Color.fromRGBO(207, 35, 38, 1),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            child: Row(
              children: const [
                _TableHeaderCell('Rank ▲', showDivider: true),
                _TableHeaderCell('Player', showDivider: true),
                _TableHeaderCell('Position', showDivider: true),
                _TableHeaderCell('Pos Type', showDivider: true),
                _TableHeaderCell('Matches', showDivider: true),
                _TableHeaderCell('Avg XP', showDivider: true),
                _TableHeaderCell('Total XP', showDivider: false),
              ],
            ),
          ),
          if (_dummyPlayers.isEmpty)
            SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  "No players found.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            Column(
              children: _dummyPlayers.map((player) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: Colors.white.withOpacity(0.08), width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      _TableBodyCell(player["rank"].toString(),
                          showDivider: true),
                      _TableBodyCell(player["player"], showDivider: true),
                      _TableBodyCell(player["position"], showDivider: true),
                      _TableBodyCell(player["posType"], showDivider: true),
                      _TableBodyCell(player["matches"].toString(),
                          showDivider: true),
                      _TableBodyCell(player["avgXp"].toString(),
                          showDivider: true),
                      _TableBodyCell(player["totalXp"].toString(),
                          showDivider: false),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  final bool showDivider;
  const _TableHeaderCell(this.text, {this.showDivider = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(
            right: BorderSide(color: Colors.white24, width: 0.8),
          )
              : null,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 9,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _TableBodyCell extends StatelessWidget {
  final String text;
  final bool showDivider;
  const _TableBodyCell(this.text, {this.showDivider = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 7,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
