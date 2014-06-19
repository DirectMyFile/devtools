#!/usr/bin/env dart
import "package:grinder/grinder.dart";

main([List<String> args]) {
  defineTask('analyze', taskFunction: analyze);
  startGrinder(args);
}

analyze(GrinderContext ctx) {
  runSdkBinary(ctx, 'dartanalyzer', arguments: ['lib/devtools.dart']);
}
