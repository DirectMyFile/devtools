import "dart:async";

import "dart:io";

import "package:devtools/console.dart";

void main() {
  var bar = new LoadingBar();
  Console.write("Loading ");
  bar.start();
  new Timer(new Duration(seconds: 5), () {
    bar.stop();
    exit(0);
  });
}