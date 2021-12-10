import './utils.dart';

/// The trick is to count how many fishes of each age are there, instead of
/// keeping each single one in a list
int solve(List<String> lines) {
  List<int> ages = lines[0].trim().split(',').map(int.parse).toList();
  Map<int, int> agesMap = ages.fold({}, (Map<int, int> acc, int val) {
    acc.putIfAbsent(val, () => 0);
    acc[val] += 1;
    return acc;
  });

  for (int i = 0; i <= 8; i++) {
    // fill with zeros for all numbers in range so we don't have to deal with
    // this later
    agesMap.putIfAbsent(i, () => 0);
  }

  int maxDay = 256;

  for (int day = 1; day <= maxDay; day++) {
    Map<int, int> newAgesMap = new Map<int, int>.from(agesMap);

    agesMap.forEach((int age, int counter) {
      if (counter == 0) {
        return;
      }
      newAgesMap[age] -= counter;
      if (age == 0) {
        newAgesMap[8] += counter;
        newAgesMap[6] += counter;
      } else {
        newAgesMap[age - 1] += counter;
      }
    });
    agesMap = newAgesMap;
  }
  return agesMap.values.reduce((int sum, element) => sum + element);
}

void main() async {
  List<String> lines = await readlines('day6.txt');
  int result = solve(lines);
  print(result);
}
