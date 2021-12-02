import './utils.dart';

class Command {
  String name;
  int value;

  @override
  String toString() {
    return "Cmd($name, $value)";
  }

  Command(this.name, this.value);
}

class Position {
  int x;
  int y;
  int aim;
  Position(this.x, this.y, this.aim);

  @override
  String toString() {
    return "Pos(x:$x, y:$y, aim:$aim)";
  }

  applyCommand(Command cmd) {
    switch (cmd.name) {
      case 'down':
        {
          this.aim += cmd.value;
        }
        break;

      case 'up':
        {
          this.aim -= cmd.value;
        }
        break;

      case 'forward':
        {
          this.x += cmd.value;
          this.y += this.aim * cmd.value;
        }
        break;
    }
  }
}

List<Command> linesToCommands(List<String> lines) {
  return lines.map((line) {
    List<String> args = line.trim().split(' ');
    return Command(args[0], int.parse(args[1]));
  }).toList();
}

int solve(List<String> lines) {
  List<Command> commands = linesToCommands(lines);
  Position pos = Position(0, 0, 0);
  commands.forEach((cmd) {
    pos.applyCommand(cmd);
  });
  return pos.x * pos.y;
}

void main() async {
  List<String> lines = await readlines('day2.txt');
  int result = solve(lines);
  print(result);
}
