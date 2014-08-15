import "package:devtools/console.dart";

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
  Console.setInverted(true);
  print("Inverted");
  Console.setInverted(false);
  Console.resetAll();
  
  Console.setFramed(true);
  print("Framed");
  Console.setFramed(false);
  
  Console.setBlink(true);
  print("Blink");
  Console.setBlink(false);
  
  Console.setEncircled(true);
  print("Encircled");
  Console.setEncircled(false);
  
  Console.setOverlined(true);
  print("Overlined");
  Console.setOverlined(false);
  
  print("Cursor Position: ${Console.getCursorPosition()}");
}