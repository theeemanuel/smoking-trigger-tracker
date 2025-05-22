import 'package:flutter/material.dart';
import 'log_trigger_screen.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/fish_svgs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final streak = state.currentStreak;

    return Scaffold(
      appBar: AppBar(title: const Text("Smoke Control")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const LogTriggerScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text("Current Streak: $streak", style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          // 🐟 Show fish or encouragement
          if (state.currentFish != null)
            Column(
              children: [
                Text("Your Fish: ${state.currentFish!.name}"),
                const SizedBox(height: 10),
                SvgPicture.string(
                  fishSvgMap[state.currentFish!.type] ?? '',
                  width: 100,
                  height: 60,
                ),
              ],
            )
          else
            const Text("No fish yet. Resist smoking to earn one!"),

          const SizedBox(height: 20),

          // 📜 Show trigger entries
          Expanded(
            child: ListView.builder(
              itemCount: state.entries.length,
              itemBuilder: (context, index) {
                final e = state.entries.reversed.toList()[index];
                return ListTile(
                  title: Text(e.trigger),
                  subtitle: Text(e.timestamp.toString()),
                  trailing: Icon(
                    e.didSmoke ? Icons.warning : Icons.favorite,
                    color: e.didSmoke ? Colors.red : Colors.green,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
