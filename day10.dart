import './utils.dart';

Map<String, String> matches = {
  '{': '}',
  '(': ')',
  '<': '>',
  '[': ']',
};

Map<String, int> rewards = {
  ')': 3,
  ']': 57,
  '}': 1197,
  '>': 25137,
};

Map<String, int> rewards2 = {
  ')': 1,
  ']': 2,
  '}': 3,
  '>': 4,
};

int solve(List<String> lines) {
  List<String> illegal = [];

  // first
  lines.forEach((line) {
    List<String> stack = [];
    for (int i = 0; i < line.length; i++) {
      String c = line[i];
      if (['[', '(', '{', '<'].contains(c)) {
        stack.add(c);
      } else {
        String opening = stack.removeLast();
        if (matches[opening] != c) {
          illegal.add(c);
          break;
        }
      }
    }
  });

  // return illegal.fold(0, (int acc, String c) {
  //   return acc + rewards[c]!;
  // });

  // second

  List<List<String>> endings = [];

  lines.forEach((line) {
    List<String> stack = [];
    for (int i = 0; i < line.length; i++) {
      String c = line[i];
      if (['[', '(', '{', '<'].contains(c)) {
        stack.add(c);
      } else {
        String opening = stack.removeLast();
        if (matches[opening] != c) {
          stack = [];
          break;
        }
      }
    }
    if (stack.length > 0) {
      endings.add(
          new List.from(stack.map((c) => matches[c] ?? '').toList().reversed));
    }
  });

  List<int> scores = endings.map((ending) {
    return ending.fold(0, (int acc, String c) {
      return acc * 5 + rewards2[c]!;
    });
  }).toList();

  scores.sort((a, b) => a - b);
  return scores[(scores.length / 2).round() - 1];
}

void main() async {
  List<String> lines = await readlines('day10.txt');
  int result = solve(lines);
  print(result);
}
