import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodChart extends StatelessWidget {
  final List<double> moodData; // List of moods (1-5 scale)
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
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  interval: 1,
                  getTitlesWidget: (value, meta) => Text(
                    "Day ${value.toInt() + 1}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
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
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 3,
                colors: [Colors.deepPurple],
                dotData: FlDotData(
                  show: true,
                  dotSize: 4,
                  dotColor: Colors.deepPurple,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  colors: [Colors.deepPurple.withOpacity(0.2)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
