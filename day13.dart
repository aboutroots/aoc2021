import 'package:tuple/tuple.dart';

import './utils.dart';

enum Axis { x, y }

typedef Point = Tuple2<int, int>; // x, y
typedef Fold = Tuple2<Axis, int>; // axis, value

List<Point> foldPoints(Fold f, List<Point> points) {
  return points
      .map((p) {
        int x = p.item1;
        int y = p.item2;
        int foldValue = f.item2;

        if (f.item1 == Axis.y) {
          int foldPositionDiff = y - foldValue;
          if (foldPositionDiff > 0) {
            int newY = foldValue - foldPositionDiff;
            return Point(x, newY);
          }
        } else {
          int foldPositionDiff = x - foldValue;
          if (foldPositionDiff > 0) {
            int newX = foldValue - foldPositionDiff;
            return Point(newX, y);
          }
        }
        return p;
      })
      .toSet()
      .toList();
}

void printPoints(List<Point> points) {
  points.sort((a, b) => b.item1 - a.item1);
  int maxX = points[0].item1;
  points.sort((a, b) => b.item2 - a.item2);
  int maxY = points[0].item2;

  List<List<String>> visual = [];

  for (int y = 0; y <= maxY; y++) {
    visual.add([]);
    for (int x = 0; x <= maxX; x++) {
      visual[y].add(' ');
    }
  }

  points.forEach((p) {
    visual[p.item2][p.item1] = 'X';
  });

  print('');
  visual.forEach((row) {
    print(row);
  });
}

int solve(List<String> lines) {
  List<Point> points = [];
  List<Fold> folds = [];

  lines.forEach((String line) {
    if (line.startsWith('fold')) {
      var splits = line.trim().split('fold along ');
      var splits2 = splits[1].trim().split('=');
      Axis axis = splits2[0] == 'x' ? Axis.x : Axis.y;
      folds.add(Fold(axis, int.parse(splits2[1])));
    } else if (line.trim().length > 0) {
      var splits = line.trim().split(',').map(int.parse).toList();
      points.add(Point(splits[0], splits[1]));
    }
  });

  // first
  Fold firstFold = folds[0];
  print(foldPoints(firstFold, points).length);

  // second
  for (Fold f in folds) {
    points = foldPoints(f, points);
  }
  printPoints(points);

  return 0;
}

void main() async {
  List<String> lines = await readlines('day13.txt');
  int result = solve(lines);
  print(result);
}
