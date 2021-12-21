import 'package:tuple/tuple.dart';

import './utils.dart';

typedef MAP = List<List<int>>;
typedef Point = Tuple2<int, int>;

List<Point> getSurrondings(Point p) {
  return [
    Point(p.item1 - 1, p.item2 - 1),
    Point(p.item1 - 1, p.item2),
    Point(p.item1 - 1, p.item2 + 1),
    Point(p.item1, p.item2 - 1),
    Point(p.item1, p.item2 + 1),
    Point(p.item1 + 1, p.item2 - 1),
    Point(p.item1 + 1, p.item2),
    Point(p.item1 + 1, p.item2 + 1),
  ];
}

MAP flash(MAP inputMap) {
  MAP newMap = List.from(inputMap);

  List<Point> pointsToFlash = [];

  while (true) {
    // find points that will be flashing
    for (var y in newMap.asMap().keys) {
      for (var x in newMap[y].asMap().keys) {
        if (newMap[y][x] == 10) {
          pointsToFlash.add(Point(x, y));
        }
      }
    }

    // no points? return
    if (pointsToFlash.length == 0) {
      break;
    }

    // increment surroundings
    for (Point f in pointsToFlash) {
      newMap[f.item2][f.item1] += 1;
      for (Point p in getSurrondings(f)) {
        try {
          int currVal = newMap[p.item2][p.item1];

          // this is important - do not increment "10" because you will miss
          // a flash in the next turn!
          if (currVal != 10) {
            newMap[p.item2][p.item1] += 1;
          }
        } catch (e) {
          continue;
        }
      }
    }
    pointsToFlash = [];
  }

  // assign zeros to flashed points
  for (var y in newMap.asMap().keys) {
    for (var x in newMap[y].asMap().keys) {
      if (newMap[y][x] > 9) {
        newMap[y][x] = 0;
      }
    }
  }

  return newMap;
}

MAP makeStep(MAP inputMap) {
  // increase energy
  inputMap = inputMap
      .map((row) => row.map((x) {
            return x + 1;
          }).toList())
      .toList();

  // make flashes
  return flash(inputMap);
}

int solve(List<String> lines) {
  MAP aMap =
      lines.map((line) => line.split('').map(int.parse).toList()).toList();

  int counterFirst = 0;

  int step = 0;
  while (true) {
    // part1
    // if (step == 100) {
    //   return counterFirst;
    // }
    //

    aMap = makeStep(aMap);
    counterFirst += aMap.fold(
        0, (int acc, var row) => acc + row.where((x) => x == 0).length);
    bool isFullFlash = aMap.every((row) => row.every((x) => x == 0));
    step += 1;

    // part 2
    if (isFullFlash) {
      return step;
    }
  }
}

void main() async {
  List<String> lines = await readlines('day11.txt');
  int result = solve(lines);
  print(result);
}
