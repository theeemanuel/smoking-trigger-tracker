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

  void _logTrigger(String trigger) {
    setState(() {
      _triggerLogs.insert(0, '${DateTime.now().toLocal()} - $trigger');
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
                  _logTrigger(trigger);
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
                _logTrigger(trigger);
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
      counts[trigger] = (counts[trigger] ?? 0) + 1;
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
                    color: Colors.teal,
                    width: 18,
                    borderRadius: BorderRadius.circular(4),
                  )
                ],
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
                SizedBox(height: 250, child: _buildBarChart()),
                Expanded(
                  child: ListView.builder(
                    itemCount: _triggerLogs.length,
                    itemBuilder: (_, index) => ListTile(
                      title: Text(_triggerLogs[index]),
                    ),
                  ),
                ),
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