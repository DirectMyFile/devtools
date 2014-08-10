part of devtools.util;

/* A Mimic of Pub's Timer */
class TimeDisplay {
  Stopwatch _watch;
  bool _isStart = true;
  String _lastMsg;
  Timer _updateTimer;
  
  TimeDisplay();
  
  void start() {
    _watch = new Stopwatch();
    _watch.start();
    _updateTimer = new Timer.periodic(new Duration(milliseconds: 50), (timer) {
      update();
    });
  }
  
  void stop() {
    _watch.stop();
    _updateTimer.cancel();
  }
  
  void update() {
    if (_isStart) {
      var msg = "(${_watch.elapsed.inSeconds}s)";
      _lastMsg = msg;
      Console.write(msg);
      _isStart = false;
    } else {
      Console.moveCursorBack(_lastMsg.length);
      var msg = "(${_watch.elapsed.inMilliseconds / 1000}s)";
      _lastMsg = msg;
      Console.setBold(true);
      Console.write(msg);
      Console.setBold(false);
    }
  }
}