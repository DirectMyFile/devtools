import "dart:async";

import "package:devtools/util.dart";

void main() {
  var bar = new LoadingBar();
  Console.write("Loading ");
  bar.start();
  new Timer(new Duration(seconds: 5), () {
    bar.stop();
  });
}