// import 'dart:math';
// import 'package:flutter/material.dart';

// class FishTankDecoration extends StatefulWidget {
//   const FishTankDecoration({super.key});

//   @override
//   State<FishTankDecoration> createState() => _FishTankDecorationState();
// }

// class _FishTankDecorationState extends State<FishTankDecoration> with TickerProviderStateMixin {
//   late final AnimationController _bubbleController;
//   late final List<_Bubble> _bubbles;

//   final List<String> bubbleAssets = [
//     'assets/fish/bubble_a.png',
//     'assets/fish/bubble_b.png',
//     'assets/fish/bubble_c.png',
//   ];

//   final List<String> seaweedAssets = [
//     'assets/fish/seaweed_green_a_outline.png',
//     'assets/fish/seaweed_pink_a_outline.png',
//     'assets/fish/seaweed_orange_a_outline.png',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _bubbleController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 6),
//     )..repeat();

//     final random = Random();
//     _bubbles = List.generate(6, (_) {
//       return _Bubble(
//         asset: bubbleAssets[random.nextInt(bubbleAssets.length)],
//         left: random.nextDouble() * 280,
//         startBottom: random.nextDouble() * 40,
//         size: 8 + random.nextDouble() * 16,
//         durationOffset: random.nextDouble(),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _bubbleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final random = Random();

//     return Stack(
//       children: [
//         // 🌿 Dynamic seaweed
//         for (int i = 0; i < 5; i++)
//           Positioned(
//             bottom: 0,
//             left: 20.0 + i * 50,
//             child: Image.asset(
//               seaweedAssets[random.nextInt(seaweedAssets.length)],
//               width: 30 + random.nextDouble() * 10,
//             ),
//           ),

//         // 🫧 Animated bubbles
//         AnimatedBuilder(
//           animation: _bubbleController,
//           builder: (_, __) {
//             return Stack(
//               children: _bubbles.map((b) {
//                 final progress = (_bubbleController.value + b.durationOffset) % 1.0;
//                 final verticalOffset = 100.0 * (1 - progress);
//                 return Positioned(
//                   bottom: b.startBottom + verticalOffset,
//                   left: b.left,
//                   child: Opacity(
//                     opacity: 1.0 - progress,
//                     child: Image.asset(b.asset, width: b.size),
//                   ),
//                 );
//               }).toList(),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// class _Bubble {
//   final String asset;
//   final double left;
//   final double startBottom;
//   final double size;
//   final double durationOffset;

//   _Bubble({
//     required this.asset,
//     required this.left,
//     required this.startBottom,
//     required this.size,
//     required this.durationOffset,
//   });
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/fish_image_map.dart';
import '../providers/app_state.dart';

class FishTankDecoration extends StatefulWidget {
  const FishTankDecoration({super.key});

  @override
  State<FishTankDecoration> createState() => _FishTankDecorationState();
}

class _FishTankDecorationState extends State<FishTankDecoration>
    with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;
  late List<Bubble> _bubbles;
  late List<Seaweed> _seaweeds;

  final List<String> bubbleAssets = [
    'assets/fish/bubble_a.png',
    'assets/fish/bubble_b.png',
    'assets/fish/bubble_c.png',
  ];

  final List<String> seaweedAssets = [
    'assets/fish/seaweed_green_a_outline.png',
    'assets/fish/seaweed_pink_a_outline.png',
    'assets/fish/seaweed_orange_a_outline.png',
  ];

  // Position of fish in the tank container
  final double fishLeft = 100; // adjust as needed
  final double fishBottom = 40; // adjust as needed

  // Offset of the fish mouth relative to fish image's left-bottom corner
  final double fishMouthOffsetX = 75; // approx from left of fish image
  final double fishMouthOffsetY = 40; // approx from bottom of fish image

  @override
  void initState() {
    super.initState();

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _generateBubbles();
    _generateSeaweed();
  }

  void _generateBubbles() {
    final rand = Random();
    _bubbles = List.generate(6, (i) {
      final size = [6.0, 10.0, 14.0][i % 3];
      final delay = rand.nextDouble();
      return Bubble(
        size: size,
        // Horizontal position is fish left + mouth offset + small random variation
        horizontalOffset: (fishLeft + fishMouthOffsetX + rand.nextDouble() * 10).toInt(),
        // Initial bottom is fish bottom + mouth offset + small random variation
        initialBottom: fishBottom + fishMouthOffsetY + rand.nextDouble() * 10,
        riseDuration: 4 + rand.nextInt(2),
        delay: delay,
        asset: bubbleAssets[i % bubbleAssets.length],
      );
    });
  }

  void _generateSeaweed() {
    final rand = Random();
    _seaweeds = List.generate(5, (i) {
      return Seaweed(
        asset: seaweedAssets[rand.nextInt(seaweedAssets.length)],
        left: rand.nextDouble() * 280,
        width: 30 + rand.nextDouble() * 10,
        bottomOffset: 0,
      );
    });
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final streak = state.currentStreak;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 300,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.blue.shade100.withOpacity(0.3),
          border: Border.all(color: Colors.blueGrey.shade300, width: 2),
        ),
        child: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Image.asset(
                'assets/fish/background_terrain.png',
                fit: BoxFit.cover,
              ),
            ),

            // Dynamic Seaweed
            ..._seaweeds.map((weed) => Positioned(
              bottom: weed.bottomOffset,
              left: weed.left,
              child: Image.asset(weed.asset, width: weed.width),
            )),

            // Animated Bubbles
            ..._bubbles.map((bubble) {
              return AnimatedBuilder(
                animation: _bubbleController,
                builder: (context, child) {
                  final progress =
                      (_bubbleController.value + bubble.delay) % 1.0;
                  final verticalOffset =
                      bubble.initialBottom - (1 - progress) * 80;

                  return Positioned(
                    bottom: verticalOffset,
                    left: bubble.horizontalOffset.toDouble(),
                    child: Opacity(
                      opacity: 1 - progress,
                      child: Image.asset(bubble.asset, width: bubble.size),
                    ),
                  );
                },
              );
            }),

            // Foreground Fish at fixed position
            Positioned(
              left: fishLeft,
              bottom: fishBottom,
              child: Image.asset(
                fishImageMap[state.currentFish!.type] ?? '',
                width: 120,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bubble {
  final double size;
  final int horizontalOffset;
  final double initialBottom;
  final int riseDuration;
  final double delay;
  final String asset;

  Bubble({
    required this.size,
    required this.horizontalOffset,
    required this.initialBottom,
    required this.riseDuration,
    required this.delay,
    required this.asset,
  });
}

class Seaweed {
  final String asset;
  final double left;
  final double width;
  final double bottomOffset;

  Seaweed({
    required this.asset,
    required this.left,
    required this.width,
    required this.bottomOffset,
  });
}

