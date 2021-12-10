import 'package:tuple/tuple.dart';

import './utils.dart';

class Vec {
  int x0;
  int y0;
  int x1;
  int y1;
  Vec(this.x0, this.y0, this.x1, this.y1);

  @override
  String toString() {
    return 'Vec($x0,$y0) -> ($x1,$y1)';
  }

  bool isDiagonal() {
    return this.x0 != this.x1 && this.y0 != this.y1;
  }

  List<Tuple2<int, int>> getPoints() {
    List<Tuple2<int, int>> points = [];
    int startX = this.x0 < this.x1 ? this.x0 : this.x1;
    int startY = this.y0 < this.y1 ? this.y0 : this.y1;
    int endX = startX == this.x0 ? this.x1 : this.x0;
    int endY = startY == this.y0 ? this.y1 : this.y0;
    for (int x = startX; x <= endX; x++) {
      for (int y = startY; y <= endY; y++) {
        points.add(Tuple2(x, y));
      }
    }
    return points;
  }
}

int solve(List<String> rows) {
  List<Vec> lines = rows.map((String row) {
    List<String> ends = row.trim().split(' -> ');
    List<int> start = ends[0].split(',').map(int.parse).toList();
    List<int> end = ends[1].split(',').map(int.parse).toList();
    return Vec(start[0], start[1], end[0], end[1]);
  }).toList();

  // first part
  List<Vec> nonDiagonal = lines.where((v) => !v.isDiagonal()).toList();
  Set<Tuple2<int, int>> points = Set();
  Set<Tuple2<int, int>> overlapped = Set();
  int overlaps = 0;
  nonDiagonal.forEach((line) {
    line.getPoints().forEach((point) {
      if (points.contains(point) && !overlapped.contains(point)) {
        overlaps++;
        overlapped.add(point);
      }
      points.add(point);
    });
  });
  // solve me!
  return overlaps;
}

void main() async {
  List<String> lines = await readlines('day5.txt');
  int result = solve(lines);
  print(result);
}
