part of devtools.console;

class ProgressBar {
  final int complete;
  
  int current = 0;
    
  ProgressBar({this.complete: 100});
  
  void update(int progress) {
    if (progress == current) {
      return;
    }
    
    current = progress;
    
    if (current == 0) {
      stdout.write("");
    }
    
    var ratio = progress / complete;
    var percent = (ratio * 100).toInt();

    var digits = percent.toString().length;
    
    var w = stdout.terminalColumns - digits - 4;
    
    var count = (ratio * w).toInt();
    var before = "${percent}% [";
    var after = "]";
    
    var out = new StringBuffer(before);
    
    for (int x = 0; x < count -1; x++)
      out.write("=");
    
    out.write(">");
    
    for (int x = count; x < w; x++)
      out.write(" ");
    
    out.write(after);
    
    Console.overwriteLine(out.toString());
  }
}

class LoadingBar {
  Timer _timer;
  bool started = true;
  String position = "<";
  String lastPosition;
  
  LoadingBar();
  
  void start() {
    Console.hideCursor();
    _timer = new Timer.periodic(new Duration(milliseconds: 75), (timer) {
      nextPosition();
      update();
    });
  }
  
  void stop([String message]) {
    _timer.cancel();
    if (message != null) {
      position = message;
      update();
    }
    Console.showCursor();
    print("");
  }
  
  void update() {
    if (started) {
      Console.write(position);
      started = false;
    } else {
      Console.moveCursorBack(lastPosition.length);
      Console.write(position);
    }
  }
  
  void nextPosition() {
    lastPosition = position;
    switch (position) {
      case "|":
        position = "/";
        break;
      case "/":
        position = "-";
        break;
      case "-":
        position = "\\";
        break;
      case "\\":
        position = "|";
        break;
      default:
        position = "|";
        break;
    }
  }
}

class WideLoadingBar {
  int position = 0;
  
  WideLoadingBar();
  
  Timer loop() {
    var width = Console.columns - 2;
    bool goForward = true;
    
    return new Timer.periodic(new Duration(milliseconds: 50), (timer) {
      for (int i = 1; i <= width; i++) {
        position = i;
        sleep(new Duration(milliseconds: 5));
        if (goForward) {
          forward();
        } else {
          backward();
        }
      }
      goForward = !goForward;
    });
  }
  
  void forward() {
    var out = new StringBuffer("[");
    var width = Console.columns - 2;
    var after = width - position;
    var before = width - after - 1;
    for (int i = 1; i <= before; i++) {
      out.write(" ");
    }
    out.write("=");
    for (int i = 1; i <= after; i++) {
      out.write(" ");
    }
    out.write("]");
    Console.overwriteLine(out.toString());
  }
  
  void backward() {
    var out = new StringBuffer("[");
    var width = Console.columns - 2;
    var before = width - position;
    var after = width - before - 1;
    for (int i = 1; i <= before; i++) {
      out.write(" ");
    }
    out.write("=");
    for (int i = 1; i <= after; i++) {
      out.write(" ");
    }
    out.write("]");
    Console.overwriteLine(out.toString());
  }
}