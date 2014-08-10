part of devtools.util;

class Window {
  String _title;

  String get title => _title;
  set title(String value) => _title = value;
  
  Window(String title) {
    _title = title;
  }
  
  void display() {
    /* Clear Entire Display */
    Console.eraseDisplay(2);
    var width = stdout.terminalColumns;
    Console.moveCursorUp(stdout.terminalLines);
    Console.setBackgroundColor(7, bright: true);
    repeat((i) => Console.write(" "), width);
    Console.setTextColor(0);
    Console.moveCursor(row: 1, column: (stdout.terminalColumns / 2).round() - (title.length / 2).round());
    Console.write(title);
    repeat((i) => Console.write("\n"), stdout.terminalLines - 1);
    Console.moveCursor(row: 2, column: 1);
    Console.centerCursor(row: true);
  }
  
  void writeCentered(String text) {
    Console.moveCursorBack((text.length / 2).round());
    Console.write(text);
  }
}