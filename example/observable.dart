import "package:devtools/util.dart";

void main() {
  var list = new ObservableList<String>();
  
  list.onChange.listen((event) {
    if (event.isAddEvent) {
      print("Added '${event.value}' at ${event.index}");
    }
    
    if (event.isRemoveEvent) {
      print("Removed '${event.value}' at ${event.index}");
    }
    
    if (event.isExpandEvent) {
      print("Expanded length from ${event.lastLength} to ${event.newLength}");
    }
  });
  list.add("Test");
  list.remove("Test");
  list.addAll(["A", "B", "C", "D", "E", "F", "G"]);
  list.removeAt(1);
  list.removeLast();
  list.clear();
}