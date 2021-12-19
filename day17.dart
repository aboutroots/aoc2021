import 'package:tuple/tuple.dart';

import './utils.dart';

typedef Pair = Tuple2<int, int>;
typedef Area2d = Tuple4<int, int, int, int>; // x1, x2, y1 (max depth), y2

Tuple2<bool, int> shotAtTarget(Pair vxy, Area2d target) {
  int vx = vxy.item1;
  int vy = vxy.item2;
  int x = 0;
  int y = 0;
  int maxY = 0;
  bool success = false;
  while (true) {
    x += vx;
    y += vy;
    if (y > maxY) {
      maxY = y;
    }

    if (vx > 0) {
      vx -= 1;
    } else if (vx > 0) {
      vx += 1;
    }
    vy -= 1;

    bool hit = x >= target.item1 &&
        x <= target.item2 &&
        y >= target.item3 &&
        y <= target.item4;

    if (hit) {
      success = true;
      break;
    }

    bool tooFar = x > target.item2 || y < target.item3;
    if (tooFar) {
      break;
    }
  }
  return Tuple2<bool, int>(success, maxY);
}

int solve(List<String> lines) {
  List<String> parts = lines[0].trim().split(', y=');
  List<int> xparts =
      parts[0].split('target area: x=')[1].split('..').map(int.parse).toList();
  List<int> yparts = parts[1].split('..').map(int.parse).toList();
  Area2d targetArea = Area2d(xparts[0], xparts[1], yparts[0], yparts[1]);

  int maxY = 0;
  int successes = 0;
  final int RANGE = 1000;
  for (int vx = 0; vx < RANGE; vx++) {
    for (int vy = -RANGE; vy < RANGE; vy++) {
      var result = shotAtTarget(Pair(vx, vy), targetArea);
      if (result.item1) {
        successes += 1;
        if (result.item2 > maxY) {
          maxY = result.item2;
        }
      }
    }
  }

  // part1
  // return maxY;
  // part2
  return successes;
}

void main() async {
  List<String> lines = await readlines('day17.txt');
  int result = solve(lines);
  print(result);
}
