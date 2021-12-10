import './utils.dart';

class Entry {
  List<String> patterns;
  List<String> output;

  @override
  String toString() {
    return '[${this.output.join(', ')}]';
  }

  Entry(this.patterns, this.output);

  List<int> parseOutputToDigits() {
    return this.output.map((s) {
      if (s.length == 2) {
        return 1;
      }
      if (s.length == 3) {
        return 7;
      }
      if (s.length == 4) {
        return 4;
      }
      if (s.length == 7) {
        return 8;
      }
      return -1;
    }).toList();
  }
}

int solve(List<String> lines) {
  List<Entry> entries = lines.map((String line) {
    List<String> parts = line.trim().split(' | ');
    List<String> patterns = parts[0].split(' ');
    List<String> output = parts[1].split(' ');
    return Entry(patterns, output);
  }).toList();

  // first
  return entries.fold(0, (int counter, element) {
    return element
            .parseOutputToDigits()
            .fold(0, (int acc, int val) => acc + (val == -1 ? 0 : 1)) +
        counter;
  });
}

void main() async {
  List<String> lines = await readlines('day8.txt');
  int result = solve(lines);
  print(result);
}
