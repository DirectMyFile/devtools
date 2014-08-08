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
      data = data.isNotEmpty ? data.substring(0, data.length - 1) : "";
      stdout.write("\n\x1b[F\x1b[J${prompt}${secret ? strs.repeat("*", data.length - 1) : data}");
      continue;
    }
    
    if (byte == 91) {
      var next = stdin.readByteSync();
      continue;
    }
    
    if (secret) {
      stdout.write("\x1b[D");
      stdout.write("*");
    }
    data += char;
  }
  stdin.lineMode = true;
  return data;
}
