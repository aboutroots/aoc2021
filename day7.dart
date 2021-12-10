import './utils.dart';
import 'dart:math';

int getStepsScore(int steps) {
  // part 1
  // return steps;

  // part 2
  // https://math.stackexchange.com/a/593320
  return ((steps * steps + steps) / 2).round();
}

int getScoreForPos(int pos, List<int> startingPositions) {
  return startingPositions.fold(0, (int score, int startingPos) {
    int steps = (pos - startingPos).abs();
    int stepsScore = getStepsScore(steps);
    return stepsScore + score;
  });
}

int solve(List<String> lines) {
  List<int> positions = lines[0].trim().split(',').map(int.parse).toList();
  int maxPos = positions.reduce(max);
  int minPos = positions.reduce(min);

  int bestScore = getScoreForPos(minPos, positions);

  for (int finalPos = minPos; finalPos <= maxPos; finalPos++) {
    int score = getScoreForPos(finalPos, positions);
    if (score < bestScore) {
      bestScore = score;
    }
  }
  return bestScore;
}

void main() async {
  List<String> lines = await readlines('day7.txt');
  int result = solve(lines);
  print(result);
}
