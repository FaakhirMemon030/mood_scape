import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<FlSpot> _chartData = [];
  int _totalMoods = 0;

  @override
  void initState() {
    super.initState();
    _fetchMoodData();
  }

  Future<void> _fetchMoodData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('moods')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date')
        .get();

    List<FlSpot> tempData = [];
    int count = 0;
    for (int i = 0; i < snapshot.docs.length; i++) {
      final data = snapshot.docs[i].data();
      final mood = (data['mood'] as num).toDouble();
      tempData.add(FlSpot(i.toDouble(), mood));
      count++;
    }

    setState(() {
      _chartData = tempData;
      _totalMoods = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Your Progress",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Mood Chart
            Expanded(
              child: _chartData.isEmpty
                  ? const Center(
                      child: Text(
                        "No data yet 😔",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : LineChart(
                      LineChartData(
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                            bottom: BorderSide(color: Colors.grey),
                            left: BorderSide(color: Colors.grey),
                            top: BorderSide(color: Colors.transparent),
                            right: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        gridData: FlGridData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _chartData,
                            isCurved: true,
                            barWidth: 3,
                            color: Colors.deepPurple, // ✅ single Color
                            dotData: FlDotData(show: true),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 28,
                            ),
                          ),
                        ),
                        minY: 0,
                        maxY: 5,
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            // 🔹 Summary Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard("Total Moods", _totalMoods),
                _buildStatCard("Current Streak", 5), // 🔹 Placeholder
                _buildStatCard("Badges", 2), // 🔹 Placeholder
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "$value",
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
