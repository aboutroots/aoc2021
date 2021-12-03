import './utils.dart';

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
}

void main() async {
  List<String> lines = await readlines('day3.txt');
  solve(lines);
}
