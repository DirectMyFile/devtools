import "dart:io";

import "package:devtools/console.dart";

void main() {
  var bar = new ProgressBar();
  for (int i = 1; i <= 100; i++) {
    bar.update(i);
    sleep(new Duration(milliseconds: 250));
  }
}