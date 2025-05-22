import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/trigger_entry.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = Provider.of<AppState>(context).entries;

    final total = entries.length;
    final smoked = entries.where((e) => e.didSmoke).length;
    final smokeRate = total == 0 ? 0.0 : smoked / total * 100;

    // Most common triggers
    final triggerCounts = <String, int>{};
    for (var entry in entries) {
      triggerCounts[entry.trigger] = (triggerCounts[entry.trigger] ?? 0) + 1;
    }

    final mostCommon = triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Calculate longest and current no-smoking streaks
    int longestStreak = 0;
    int currentStreak = 0;
    int tempStreak = 0;

    for (var entry in entries.reversed) {
      if (!entry.didSmoke) {
        tempStreak += 1;
        if (tempStreak > longestStreak) longestStreak = tempStreak;
      } else {
        if (tempStreak > longestStreak) longestStreak = tempStreak;
        tempStreak = 0;
      }
    }
    currentStreak = tempStreak;

    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _StatCard(title: "Total Entries", value: "$total"),
            _StatCard(title: "Smoking Rate", value: "${smokeRate.toStringAsFixed(1)}%"),
            _StatCard(title: "Current Streak", value: "$currentStreak"),
            _StatCard(title: "Longest Streak", value: "$longestStreak"),
            const SizedBox(height: 20),
            const Text("Most Common Triggers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (mostCommon.isEmpty)
              const Text("No data yet."),
            ...mostCommon.take(5).map((e) => ListTile(
                  title: Text(e.key),
                  trailing: Text("${e.value} times"),
                )),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
