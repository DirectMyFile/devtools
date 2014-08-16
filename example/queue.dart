import "package:devtools/util.dart";

void main() {
  var queue = new TaskQueue();
  queue.add(() {
    print("High Priority");
  }, Priority.HIGH);
  
  queue.add(() {
    print("Low Priority");
  }, Priority.LOW);
  
  queue.add(() {
    print("Urgent Priority");
  }, Priority.URGENT);
  
  queue.run();
  
  print("--------------------------------------");
  
  queue.schedule();
}