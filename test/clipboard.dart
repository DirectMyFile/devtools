import "package:devtools/console.dart";

void main() {
  Clipboard.setClipboard("Test");
  print("Clipboard: ${Clipboard.getClipboard()}");
}