import './utils.dart';

List<List<Node>> findPaths(Node start, List<Node> currPath, Node bonusCave) {
  List<List<Node>> paths = [];

  // here we define rules for available connections
  List<Node> availableConns = start.connections.where((n) {
    bool bonus =
        n == bonusCave && currPath.where((x) => x == n).toList().length < 2;
    return !currPath.contains(n) || n.name == n.name.toUpperCase() || bonus;
  }).toList();

  List<Node> newCurrPath = List.from(currPath);
  newCurrPath.add(start);

  // ending condition for recursion
  if (availableConns.length == 0 || start.name == 'end') {
    return [newCurrPath];
  }

  // get paths
  for (Node adj in availableConns) {
    List<List<Node>> adjPaths = findPaths(adj, newCurrPath, bonusCave);
    for (List<Node> adjPath in adjPaths) {
      paths.add(adjPath);
    }
  }
  return paths;
}

class Node {
  String name;
  Set<Node> connections = Set();
  Node(this.name);

  connect(Node n) {
    this.connections.add(n);
  }

  @override
  String toString() {
    return this.name;
  }
}

int solve(List<String> lines) {
  // parse lines into Nodes
  Map<String, Node> nodesMap = {};
  for (String line in lines) {
    var parts = line.split('-');
    String first = parts[0];
    String second = parts[1];

    Node firstN = nodesMap[first] ?? Node(first);
    Node secondN = nodesMap[second] ?? Node(second);
    firstN.connect(secondN);
    secondN.connect(firstN);
    nodesMap[first] = firstN;
    nodesMap[second] = secondN;
  }
  List<Node> nodes = nodesMap.values.toList();

  List<Node> bonusCaves = nodes
      .where((n) =>
          n.name == n.name.toLowerCase() &&
          n.name != 'end' &&
          n.name != 'start')
      .toList();

  Set<String> paths = Set();
  Node startingNode = nodes.firstWhere((n) => n.name == 'start');

  // consider each small cave as a separate case, gather results in Set to
  // avoid duplicates
  for (Node bonusCave in bonusCaves) {
    paths.addAll(findPaths(startingNode, [], bonusCave)
        .where((p) => p.last.name == 'end')
        .map((p) => p.join(','))
        .toList());
  }
  return paths.length;
}

void main() async {
  List<String> lines = await readlines('day12test.txt');
  int result = solve(lines);
  print(result);
}
