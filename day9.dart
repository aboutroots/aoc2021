import 'dart:math';

import 'package:tuple/tuple.dart';

import './utils.dart';

int solve(List<String> lines) {
  List<List<int>> lavaMap = lines.map((String line) {
    return line.trim().split('').map(int.parse).toList();
  }).toList();

  List<int> minPoints = [];

  for (int y = 0; y < lavaMap.length; y++) {
    for (int x = 0; x < lavaMap[0].length; x++) {
      int point = lavaMap[y][x];
      List<Tuple2<int, int>> adjacents = [
        // tuple (y, x)
        Tuple2(0, -1),
        Tuple2(0, 1),
        Tuple2(-1, 0),
        Tuple2(1, 0),
      ];
      List<int> nextPoints = [];
      for (var adj in adjacents) {
        try {
          nextPoints.add(lavaMap[y + adj.item1][x + adj.item2]);
        } on RangeError {
          continue;
        }
      }
      if (point < nextPoints.reduce(min)) {
        // print("$point, $nextPoints");
        minPoints.add(point);
      }
    }
  }

  // print(minPoints);
  return minPoints.fold(0, (value, element) => value + element + 1);
}

void main() async {
  List<String> lines = await readlines('day9.txt');
  int result = solve(lines);
  print(result);
}
