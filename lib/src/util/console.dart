part of devtools.util;

bool yesOrNo(String message) {
  var answer = prompt(message);
  return ["yes", "y", "sure", "ok", "yep", "yeah", "true", "yerp"].contains(answer.toLowerCase());
}

RegExp _FMT_REGEX = new RegExp(r"\{\{(.+?)\}\}");

Map<String, Color> _COLORS = {
  "black": new Color(0),
  "gray": new Color(0, bright: true),
  "red": new Color(1),
  "dark_red": new Color(1, bright: true),
  "lime": new Color(2, bright: true),
  "green": new Color(2),
  "gold": new Color(3),
  "yellow": new Color(3, bright: true),
  "blue": new Color(4, bright: true),
  "dark_blue": new Color(4),
  "magenta": new Color(5),
  "light_magenta": new Color(5, bright: true),
  "cyan": new Color(6),
  "light_cyan": new Color(6, bright: true),
  "light_gray": new Color(7),
  "white": new Color(7, bright: true)
};

class Color {
  final int id;
  final bool xterm;
  final bool bright;
  
  Color(this.id, {this.xterm: false, this.bright: false});
  
  @override
  String toString() {
    if (xterm) {
      return "${Console.ANSI_ESCAPE}38;5;${id}m";
    }
    
    if (bright) {
      return "${Console.ANSI_ESCAPE}${40 + id}m";
    } else {
      return "${Console.ANSI_ESCAPE}${30 + id}m";
    }
  }
}

String format(String input, {List<String> args, Map<String, String> replace}) {
  var out = input;

  var matches = _FMT_REGEX.allMatches(input);
  
  var allKeys = new Set<String>();
  
  for (var match in matches) {
    if (match.group(0).startsWith("\$")) {
      continue;
    }
    
    var key = match.group(1);
    if (!allKeys.contains(key)) {
      allKeys.add(key);
    }
  }
  
  for (var id in allKeys) {
    if (args != null) {
      try {
        var index = int.parse(id);
        if (index < 0 || index > args.length - 1) {
          throw new RangeError.range(index, 0, input.length - 1);
        }
        out = out.replaceAll("{{${index}}}", args[index]);
        continue;
      } on FormatException catch (e) {}
    }

    if (replace != null && replace.containsKey(id)) {
      out = out.replaceAll("{{${id}}}", replace[id]);
      continue;
    }
    
    if (id.startsWith("color:")) {
      var color = id.substring(6);
      if (color.length == 0) {
        throw new Exception("color directive requires an argument");
      }
      
      if (_COLORS.containsKey(color)) {
        out = out.replaceAll("{{${id}}}", _COLORS[color].toString());
        continue;
      }
      
      if (color == "normal") {
        out = out.replaceAll("{{color:normal}}", "${Console.ANSI_ESCAPE}0m");
        continue;
      }
    }
    
    throw new Exception("Unknown Key: ${id}");
  }

  return out;
}

String prompt(String prompt, {bool secret: false}) {
  stdout.write(prompt);
  stdin.lineMode = false;
  stdin.echoMode = false;
  var data = "";
  loop: while (true) {
    var byte = stdin.readByteSync();

    var char = new String.fromCharCode(byte);

    if (char == "\n" || char == "\r" || char == "\u0004") {
      Console.write("\n");
      break loop;
    }

    if (char == "\u0003") {
      exit(0);
    }

    if (char == '\b' || char == '\x7f' || char == '\x1b\x7f' || char == '\x1b\b') {
      if (data.length == 1) {
        data = "";
      } else if (data.length != 0) {
        data = data.substring(0, data.length - 1);
      }

      var display = "${prompt}";

      if (data.length > 0) {
        if (secret) {
          display += strs.repeat("*", data.length);
        } else {
          display += data;
        }
      }

      Console.overwriteLine(display);
      continue;
    }

    if (secret) {
      Console.write("*");
    } else {
      Console.write(char);
    }
    data += char;
  }
  stdin.lineMode = true;
  stdin.echoMode = true;
  return data;
}

class Console {
  static const String ANSI_ESCAPE = "\x1b[";
  static bool _registeredCTRLC = false;

  static void moveCursorForward([int times = 1]) => writeANSI("${times}C");
  static void moveCursorBack([int times = 1]) => writeANSI("${times}D");
  static void moveCursorUp([int times = 1]) => writeANSI("${times}A");
  static void moveCursorDown([int times = 1]) => writeANSI("${times}B");
  static void eraseDisplay([int type = 0]) => writeANSI("${type}J");
  static void eraseLine([int type = 0]) => writeANSI("${type}K");

  static void moveToColumn(int number) => writeANSI("${number}G");

  static void overwriteLine(String line) {
    moveToColumn(1);
    eraseLine(2);
    write(line);
  }

  static void setTextColor(int id, {bool xterm: false, bool bright: false}) {
    if (xterm) {
      var c = id.clamp(0, 256);
      sgr(38, [5, c]);
    } else {
      if (bright) {
        sgr(30 + id, [1]);
      } else {
        sgr(30 + id);
      }
    }
  }

  static void hideCursor() {
    if (!_registeredCTRLC) {
      ProcessSignal.SIGINT.watch().listen((signal) {
        showCursor();
        exit(0);
      });
    }
    writeANSI("?25l");
  }
  static void showCursor() => writeANSI("?25h");

  static void setBackgroundColor(int id, {bool xterm: false, bool bright: false}) {
    if (xterm) {
      var c = id.clamp(0, 256);
      sgr(48, [5, c]);
    } else {
      if (bright) {
        sgr(40 + id, [1]);
      } else {
        sgr(40 + id);
      }
    }
  }

  static void centerCursor({bool row: true}) {
    if (row) {
      var column = (stdout.terminalColumns / 2).round();
      var row = (stdout.terminalLines / 2).round();
      moveCursor(row: row, column: column);
    } else {
      moveToColumn((stdout.terminalColumns / 2).round());
    }
  }

  static void moveCursor({int row, int column}) {
    var out = "";
    if (row != null) {
      out += row.toString();
    }
    out += ";";
    if (column != null) {
      out += column.toString();
    }
    writeANSI("${out}H");
  }

  static void setBold(bool bold) => sgr(bold ? 1 : 22);
  static void setItalic(bool italic) => sgr(italic ? 3 : 23);
  static void setBlink(bool blink) => sgr(blink ? 5 : 25);
  static void setUnderline(bool underline) => sgr(underline ? 4 : 24);
  static void setCrossedOut(bool crossedOut) => sgr(crossedOut ? 9 : 29);
  static void setFramed(bool framed) => sgr(framed ? 51 : 54);

  static void conceal() => sgr(8);
  static void reveal() => sgr(28);

  static void resetAll() => sgr(0);
  static void resetTextColor() => sgr(39);
  static void resetBackgroundColor() => sgr(49);

  static void sgr(int id, [List<int> params]) {
    String stuff;
    if (params != null) {
      stuff = "${id};${params.join(";")}";
    } else {
      stuff = id.toString();
    }
    writeANSI("${stuff}m");
  }

  static int get rows => stdout.terminalLines;
  static int get columns => stdout.terminalColumns;

  static void nextLine([int times = 1]) => writeANSI("${times}E");
  static void previousLine([int times = 1]) => writeANSI("${times}F");
  static void write(String content) => stdout.write(content);
  static void writeANSI(String after) => stdout.write("${ANSI_ESCAPE}${after}");

  static bool _bytesEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);
}
