import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/cgpa_provider.dart';

class CGPAAnalysisScreen extends StatelessWidget {

  const CGPAAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Analysis')),
      body: Consumer<CGPAProvider>(
        builder: (context, provider, child) {
          final semesters = provider.semesters;

          if (semesters.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final gpaList = semesters.map((s) => provider.getSemesterGPA(s.id)).toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'GPA Trend',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 0.5,
                            reservedSize: 40,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < semesters.length) {
                                return Text(
                                  semesters[value.toInt()].name.substring(0, 2),
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                            reservedSize: 30,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: gpaList.asMap().entries.map((e) {
                            return FlSpot(e.key.toDouble(), e.value);
                          }).toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 4,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withValues(alpha: 0.3),
                          ),
                          dotData: FlDotData(show: true),
                        ),
                      ],
                      minY: 0,
                      maxY: 4.0,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    _buildStatCard(
                        'Highest GPA',
                        gpaList.reduce((a, b) => a > b ? a : b).toStringAsFixed(2),
                        Colors.green),
                    const SizedBox(width: 16),
                    _buildStatCard(
                        'Lowest GPA',
                        gpaList.reduce((a, b) => a < b ? a : b).toStringAsFixed(2),
                        Colors.orange),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    _buildStatCard(
                        'Average GPA',
                        (gpaList.reduce((a, b) => a + b) / gpaList.length)
                            .toStringAsFixed(2),
                        Colors.blue),
                    const SizedBox(width: 16),
                    _buildStatCard(
                        'Total Courses',
                        provider.allCourses.length.toString(),
                        Colors.purple),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: color, fontSize: 12)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}