import "package:devtools/util.dart";

void main() {
  var window = new Window("DirectCode Development Tools - Control Center");
  window.display();
  Console.resetBackgroundColor();
  Console.setTextColor(4, bright: true);
  window.writeCentered("Welcome to the DirectCode Development Tools Control Center!");
  Console.moveCursor(row: Console.rows);
}