import './utils.dart';
import 'package:tuple/tuple.dart';

String filterByIndex(
    List<String> numbers, int index, String atu, String operation) {
  if (numbers.length == 1) {
    return numbers[0];
  }
  int targetCounter = numbers.fold(0, (int acc, String n) {
    return acc + int.parse(n[index]);
  });

  String targetChar = targetCounter < numbers.length / 2 ? '1' : '0';
  if (operation == 'gt') {
    targetChar = targetCounter > numbers.length / 2 ? '1' : '0';
  }

  if (targetCounter == numbers.length / 2) {
    targetChar = atu;
  }

  return filterByIndex(
      numbers.where((String n) => n[index] == targetChar).toList(),
      index + 1,
      atu,
      operation);
}

void solve(List<String> lines) {
  List<int> acc = List.filled(lines[0].length, 0);
  List<String> numbers = [];

  // Sum "ones" for every column, also save parsed lines to separate array
  lines.fold(acc, (List<int> accumulator, String line) {
    List<int> lineValues =
        line.trim().split('').map((String char) => int.parse(char)).toList();
    numbers.add(lineValues.join(''));

    lineValues.asMap().forEach((index, value) {
      accumulator[index] += value;
    });
    return accumulator;
  });

  // first part
  String gammaStr =
      acc.map((e) => e > lines.length / 2 ? 1 : 0).toList().join('');
  String epsilonStr =
      acc.map((e) => e < lines.length / 2 ? 1 : 0).toList().join('');

  print(int.parse(gammaStr, radix: 2) * int.parse(epsilonStr, radix: 2));

  // second part
  String o2genStr = filterByIndex(numbers, 0, '1', 'gt');
  String co2scrubStr = filterByIndex(numbers, 0, '0', 'lt');

  print(int.parse(o2genStr, radix: 2) * int.parse(co2scrubStr, radix: 2));
}

void main() async {
  List<String> lines = await readlines('day3.txt');
  solve(lines);
}
