part of devtools.util;

abstract class Window {
  String _title;
  Stream<List<int>> get onKeyPress => _keyPresscontroller.stream.asBroadcastStream();
  final StreamController<List<int>> _keyPresscontroller = new StreamController();
  Timer _updateTimer;
  
  String get title => _title;
  set title(String value) => _title = value;
  
  Window(String title) {
    _title = title;
    _init();
    initialize();
  }
  
  void initialize();
  
  void _init() {
    stdin.echoMode = false;
    stdin.listen((data) {
      _keyPresscontroller.add(data);
//      Console.moveCursor(row: Console.rows);
//      update();
    });
  }
  
  void update() {
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
  
  void display() {
    update();
  }
  
  Timer startUpdateLoop([Duration wait]) {
    if (wait == null) wait = new Duration(seconds: 2);
    _updateTimer = new Timer.periodic(wait, (timer) {
      update();
    });
    return _updateTimer;
  }
  
  void close() {
    if (_updateTimer != null) {
      _updateTimer.cancel();
    }
    Console.eraseDisplay(2);
    stdin.echoMode = true;
  }
  
  void writeCentered(String text) {
    Console.moveCursorBack((text.length / 2).round());
    Console.write(text);
  }
}