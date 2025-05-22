import '../models/fish.dart';

// Fish getFishForStreak(int streak) {
//   if (streak < 2) {
//     return Fish(name: "Goldfish", type: "goldfish");
//   } else if (streak < 5) {
//     return Fish(name: "Clownfish", type: "clownfish");
//   } else if (streak < 10) {
//     return Fish(name: "Seahorse", type: "seahorse");
//   } else if (streak < 20) {
//     return Fish(name: "Jellyfish", type: "jellyfish");
//   } else {
//     return Fish(name: "Dragon Fish", type: "dragonfish");
//   }
// }

// Fish getFishForStreak(int streak) {
//   if (streak < 2) {
//     return Fish(name: "Blue Fish", type: "blue");
//   } else if (streak < 5) {
//     return Fish(name: "Green Fish", type: "green");
//   } else if (streak < 10) {
//     return Fish(name: "Red Fish", type: "red");
//   } else if (streak < 20) {
//     return Fish(name: "Orange Fish", type: "orange");
//   } else {
//     return Fish(name: "Pink Fish", type: "pink");
//   }
// }

// Fish getFishForStreak(int streak) {
//   if (streak < 2) {
//     return Fish(name: "Pink Fish Skeleton", type: "pink_skeleton");
//   } else if (streak < 4) {
//     return Fish(name: "Pink Fish", type: "pink");
//   } else if (streak < 8) {
//     return Fish(name: "Pink Fish Defined", type: "pink_defined");
//   } else if (streak < 16) {
//     return Fish(name: "Blue Fish Skeleton", type: "blue_skeleton");
//   } else if (streak < 32) {
//     return Fish(name: "Blue Fish", type: "blue");
//   } else if (streak < 64) {
//     return Fish(name: "Blue Fish Defined", type: "blue_defined");
//   } else if (streak < 128) {
//     return Fish(name: "Green Fish Skeleton", type: "green_skeleton");
//   } else if (streak < 256) {
//     return Fish(name: "Green Fish", type: "green");
//   } else if (streak < 512) {
//     return Fish(name: "Green Fish Defined", type: "green_defined");
//   } else if (streak < 1024) {
//     return Fish(name: "Red Fish Skeleton", type: "red_skeleton");
//   } else if (streak < 2048) {
//     return Fish(name: "Red Fish", type: "red");
//   } else if (streak < 4096) {
//     return Fish(name: "Red Fish Defined", type: "red_defined");
//   } else if (streak < 8192) {
//     return Fish(name: "Brown Fish", type: "brown");
//   } else if (streak < 16384) {
//     return Fish(name: "Brown Fish Defined", type: "brown_defined");
//   } else {
//     return Fish(name: "Brown Fish Defined", type: "brown_defined");
//   }
// }

//tester
Fish getFishForStreak(int streak) {
  if (streak < 1) {
    return Fish(name: "Pink Fish Skeleton", type: "pink_skeleton");
  } else if (streak < 2) {
    return Fish(name: "Pink Fish", type: "pink");
  } else if (streak < 3) {
    return Fish(name: "Pink Fish Defined", type: "pink_defined");
  } else if (streak < 4) {
    return Fish(name: "Blue Fish Skeleton", type: "blue_skeleton");
  } else if (streak < 5) {
    return Fish(name: "Blue Fish", type: "blue");
  } else if (streak < 6) {
    return Fish(name: "Blue Fish Defined", type: "blue_defined");
  } else if (streak < 7) {
    return Fish(name: "Green Fish Skeleton", type: "green_skeleton");
  } else if (streak < 8) {
    return Fish(name: "Green Fish", type: "green");
  } else if (streak < 9) {
    return Fish(name: "Green Fish Defined", type: "green_defined");
  } else if (streak < 10) {
    return Fish(name: "Red Fish Skeleton", type: "red_skeleton");
  } else if (streak < 11) {
    return Fish(name: "Red Fish", type: "red");
  } else if (streak < 12) {
    return Fish(name: "Red Fish Defined", type: "red_defined");
  } else if (streak < 13) {
    return Fish(name: "Brown Fish", type: "brown");
  } else if (streak < 14) {
    return Fish(name: "Brown Fish Defined", type: "brown_defined");
  } else {
    return Fish(name: "Brown Fish Defined", type: "brown_defined");
  }
}