import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodChart extends StatelessWidget {
  final List<double> moodData; // Mood values (1-5)
  final double maxMoodValue;

  const MoodChart({
    super.key,
    required this.moodData,
    this.maxMoodValue = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    if (moodData.isEmpty) {
      return const Center(
        child: Text(
          "No mood data yet 😔",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    // Convert moodData to FlSpot
    final spots = List.generate(
      moodData.length,
      (index) => FlSpot(index.toDouble(), moodData[index]),
    );

    return AspectRatio(
      aspectRatio: 1.6,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: maxMoodValue,
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.shade300,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                top: BorderSide(color: Colors.transparent),
                right: BorderSide(color: Colors.transparent),
              ),
            ),
            titlesData: const FlTitlesData(
              // Hide top and right titles for a cleaner look
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 30,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 40,
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 3,
                color: Colors.deepPurple, // Line color
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                    radius: 4, // Pehle ye dotSize tha
                    color: Colors.deepPurple, // Pehle ye dotColor tha
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  // Naye version mein 'colors' ki jagah 'color' ya 'gradient' use hota hai
                  color: Colors.deepPurple.withOpacity(0.2), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}