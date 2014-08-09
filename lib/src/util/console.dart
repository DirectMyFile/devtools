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
  
  static void nextLine([int times = 1]) => writeANSI("${times}E");
  static void previousLine([int times = 1]) => writeANSI("${times}F");
  static void write(String content) => stdout.write(content);
  static void writeANSI(String after) => stdout.write("${ANSI_ESCAPE}${after}");
}