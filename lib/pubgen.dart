library devtools.pubgen;

import "dart:io";

import "package:args/args.dart";

import "util.dart";

void execute(List<String> args) {
  var argp = new ArgParser();
  argp.addFlag("help", abbr: "h", help: "Prints this Help Message", negatable: false);
  var opts = argp.parse(args);
  
  if (opts['help']) {
    printUsage(argp);
  } else {
    pubgen();
  }
}

void pubgen() {
  String prompt(String message) {
    stdout.write(message);
    return stdin.readLineSync();
  }
  
  var file = new File("pubspec.yaml");
  
  if (file.existsSync()) {
    print("ERROR: pubspec.yaml already exists.");
    exit(1);
  }
  
  var name = prompt("[Name]: ");
  var version = prompt("[Version]: ");
  var description = prompt("[Description]: ");
  
  var pubspec = {
    "name": name,
    "version": version,
    "description": description
  };
  
  file.writeAsStringSync(dumpYaml(pubspec));
  
  print("Generated pubspec.yaml");
}

void printUsage(ArgParser argp) {
  print("usage: pubgen [options]");
  print(argp.getUsage());
  exit(0);
}