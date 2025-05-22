// import 'package:flutter/material.dart';
// import 'log_trigger_screen.dart';
// import 'package:provider/provider.dart';
// import '../providers/app_state.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import '../utils/fish_svgs.dart';
// // import '../utils/fish_image_map.dart';
// import 'statistics_screen.dart';
// import '../widgets/fish_tank_decoration.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final state = Provider.of<AppState>(context);
//     final streak = state.currentStreak;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dephase your smoke"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.bar_chart),
//             tooltip: "View Statistics",
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const StatisticsScreen()),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete_forever),
//             tooltip: "Clear All Logs",
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (ctx) => AlertDialog(
//                   title: const Text("Clear All Logs"),
//                   content: const Text("Are you sure you want to clear all logs?"),
//                   actions: [
//                     TextButton(
//                       child: const Text("Cancel"),
//                       onPressed: () => Navigator.of(ctx).pop(),
//                     ),
//                     TextButton(
//                       child: const Text("Clear"),
//                       onPressed: () {
//                         Provider.of<AppState>(context, listen: false).resetAll();
//                         Navigator.of(ctx).pop();
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (_) => const LogTriggerScreen()));
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//           Text("Current Streak: $streak", style: Theme.of(context).textTheme.headlineSmall),
//           const SizedBox(height: 20),
//           // 🐟 Show fish or encouragement
//           // if (state.currentFish != null)
//           //   Column(
//           //     children: [
//           //       Text("Your Fish: ${state.currentFish!.name}"),
//           //       const SizedBox(height: 10),
//           //       // SvgPicture.string(
//           //       //   fishSvgMap[state.currentFish!.type] ?? '',
//           //       //   width: 100,
//           //       //   height: 60,
//           //       // ),
//           //       Image.asset(
//           //         fishImageMap[state.currentFish!.type] ?? '',
//           //         width: 120,
//           //         height: 80,
//           //         fit: BoxFit.contain,
//           //       ),
//           //     ],
//           //   )
//           // else
//           //   const Text("No fish yet. Resist smoking to earn one!"),

//           if (state.currentFish != null)
//             const FishTankDecoration()
//           else
//             const Text("No fish yet. Resist smoking to earn one!"),

//           const SizedBox(height: 20),

//           // 📜 Show trigger entries
//           Expanded(
//             child: ListView.builder(
//               itemCount: state.entries.length,
//               itemBuilder: (context, index) {
//                 final e = state.entries.reversed.toList()[index];
//                 return ListTile(
//                   title: Text(e.trigger),
//                   subtitle: Text(e.timestamp.toString()),
//                   trailing: Icon(
//                     e.didSmoke ? Icons.warning : Icons.favorite,
//                     color: e.didSmoke ? Colors.red : Colors.green,
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'log_trigger_screen.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'statistics_screen.dart';
import '../widgets/fish_tank_decoration.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final currentStreak = state.currentStreak;
    final totalDays = state.streakDaysFromFirstTrigger;
    final triggersCount = state.entries.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dephase your smoke"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: "View Statistics",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatisticsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Clear All Logs",
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Clear All Logs"),
                  content: const Text("Are you sure you want to clear all logs?"),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    TextButton(
                      child: const Text("Clear"),
                      onPressed: () {
                        Provider.of<AppState>(context, listen: false).resetAll();
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LogTriggerScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Log Trigger"),
        elevation: 6,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFF80DEEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak & encouragement section
            Center(
              child: Column(
                children: [
                  Text(
                    "Current Streak",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.teal.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    "$totalDays days and $currentStreak triggers",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  // const SizedBox(height: 8),

                  // Text(
                  //   "Days since first trigger",
                  //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  //         color: Colors.teal.shade900,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  // ),
                  // Text(
                  //   "$totalDays days",
                  //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  //         color: Colors.teal.shade700,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  // ),

                  const SizedBox(height: 8),

                  Text(
                    triggersCount > 0
                        ? "Keep it up! You're doing great 🐠"
                        : "Start your journey today!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.teal.shade800,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Fish tank section
            const Text(
              "Your Fish Tank",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.shade100.withOpacity(0.7),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: state.currentFish != null
                    ? const FishTankDecoration()
                    : Container(
                        height: 150,
                        color: Colors.teal.shade50,
                        alignment: Alignment.center,
                        child: const Text(
                          "No fish yet. Resist smoking to earn one!",
                          style: TextStyle(fontSize: 16, color: Colors.teal),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // Triggers log header
            Text(
              "Your Triggers Log",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.teal.shade900,
              ),
            ),
            const SizedBox(height: 8),

            // Trigger entries list
            Expanded(
              child: triggersCount == 0
                  ? Center(
                      child: Text(
                        "No triggers logged yet.\nTap the '+' button to add one!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: triggersCount,
                      itemBuilder: (context, index) {
                        final e = state.entries.reversed.toList()[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            title: Text(
                              e.trigger,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: e.note != null && e.note!.trim().isNotEmpty
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.note!,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        e.timestamp.toString(),
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  )
                                : Text(
                                    e.timestamp.toString(),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                            trailing: Icon(
                              e.didSmoke ? Icons.warning : Icons.favorite,
                              color: e.didSmoke ? Colors.redAccent : Colors.green,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
