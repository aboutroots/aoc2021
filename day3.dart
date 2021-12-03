import './utils.dart';

int computeSimilarity(List input, List target) {
  int score = 0;
  for (int i = 0; i < target.length; i++) {
    if (target[i] != input[i]) {
      break;
    }
    score += 1;
  }
  return score;
}

void solve(List<String> lines) {
  List<int> acc = List.filled(lines[0].length, 0);
  List<List<int>> numbers = [];

  // Sum "ones" for every column, also save parsed lines to separate array
  lines.fold(acc, (List<int> accumulator, String line) {
    List<int> lineValues =
        line.trim().split('').map((String char) => int.parse(char)).toList();
    numbers.add(lineValues);

    lineValues.asMap().forEach((index, value) {
      accumulator[index] += value;
    });
    return accumulator;
  });

  // first part
  List<int> gammaArr = acc.map((e) => e > lines.length / 2 ? 1 : 0).toList();
  List<int> epsilonArr = acc.map((e) => e < lines.length / 2 ? 1 : 0).toList();

  print(int.parse(gammaArr.join(''), radix: 2) *
      int.parse(epsilonArr.join(''), radix: 2));

  // second part
  numbers.sort((a, b) =>
      computeSimilarity(a, gammaArr) - computeSimilarity(b, gammaArr));
  List<int> o2gen = numbers[0];
  numbers.sort((a, b) =>
      computeSimilarity(a, epsilonArr) - computeSimilarity(b, epsilonArr));
  List<int> co2scrub = numbers[0];
  print('$o2gen, $co2scrub');
}

void main() async {
  List<String> lines = await readlines('day3.txt');
  solve(lines);
}
