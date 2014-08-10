import "package:devtools/dent.dart" as Dent;
import "package:devtools/cli.dart" as CLI;
import "package:devtools/doublecheck.dart" as DoubleCheck;
import "package:devtools/pubgen.dart" as PubGen;
import "package:devtools/screenshot.dart" as Screenshot;

void main(List<String> args) {
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
    default:
      print("Unknown tool: $command");
      printUsage();
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
}
