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

  InputDecoration _roundedInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Rounded edges
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final existingTriggers = Provider.of<AppState>(context)
        .entries
        .map((e) => e.trigger)
        .toSet()
        .toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(title: const Text("Log Trigger")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Trigger input and quick select
            TextField(
              controller: _triggerController,
              decoration: _roundedInputDecoration("Trigger (e.g. stress, party, etc)"),
            ),
            const SizedBox(height: 12),
            if (existingTriggers.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: existingTriggers.map((t) {
                  return ActionChip(
                    label: Text(t),
                    onPressed: () => setState(() {
                      _triggerController.text = t;
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Optional note field
            TextField(
              controller: _noteController,
              maxLines: 4,
              minLines: 2,
              decoration: _roundedInputDecoration("Optional note"),
            ),

            const SizedBox(height: 20),

            // Did you smoke switch
            SwitchListTile(
              title: const Text("Did you smoke?"),
              value: _didSmoke,
              onChanged: (val) => setState(() => _didSmoke = val),
            ),

            const SizedBox(height: 20),

            // Save button
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       final entry = TriggerEntry(
            //         trigger: _triggerController.text.trim(),
            //         didSmoke: _didSmoke,
            //         note: _noteController.text.trim().isEmpty
            //             ? null
            //             : _noteController.text.trim(),
            //         timestamp: DateTime.now(),
            //       );
            //       Provider.of<AppState>(context, listen: false).addEntry(entry);
            //       Navigator.pop(context);
            //     },
            //     child: const Text("Save Entry"),
            //   ),
            // ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Save Entry"),
                onPressed: () {
                  final rawTrigger = _triggerController.text.trim();
                  final cleanedTrigger = rawTrigger.isEmpty ? 'null' : rawTrigger;

                  final entry = TriggerEntry(
                    trigger: cleanedTrigger,
                    didSmoke: _didSmoke,
                    note: _noteController.text.trim().isEmpty
                        ? null
                        : _noteController.text.trim(),
                    timestamp: DateTime.now(),
                  );

                  Provider.of<AppState>(context, listen: false).addEntry(entry);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
