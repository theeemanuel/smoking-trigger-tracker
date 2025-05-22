import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/trigger_entry.dart';
import '../models/fish.dart';
import '../utils/fish_generator.dart';

class AppState extends ChangeNotifier {
  List<TriggerEntry> _entries = [];

  List<TriggerEntry> get entries => _entries;

  Fish? _currentFish;
  Fish? get currentFish => _currentFish;

  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('trigger_entries') ?? [];
    _entries = data.map((e) => TriggerEntry.fromJson(jsonDecode(e))).toList();

    // Compute streak and set currentFish accordingly
    final streak = currentStreak;
    if (streak > 0) {
      _currentFish = getFishForStreak(streak);
    } else {
      _currentFish = null;
    }

    notifyListeners();
  }

  Future<void> addEntry(TriggerEntry entry) async {
    _entries.add(entry);
    if (entry.didSmoke) {
      _currentFish = null; // fish dies
    } else {
      _currentFish = getFishForStreak(currentStreak); // updated streak
    }
    await saveEntries();
    notifyListeners();
  }

  Future<void> saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('trigger_entries', data);
  }

  Future<void> resetAll() async {
    _entries.clear();
    _currentFish = null; // Reset fish when logs cleared
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('trigger_entries');
    notifyListeners();
  }

  int get currentStreak {
    int count = 0;
    for (var e in _entries.reversed) {
      if (e.didSmoke) break;
      count++;
    }
    return count;
  }

  List<String> get recentTriggers {
    final unique = <String>{};
    final recent = <String>[];

    for (var e in _entries.reversed) {
      if (e.trigger.trim().isEmpty) continue;
      if (unique.add(e.trigger)) {
        recent.add(e.trigger);
      }
      if (recent.length >= 5) break;
    }
    return recent;
  }

  /// New getter to calculate streak days from first trigger date
  int get streakDaysFromFirstTrigger {
    if (_entries.isEmpty) return 0;

    // Find earliest date ignoring time part
    final firstDate = _entries
        .map((e) => DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day))
        .reduce((a, b) => a.isBefore(b) ? a : b);

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final diff = todayDate.difference(firstDate).inDays + 1; // +1 to include start day

    return diff;
  }
}
