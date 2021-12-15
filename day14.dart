import 'dart:math';

import 'package:tuple/tuple.dart';

import './utils.dart';

typedef Pair = Tuple2<String, String>;

int getLetterCount(Map<Pair, int> pairsCounter, String lastLetter, String x) {
  int count = pairsCounter.entries.fold(0, (int count, entry) {
    if (entry.key.item1 == x) {
      return count + entry.value;
    }
    return count;
  });
  int modifier = x == lastLetter ? 1 : 0;
  return count.round() + modifier;
}

List<String> getLetters(List<Pair> pairs) {
  List<String> result = [];
  pairs.forEach((p) {
    result.add(p.item1);
    result.add(p.item2);
  });
  return result.toSet().toList();
}

int solve(List<String> lines) {
  // get initial pairs
  Map<Pair, int> pairsCounter = {};
  String polymer = lines[0];
  for (int i = 0; i < polymer.length; i++) {
    if (i + 1 < polymer.length) {
      Pair p = Pair(polymer[i], polymer[i + 1]);

      pairsCounter[p] = pairsCounter[p] != null ? pairsCounter[p]! + 1 : 1;
    }
  }
  String lastLetter = polymer[polymer.length - 1]; // this will be useful too

  // get rules
  Map<Pair, List<Pair>> rules = lines.sublist(2).fold({}, (acc, line) {
    List<String> parts = line.split(' -> ');
    Pair initial = Pair(parts[0][0], parts[0][1]);
    Pair out1 = Pair(initial.item1, parts[1]);
    Pair out2 = Pair(parts[1], initial.item2);
    acc[initial] = [out1, out2];
    return acc;
  });

  int STEPS = 40;

  List<String> letters;

  // make transformations, for each pair new 2 pairs grows
  for (int i = 0; i < STEPS; i++) {
    Map<Pair, int> newPairsCounter = {};
    pairsCounter.entries.forEach((entry) {
      var outputs = rules[entry.key] ?? [];
      int increment = entry.value;
      for (Pair o in outputs) {
        newPairsCounter[o] = newPairsCounter[o] != null
            ? newPairsCounter[o]! + increment
            : increment;
      }
    });
    pairsCounter = newPairsCounter;
  }

  // count the number of occurences of each letter
  letters = getLetters(pairsCounter.keys.toList());
  Map<String, int> letterCount = {};
  letters.forEach((String l) {
    letterCount[l] = getLetterCount(pairsCounter, lastLetter, l);
  });

  return letterCount.values.reduce(max) - letterCount.values.reduce(min);
}

void main() async {
  List<String> lines = await readlines('day14.txt');
  int result = solve(lines);
  print(result);
}
