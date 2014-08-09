part of devtools.util;

bool yesOrNo(String message) {
  var answer = prompt(message);
  return ["yes", "y", "sure", "ok", "yep", "yeah", "true", "yerp"].contains(answer.toLowerCase());
}

List<String> _LEFT_KEYS = [68];
List<String> _RIGHT_KEYS = [67];

String prompt(String prompt, {bool secret: false}) {
  stdout.write(prompt);
  stdin.lineMode = false;
  var data = "";
  loop: while (true) {
    var byte = stdin.readByteSync();
    
    var char = new String.fromCharCode(byte);
    
    if (char == "\n" || char == "\r" || char == "\u0004") {
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
      Console.moveCursorBack();
      Console.write("*");
    }
    data += char;
  }
  stdin.lineMode = true;
  return data;
}

class Color {
  static const int BLACK = 0;
  static const int GRAY = 10;
}

class Console {
  static const String ANSI_ESCAPE = "\x1b[";

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
  
  static void setBackgroundColor(int id) => sgr(40 + id);
  
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
  
  static void nextLine([int times = 1]) => writeANSI("${times}E");
  static void previousLine([int times = 1]) => writeANSI("${times}F");
  static void write(String content) => stdout.write(content);
  static void writeANSI(String after) => stdout.write("${ANSI_ESCAPE}${after}");
}
