import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class StatPlots extends StatelessWidget {
  const StatPlots({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<AppState>().entries;

    // Count frequency of each trigger
    final Map<String, int> triggerCounts = {};
    for (var entry in entries) {
      final trigger = entry.trigger.trim().toLowerCase();
      if (trigger.isEmpty) continue;
      triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
    }

    if (triggerCounts.isEmpty) {
      return const Center(child: Text("No triggers logged yet."));
    }

    // Get top 5 most frequent triggers
    final sortedEntries = triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topEntries = sortedEntries.take(5).toList();
    final maxCount = topEntries.first.value.toDouble();

    return SizedBox(
      height: 250,
      child: RotatedBox(
        quarterTurns: 1, // Rotate 90 degrees for horizontal-style bar chart
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index < 0 || index >= topEntries.length) return const SizedBox.shrink();
                    final label = topEntries[index].key;
                    return RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        label.length > 10 ? '${label.substring(0, 10)}…' : label,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                  reservedSize: 60,
                ),
              ),
            ),
            barGroups: List.generate(topEntries.length, (i) {
              final count = topEntries[i].value.toDouble();
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: count,
                    color: Colors.teal,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxCount,
                      color: Colors.teal.withOpacity(0.1),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
