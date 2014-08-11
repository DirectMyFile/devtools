import "dart:io";

import "package:devtools/dent.dart" as Dent;
import "package:devtools/cli.dart" as CLI;
import "package:devtools/doublecheck.dart" as DoubleCheck;
import "package:devtools/pubgen.dart" as PubGen;
import "package:devtools/screenshot.dart" as Screenshot;
import "package:devtools/dcget.dart" as DCGet;

import "package:devtools/util.dart";

const String DART_CONSTRAINT = ">=1.6.0-dev <1.7.0";

void main(List<String> args) {
  checkEnvironment();
  
  if (args.length == 0) {
    printUsage();
    return;
  }
  
  var command = args[0];
  args = new List.from(args.getRange(1, args.length), growable: false);
  switch (command) {
    case "dent":
      Dent.execute(args);
      break;
    case "devtools":
      CLI.execute(args);
      break;
    case "doublecheck":
      DoubleCheck.execute(args);
      break;
    case "pubgen":
      PubGen.execute(args);
      break;
    case "screenshot":
      Screenshot.execute(args);
      break;
    case "dcget":
      DCGet.execute(args);
      break;
    default:
      print("Unknown tool: $command");
      printUsage();
      break;
  }
}

void checkEnvironment() {
  if (Platform.isWindows) {
    print("Sorry, devtools is not supported on Windows due to platform limitations.");
    exit(1);
  }
  
  if (Platform.isAndroid) {
    print("Sorry, devtools is not yet supported on Android due to platform limitations.");
    exit(1);
  }
  
  var dartVersion = new Version.parse(Platform.version.split("(")[0].trim());
  var constraint = new VersionConstraint.parse(DART_CONSTRAINT);
  
  if (constraint.allows(dartVersion)) {
    print("ERROR: devtools requires Dart '${DART_CONSTRAINT}', but you have ${dartVersion}");
    exit(1);
  }
}

void printUsage() {
  print("dvt <tool> [options]");
  print("Available tools are:");
  print("dent          -- Analyzes the directory for any issues");
  print("devtools      -- Manages dvt");
  print("doublecheck   -- Double checks the directory for any issues");
  print("pubgen        -- Generates a pubspec.yaml");
  print("screenshot    -- Take a Screenshot");
  print("dcget         -- Fetch DirectCode Projects");
}
