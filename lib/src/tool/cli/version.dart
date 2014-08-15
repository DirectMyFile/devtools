part of devtools.tool.cli;

class VersionWindow extends Window {
  String version;
  
  VersionWindow() : super("DirectCode Development Tools - Version");
  
  @override
  void initialize() {
    version = loadYaml(file("pubspec.yaml", findDevToolsHome()).readAsStringSync())['version'] as String;
  }
  
  @override
  void update() {
    super.update();
    Console.resetBackgroundColor();
    Console.setTextColor(7, bright: true);
    writeCentered("v${version}");
    Console.moveCursor(row: Console.rows);
    Console.hideCursor();
    Console.resetAll();
    Console.resetTextColor();
  }
  
  @override
  void close() {
    super.close();
    Console.showCursor();
  }
}