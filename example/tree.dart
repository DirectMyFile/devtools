import "package:devtools/console.dart";

void main() {
  var input = {
    "label": "devtools",
    "nodes": [
      {
        "label": "authors",
        "nodes": [
          "Kenneth Endfinger",
          "samrg472"
        ]
      },
      {
        "label": "tools",
        "nodes": [
          "devtools",
          "screenshot",
          "dent",
          "pubgen",
          "doublecheck"
        ]
      }
    ]
  };
  printTree(input);
}