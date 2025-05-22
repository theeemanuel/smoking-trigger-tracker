import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trigger_entry.dart';
import '../providers/app_state.dart';

class LogTriggerScreen extends StatefulWidget {
  const LogTriggerScreen({super.key});

  @override
  State<LogTriggerScreen> createState() => _LogTriggerScreenState();
}

class _LogTriggerScreenState extends State<LogTriggerScreen> {
  final _triggerController = TextEditingController();
  final _noteController = TextEditingController();
  bool _didSmoke = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log Trigger")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _triggerController,
              decoration: const InputDecoration(labelText: "Trigger (e.g. stress, party, etc)"),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: "Optional note"),
            ),
            SwitchListTile(
              title: const Text("Did you smoke?"),
              value: _didSmoke,
              onChanged: (val) => setState(() => _didSmoke = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final entry = TriggerEntry(
                  trigger: _triggerController.text,
                  didSmoke: _didSmoke,
                  note: _noteController.text.isEmpty ? null : _noteController.text,
                  timestamp: DateTime.now(),
                );
                Provider.of<AppState>(context, listen: false).addEntry(entry);
                Navigator.pop(context);
              },
              child: const Text("Save Entry"),
            )
          ],
        ),
      ),
    );
  }
}
