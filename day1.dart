import './utils.dart';

final int WINDOW_SIZE = 3;

int computeWindow(List<String> lines, int endPosition, int windowSize) {
  int windowCounter = 0;
  for (int y = endPosition; y > (endPosition - windowSize); y--) {
    windowCounter += int.parse(lines[y]);
  }
  return windowCounter;
}

int solve(List<String> lines) {
  int counter = 0;

  for (int x = WINDOW_SIZE; x < lines.length; x++) {
    int measureA = computeWindow(lines, x, WINDOW_SIZE);
    int measureB = computeWindow(lines, x - 1, WINDOW_SIZE);
    bool isDeeper = measureB < measureA;
    if (isDeeper) {
      counter++;
    }
  }

  return counter;
}

void main() async {
  List<String> lines = await readlines('day1.txt');
  int result = solve(lines);
  print(result);
}
