import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:champion_footballer/Utils/imageconstants.dart';

class PerformanceDashboard extends StatelessWidget {
  const PerformanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Widget originalBody = SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Center(
              child: Text(
                "Khurram Performance Dashboard",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Performance Over Time
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Performance Over Time",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 260,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        primaryXAxis: CategoryAxis(
                          labelRotation: -45,
                          majorGridLines: const MajorGridLines(width: 0),
                          labelStyle: const TextStyle(fontSize: 11),
                        ),
                        axes: <ChartAxis>[
                          NumericAxis(
                            name: "leftAxis",
                            opposedPosition: false,
                            title: AxisTitle(
                              text: "Average XP Points",
                              alignment: ChartAlignment.center,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.teal,
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: const TextStyle(fontSize: 11),
                            majorGridLines: MajorGridLines(width: 0),
                            axisLine: AxisLine(width: 1),
                          ),

                          NumericAxis(
                            name: "rightAxis",
                            opposedPosition: true,
                            title: AxisTitle(
                              text: "Accumulative XP Points",
                              alignment: ChartAlignment.center,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.blue,
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: const TextStyle(fontSize: 11),
                            majorGridLines: const MajorGridLines(width: 0),
                          ),
                        ],
                        series: <CartesianSeries>[
                          // Green Bars = Avg Points
                          ColumnSeries<ChartData, String>(
                            dataSource: performanceData,
                            xValueMapper: (ChartData data, _) => data.month,
                            yValueMapper: (ChartData data, _) => data.points,
                            yAxisName: "leftAxis",
                            name: "Avg Points per Month",
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(4),
                          ),

                          // Blue Line = Accumulative Points
                          LineSeries<ChartData, String>(
                            dataSource: performanceData,
                            xValueMapper: (ChartData data, _) => data.month,
                            yValueMapper: (ChartData data, _) => data.total,
                            yAxisName: "rightAxis",
                            name: "Accumulative XP Points",
                            color: Colors.blue,
                            width: 2,
                          ),
                        ],
                        legend: const Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Influence + Win/Loss charts
            Row(
              children: [
                // Custom Radar Chart
                Expanded(
                  child: Card(
                    child: SizedBox(
                      height: 220,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text(
                              "Influence",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: SimpleRadarChart(
                                features: const [
                                  "Goals",
                                  "Assists",
                                  "Clean Sheets",
                                  "Defensive",
                                  "MOTM"
                                ],
                                data: [
                                  influenceData.map((d) => d.value).toList(),
                                  leagueAvgData.map((d) => d.value).toList(),
                                ],
                                ticks: const [2, 4, 6, 8, 10],
                                seriesColors: const [
                                  Colors.teal,
                                  Colors.orange,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Pie Chart
                Expanded(
                  child: Card(
                    child: SizedBox(
                      height: 220,
                      child: SfCircularChart(
                        title: const ChartTitle(
                          text: "Win/Loss",
                          alignment: ChartAlignment.center,
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        legend: const Legend(isVisible: false),
                        series: <CircularSeries>[
                          DoughnutSeries<PieData, String>(
                            dataSource: winLossData,
                            xValueMapper: (PieData data, _) => data.status,
                            yValueMapper: (PieData data, _) => data.count,
                            pointColorMapper: (PieData data, _) => data.color,
                            radius: '95%',
                            innerRadius: '60%',
                            dataLabelMapper: (PieData data, _) => "${data.count.toInt()}%",
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.inside,
                              textStyle: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Impact Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Impact",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Circle Left
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.black, width: 1.2),
                                color: Colors.white,
                              ),
                              child: const Center(
                                child: Text(
                                  "123",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Matches\nPlayed",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        // Table Right
                        Expanded(
                          child: Table(
                            border: const TableBorder(
                              horizontalInside:
                              BorderSide(width: 1, color: Colors.black),
                            ),
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1.2),
                              2: FlexColumnWidth(2),
                              3: FlexColumnWidth(0.8),
                            },
                            children: [
                              const TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(""),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      "Last 10",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      "Progress Prev 10",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(""), // <-- FIX
                                  ),
                                ],
                              ),

                              _buildImpactRow("% Impact", "30%", "+0.5%", true),
                              _buildImpactRow("Win Rate", "55%", "-10%", false),
                              _buildImpactRow("MOTM Votes", "7", "2", true),
                              _buildImpactRow("Goal Diff", "10", "-2%", false),
                              _buildImpactRow("Goals + Assist", "5", "+1", true),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      "You're outperforming! Your win ratio is 10% higher than the peer average! "
                          "You're making waves! Your impact is 5% above the peer average! "
                          "You're in the top 30% of total votes!",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Your Top Strength Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Top Strength",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    Table(
                      border: const TableBorder(
                        horizontalInside: BorderSide(width: 1, color: Colors.black),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(2),   // Metric
                        1: FlexColumnWidth(1),   // You
                        2: FlexColumnWidth(2),   // Against Top 25% (+diff + arrow)
                      },
                      children: [
                        // Header row
                        const TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text(""),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                "You",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                "Against Top 25%",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),

                        // Data rows
                        _buildStrengthRow("Clean Sheets", "3", "+1", true),
                        _buildStrengthRow("Captains Wins", "2", "+2", true),
                        _buildStrengthRow("Individual Brilliances", "2", "+1", true),
                      ],
                    ),

                    const SizedBox(height: 8),
                    const Text(
                      "Clean Sheets: You're outperforming 70% of players in your leagues!",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),


            const SizedBox(height: 16),

// 🔹 Focus Area Section
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Focus Area",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Increasing your key passes could elevate you to the top 25% for assists!",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),



            // Play Best With + Rivalries (shirt inline with name)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: "You Play Best With "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Image.asset(
                          "assets/icons/shirt.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const TextSpan(text: " Bilal: Total points accumulated 100xp"),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: "Most Rivalries Against "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Image.asset(
                          "assets/icons/awayshirt.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const TextSpan(text: " Zohaib: Won 55% Lost 45%"),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImages.background,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          originalBody,
        ],
      ),
    );
  }
}

// -------------------- Helper --------------------

TableRow _buildImpactRow(
    String title, String value, String change, bool up) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(title,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(change,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: up ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Icon(
          up ? Icons.arrow_upward : Icons.arrow_downward,
          size: 14,
          color: up ? Colors.green : Colors.red,
        ),
      ),
    ],
  );
}

TableRow _buildStrengthRow(
    String title, String you, String diff, bool up) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          you,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              diff,
              style: TextStyle(
                color: up ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 15),
            Icon(
              up ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: up ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    ],
  );
}



// -------------------- Radar Chart --------------------

class SimpleRadarChart extends StatelessWidget {
  final List<String> features;
  final List<List<double>> data;
  final List<int> ticks;
  final List<Color> seriesColors;
  final double? maxValue;

  const SimpleRadarChart({
    super.key,
    required this.features,
    required this.data,
    required this.ticks,
    required this.seriesColors,
    this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadarChartPainter(
        features: features,
        data: data,
        ticks: ticks,
        seriesColors: seriesColors,
        maxValue: maxValue,
      ),
      size: Size.infinite,
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final List<String> features;
  final List<List<double>> data;
  final List<int> ticks;
  final List<Color> seriesColors;
  final double? maxValue;

  RadarChartPainter({
    required this.features,
    required this.data,
    required this.ticks,
    required this.seriesColors,
    this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);
    final double radius = math.min(w, h) / 2 * 0.65;
    final int n = features.length;
    final double maxTick = (maxValue ?? ticks.last).toDouble();

    final Paint gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.grey.withOpacity(0.25);

    // concentric polygons
    for (int i = 0; i < ticks.length; i++) {
      double t = ticks[i] / maxTick;
      Path p = Path();
      for (int k = 0; k < n; k++) {
        final double angle = -math.pi / 2 + 2 * math.pi * k / n;
        final double x = center.dx + radius * t * math.cos(angle);
        final double y = center.dy + radius * t * math.sin(angle);
        if (k == 0) {
          p.moveTo(x, y);
        } else {
          p.lineTo(x, y);
        }
      }
      p.close();
      canvas.drawPath(p, gridPaint);
    }

    // radial lines
    final Paint axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.35)
      ..strokeWidth = 1;
    for (int k = 0; k < n; k++) {
      final double angle = -math.pi / 2 + 2 * math.pi * k / n;
      final double x = center.dx + radius * math.cos(angle);
      final double y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), axisPaint);
    }

    // draw each series
    for (int s = 0; s < data.length; s++) {
      final series = data[s];
      final Color baseColor =
      (s < seriesColors.length) ? seriesColors[s] : Colors.blue;
      final Paint fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = baseColor.withOpacity(0.45);
      final Paint strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = baseColor
        ..strokeWidth = 2;

      final Path seriesPath = Path();
      for (int k = 0; k < n; k++) {
        final double val = (k < series.length) ? series[k] : 0.0;
        final double t = (val.clamp(0, maxTick)) / maxTick;
        final double angle = -math.pi / 2 + 2 * math.pi * k / n;
        final double x = center.dx + radius * t * math.cos(angle);
        final double y = center.dy + radius * t * math.sin(angle);
        if (k == 0) {
          seriesPath.moveTo(x, y);
        } else {
          seriesPath.lineTo(x, y);
        }
      }
      seriesPath.close();
      canvas.drawPath(seriesPath, fillPaint);
      canvas.drawPath(seriesPath, strokePaint);

      // markers
      final Paint markerPaint = Paint()..color = baseColor;
      for (int k = 0; k < n; k++) {
        final double val = (k < series.length) ? series[k] : 0.0;
        final double t = (val.clamp(0, maxTick)) / maxTick;
        final double angle = -math.pi / 2 + 2 * math.pi * k / n;
        final double x = center.dx + radius * t * math.cos(angle);
        final double y = center.dy + radius * t * math.sin(angle);
        canvas.drawCircle(Offset(x, y), 3, markerPaint);
      }
    }

    // feature labels
    for (int k = 0; k < n; k++) {
      final double angle = -math.pi / 2 + 2 * math.pi * k / n;
      final double x = center.dx + (radius + 18) * math.cos(angle);
      final double y = center.dy + (radius + 18) * math.sin(angle);
      textSpan(features[k], canvas, Offset(x, y));
    }
  }

  void textSpan(String text, Canvas canvas, Offset position) {
    final tp = TextPainter(
      text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.black, fontSize: 12)),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    final Offset pos =
    Offset(position.dx - tp.width / 2, position.dy - tp.height / 2);
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant RadarChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.features != features ||
        oldDelegate.ticks != ticks ||
        oldDelegate.seriesColors != seriesColors;
  }
}

class ChartData {
  final String month;
  final int points;
  final int total;
  ChartData(this.month, this.points, this.total);
}

class RadarData {
  final String metric;
  final double value;
  RadarData(this.metric, this.value);
}

class PieData {
  final String status;
  final double count;
  final Color color;
  PieData(this.status, this.count, this.color);
}



final List<ChartData> performanceData = [
  ChartData("Jan", 20, 100),
  ChartData("Feb", 40, 200),
  ChartData("Mar", 60, 300),
  ChartData("Apr", 80, 400),
  ChartData("May", 50, 450),
];

final List<RadarData> influenceData = [
  RadarData("Goals", 10),
  RadarData("Assists", 8),
  RadarData("Clean Sheets", 7),
  RadarData("Defensive", 5),
  RadarData("MOTM", 6),
];

final List<RadarData> leagueAvgData = [
  RadarData("Goals", 6),
  RadarData("Assists", 5),
  RadarData("Clean Sheets", 4),
  RadarData("Defensive", 3),
  RadarData("MOTM", 4),
];

final List<PieData> winLossData = [
  PieData("Win", 45, Colors.green),
  PieData("Loss", 35, Colors.red),
  PieData("Draw", 20, Colors.orange), // 🔹 Draw added
];
