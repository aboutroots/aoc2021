import 'dart:math';

import 'package:tuple/tuple.dart';

import './utils.dart';

typedef Point = Tuple2<int, int>;

List<Point> getAdjacentPoints(int x, int y, List<List<int>> aMap) {
  List<Point> adjacents = [
    // tuple (y, x)
    Tuple2(0, -1),
    Tuple2(0, 1),
    Tuple2(-1, 0),
    Tuple2(1, 0),
  ];
  List<Point> nextPoints = [];
  for (var adj in adjacents) {
    try {
      int newX = x + adj.item2;
      int newY = y + adj.item1;
      int point = aMap[newY][newX];
      nextPoints.add(Tuple2(newY, newX));
    } on RangeError {
      continue;
    }
  }
  return nextPoints;
}

List<Point> getBasinRecursive(
    List<Point> prevTier, List<List<int>> aMap, Set<Point> usedPoints) {
  List<Point> nextTier = [];

  for (Point point in prevTier) {
    int currentVal = aMap[point.item1][point.item2];
    List<Point> nextTierForP =
        getAdjacentPoints(point.item2, point.item1, aMap).where((Point p) {
      int pVal = aMap[p.item1][p.item2];
      return pVal < 9 && !(usedPoints.contains(p));
    }).toList();
    nextTier += nextTierForP;
  }

  if (nextTier.length == 0) {
    return prevTier;
  }
  usedPoints.addAll(nextTier);
  List<Point> all =
      prevTier + getBasinRecursive(nextTier.toSet().toList(), aMap, usedPoints);
  return all.toSet().toList();
}

int solve(List<String> lines) {
  List<List<int>> lavaMap = lines.map((String line) {
    return line.trim().split('').map(int.parse).toList();
  }).toList();

  List<int> minPoints = [];
  List<Point> minPointsXY = [];

  for (int y = 0; y < lavaMap.length; y++) {
    for (int x = 0; x < lavaMap[0].length; x++) {
      int point = lavaMap[y][x];

      List<Tuple2> adjacentPoints = getAdjacentPoints(x, y, lavaMap);
      List<int> adjacentValues =
          adjacentPoints.map((t) => lavaMap[t.item1][t.item2]).toList();

      if (point < adjacentValues.reduce(min)) {
        minPoints.add(point);
        minPointsXY.add(Tuple2(y, x));
      }
    }
  }
  // part1
  // return minPoints.fold(0, (a, b) => a + b + 1);

  // part2
  List<List<Point>> basins = [];
  for (Point p in minPointsXY) {
    List<Point> basin = getBasinRecursive([p], lavaMap, Set());
    basins.add(basin);
  }

  List<int> sizes = basins.map((x) => x.length).toList();
  sizes.sort((a, b) => b.compareTo(a));
  return sizes.sublist(0, 3).reduce((a, b) => a * b);
}

void main() async {
  List<String> lines = await readlines('day9.txt');
  int result = solve(lines);
  print(result);
}
