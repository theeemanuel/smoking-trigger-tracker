import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

void main() {
  runApp(SmokingTriggerTrackerApp());
}

class SmokingTriggerTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smoking Trigger Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _triggerLogs = [];
  List<String> _customTriggers = [];

  final List<String> _defaultTriggers = [
    'Stress', 'Coffee', 'After Meal', 'Boredom', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getString('triggerLogs');
    final customs = prefs.getString('customTriggers');

    if (logs != null) {
      _triggerLogs = List<String>.from(json.decode(logs));
    }
    if (customs != null) {
      _customTriggers = List<String>.from(json.decode(customs));
    }
    setState(() {});
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('triggerLogs', json.encode(_triggerLogs));
    await prefs.setString('customTriggers', json.encode(_customTriggers));
  }

  void _logTrigger(String trigger, [String? note]) {
    final logEntry = '${DateTime.now().toLocal()} - $trigger'
        '${note != null && note.trim().isNotEmpty ? ' [${note.trim()}]' : ''}';
    setState(() {
      _triggerLogs.insert(0, logEntry);
    });
    _saveData();
  }

  void _addCustomTrigger(String newTrigger) {
    if (newTrigger.trim().isEmpty || _customTriggers.contains(newTrigger)) return;
    setState(() {
      _customTriggers.add(newTrigger);
    });
    _saveData();
  }

  void _showAddCustomTriggerDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Custom Trigger'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter new trigger'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              final input = controller.text.trim();
              if (input.isNotEmpty) {
                _addCustomTrigger(input);
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditTriggerDialog(int index) {
    final controller = TextEditingController(text: _customTriggers[index]);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Custom Trigger'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final updated = controller.text.trim();
              if (updated.isNotEmpty) {
                setState(() {
                  _customTriggers[index] = updated;
                });
                _saveData();
              }
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteCustomTrigger(int index) {
    setState(() {
      _customTriggers.removeAt(index);
    });
    _saveData();
  }

  void _promptNoteAndLog(String trigger) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Note (optional)'),
        content: TextField(
          controller: noteController,
          decoration: InputDecoration(hintText: 'E.g., had argument, felt anxious...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final note = noteController.text;
              Navigator.pop(context);
              _logTrigger(trigger, note);
            },
            child: Text('Log Trigger'),
          ),
        ],
      ),
    );
  }

  void _showTriggerOptions() {
    final triggers = [..._defaultTriggers, ..._customTriggers];
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        children: [
          ..._defaultTriggers.map((trigger) => ListTile(
                title: Text(trigger),
                onTap: () {
                  Navigator.pop(context);
                  _promptNoteAndLog(trigger);
                },
              )),
          if (_customTriggers.isNotEmpty) Divider(),
          ..._customTriggers.asMap().entries.map((entry) {
            final index = entry.key;
            final trigger = entry.value;
            return ListTile(
              title: Text(trigger),
              onTap: () {
                Navigator.pop(context);
                _promptNoteAndLog(trigger);
              },
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditTriggerDialog(index);
                  } else if (value == 'delete') {
                    _deleteCustomTrigger(index);
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            );
          }),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Custom Trigger'),
            onTap: () {
              Navigator.pop(context);
              _showAddCustomTriggerDialog();
            },
          ),
        ],
      ),
    );
  }

  void _clearLogs() {
    setState(() {
      _triggerLogs.clear();
    });
    _saveData();
  }

  Map<String, int> _getTriggerCounts() {
    final Map<String, int> counts = {};
    for (final entry in _triggerLogs) {
      final trigger = entry.split('-').last.trim();
      final name = trigger.split('[')[0].trim();
      counts[name] = (counts[name] ?? 0) + 1;
    }
    return counts;
  }

  Widget _buildBarChart() {
    final counts = _getTriggerCounts();
    final keys = counts.keys.toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.black87,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${keys[group.x]}: ${rod.toY.toInt()}',
                    TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < keys.length) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(keys[index], style: TextStyle(fontSize: 10)),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(keys.length, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: counts[keys[i]]!.toDouble(),
                    gradient: LinearGradient(colors: [Colors.teal, Colors.greenAccent]),
                    width: 20,
                    borderRadius: BorderRadius.circular(6),
                  )
                ],
                showingTooltipIndicators: [0],
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smoking Trigger Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearLogs,
            tooltip: 'Clear All Logs',
          ),
        ],
      ),
      body: _triggerLogs.isEmpty
          ? Center(child: Text('No triggers logged yet.'))
          : Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black87,
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: _triggerLogs.length,
                      itemBuilder: (_, index) => Text(
                        _triggerLogs[index],
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 250, child: _buildBarChart()),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTriggerOptions,
        child: Icon(Icons.add),
        tooltip: 'Log a Trigger',
      ),
    );
  }
}