import "package:devtools/util.dart";
import "package:yaml/yaml.dart";

void main() {
  var window = new ExampleWindow();
  window.display();
}

class ExampleWindow extends Window {
  String version;
  
  ExampleWindow() : super("DirectCode Development Tools - Control Center");
  
  @override
  void initialize() {
    version = loadYaml(file("pubspec.yaml", toolDir).readAsStringSync())['version'] as String;
  }
  
  @override
  void update() {
    super.update();
    Console.resetBackgroundColor();
    Console.setTextColor(4, bright: true);
    writeCentered("Welcome to the DirectCode Development Tools Control Center!");
    Console.resetAll();
    Console.nextLine(2);
    Console.centerCursor(row: false);
    writeCentered("v${version}");
    Console.moveCursor(row: Console.rows);
    Console.hideCursor();
  }
  
  @override
  void close() {
    super.close();
    Console.showCursor();
  }
}