import "package:devtools/util.dart";

void main() {
  Console.setBold(true);
  print("Bold");
  Console.setBold(false);
  Console.setUnderline(true);
  print("Underline");
  Console.setUnderline(false);
  Console.setCrossedOut(true);
  print("Crossed Out");
  Console.setCrossedOut(false);
  Console.setTextColor(1);
  print("Red");
  Console.resetTextColor();
  Console.setTextColor(0, bright: true);
  print("Gray");
  Console.resetTextColor();
  Console.setTextColor(1, bright: true);
  print("Bright Red");
  Console.resetTextColor();
  Console.resetAll();
  Console.cursorPosition();
}