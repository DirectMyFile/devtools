part of devtools.util;

class Node {
  final Node parent;
  final List<Node> children = [];
  
  Node.root() : parent = null;
  
  Node(this.parent);
}
