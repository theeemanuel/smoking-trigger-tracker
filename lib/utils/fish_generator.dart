import '../models/fish.dart';

Fish getFishForStreak(int streak) {
  if (streak < 2) {
    return Fish(name: "Goldfish", type: "goldfish");
  } else if (streak < 5) {
    return Fish(name: "Clownfish", type: "clownfish");
  } else if (streak < 10) {
    return Fish(name: "Seahorse", type: "seahorse");
  } else if (streak < 20) {
    return Fish(name: "Jellyfish", type: "jellyfish");
  } else {
    return Fish(name: "Dragon Fish", type: "dragonfish");
  }
}
