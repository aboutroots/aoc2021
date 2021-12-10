import './utils.dart';

String sortString(String s) {
  var l = s.split('');
  l.sort();
  return l.join('');
}

String diffStrings(String a, String b) {
  Set charsA = new Set.from(a.split(''));
  Set charsB = new Set.from(b.split(''));
  return charsA.difference(charsB).join('');
}

List<int> toDigits(Entry e) {
  List<String> patterns = e.patterns;

  String one = patterns.firstWhere((p) => p.length == 2);
  String four = patterns.firstWhere((p) => p.length == 4);
  String seven = patterns.firstWhere((p) => p.length == 3);
  String eight = patterns.firstWhere((p) => p.length == 7);
  String nine = patterns.firstWhere((p) =>
      p.length == 6 &&
      diffStrings(seven, p) == '' &&
      diffStrings(four, p) == '');
  String zero = patterns.firstWhere(
      (p) => p.length == 6 && diffStrings(seven, p) == '' && p != nine);
  String six =
      patterns.firstWhere((p) => p.length == 6 && p != nine && p != zero);
  String three =
      patterns.firstWhere((p) => p.length == 5 && diffStrings(one, p) == '');
  String five =
      patterns.firstWhere((p) => p.length == 5 && diffStrings(p, six) == '');
  String two =
      patterns.firstWhere((p) => p.length == 5 && p != five && p != three);

  Map<String, int> digitMap = {
    zero: 0,
    one: 1,
    two: 2,
    three: 3,
    four: 4,
    five: 5,
    six: 6,
    seven: 7,
    eight: 8,
    nine: 9
  };

  return e.output.map((p) => digitMap[p]).toList();
}

class Entry {
  List<String> patterns;
  List<String> output;

  Entry(this.patterns, this.output);
}

int solve(List<String> lines) {
  List<Entry> entries = lines.map((String line) {
    List<String> parts = line.trim().split(' | ');
    List<String> patterns = parts[0].split(' ').map(sortString).toList();
    List<String> output = parts[1].split(' ').map(sortString).toList();
    return Entry(patterns, output);
  }).toList();

  return entries.fold(0, (int count, Entry e) {
    return count + int.parse(toDigits(e).join(''));
  });
}

void main() async {
  List<String> lines = await readlines('day8.txt');
  int result = solve(lines);
  print(result);
}
