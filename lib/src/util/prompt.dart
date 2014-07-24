part of devtools.util;

String prompt(String message) {
  stdout.write(message);
  return stdin.readLineSync();
}

bool yesOrNo(String message) {
  var answer = prompt(message);
  return ["yes", "y", "sure", "ok", "yep", "yeah"].contains(answer.toLowerCase());
}
