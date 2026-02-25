import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moodscape_app/services/firestore_service.dart';
import 'package:moodscape_app/utils/constants.dart';
import 'package:moodscape_app/utils/helper_functions.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = true;
  int _totalUsers = 0;
  int _totalChallenges = 0;
  double _averageMood = 0;
  List<double> _weeklyMoodData = [];

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);

    _totalUsers = await _firestoreService.getAllUsers();
    _totalChallenges = await _firestoreService.getDailyChallenges();
    if (_weeklyMoodData.isNotEmpty) {
      _averageMood =
          _weeklyMoodData.reduce((a, b) => a + b) / _weeklyMoodData.length;
    }

    setState(() => _isLoading = false);
  }

  List<FlSpot> _generateMoodSpots() {
    return List.generate(
      _weeklyMoodData.length,
      (index) => FlSpot(index.toDouble(), _weeklyMoodData[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics Dashboard"),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Stats Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard("Total Users", _totalUsers.toString(),
                          Icons.people, Colors.blue),
                      _buildStatCard(
                          "Completed Challenges",
                          _totalChallenges.toString(),
                          Icons.check_circle,
                          Colors.green),
                      _buildStatCard(
                          "Average Mood",
                          _averageMood.toStringAsFixed(1),
                          Icons.mood,
                          Colors.deepPurple),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 🔹 Weekly Mood Trend Chart
                  const Text(
                    "Weekly Mood Trend",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 5,
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
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text("Day ${value.toInt() + 1}",
                                    style: const TextStyle(fontSize: 12));
                              },
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString(),
                                    style: const TextStyle(fontSize: 12));
                              },
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _generateMoodSpots(),
                            isCurved: true,
                            barWidth: 3,
                            colors: [PRIMARY_COLOR],
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              colors: [PRIMARY_COLOR.withOpacity(0.2)],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.1,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
