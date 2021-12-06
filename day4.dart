import './utils.dart';

class Board {
  List<List<int>> data;
  Board(this.data);

  bool checkBingo() {
    // check rows
    if (this.data.any((row) => row.every((n) => n == -1))) {
      return true;
    }
    // check cols
    for (int colIdx = 0; colIdx < this.data[0].length; colIdx++) {
      List<int> col = this.data.map((row) => row[colIdx]).toList();
      if (col.every((n) => n == -1)) {
        return true;
      }
    }
    return false;
  }

  bool markNumber(int number) {
    for (int rowIdx = 0; rowIdx < this.data.length; rowIdx++) {
      for (int colIdx = 0; colIdx < this.data[0].length; colIdx++) {
        if (this.data[rowIdx][colIdx] == number) {
          this.data[rowIdx][colIdx] = -1;
        }
      }
    }
  }

  int getScore() {
    return this.data.fold(0, (int acc, List<int> row) {
      return acc +
          row.fold(0, (rowAcc, int number) {
            return number != -1 ? rowAcc + number : rowAcc;
          });
    });
  }

  @override
  String toString() {
    return this.data.join('\n');
  }
}

int solve(List<String> lines) {
  // parse input data
  List<int> order = lines[0].trim().split(',').map(int.parse).toList();
  List<Board> boards = [];
  for (int i = 2; i < lines.length; i += 6) {
    List<List<int>> boardData = [];
    for (int j = 0; j < 5; j++) {
      boardData.add(
          lines[i + j].trim().split(RegExp('\\s+')).map(int.parse).toList());
    }
    boards.add(Board(boardData));
  }

  // first part (uncomment to run)

  // for (int number in order) {
  //   for (Board board in boards) {
  //     board.markNumber(number);
  //     bool bingo = board.checkBingo();
  //     if (bingo) {
  //       return board.getScore() * number;
  //     }
  //   }
  // }

  // second part
  List<bool> winners = List.filled(boards.length, false);
  for (int number in order) {
    for (var entry in boards.asMap().entries) {
      entry.value.markNumber(number);
      bool bingo = entry.value.checkBingo();
      if (bingo) {
        winners[entry.key] = true;
      }
      bool allFinished = winners.every((element) => element == true);
      if (allFinished) {
        return entry.value.getScore() * number;
      }
    }
  }

  return 0;
}

void main() async {
  List<String> lines = await readlines('day4.txt');
  int result = solve(lines);
  print(result);
}
