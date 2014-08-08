part of devtools.dent;

void execute(List<String> args) {
  var argp = new ArgParser();
  argp.addFlag("help", abbr: "h", help: "Prints this Help Message", negatable: false);
  argp.addFlag("warn", abbr: "w", help: "Toggles Warnings", defaultsTo: true);
  argp.addFlag("prefix", abbr: "p", help: "Toggles Prefixes for Logging", defaultsTo: true);
  argp.addFlag("explain", abbr: "e", help: "Toggles Explaining what we are checking for", defaultsTo: true);
  argp.addOption("directory", abbr: "d", help: "Directory to Check", defaultsTo: ".");
  ArgResults opts;
  
  try {
    opts = argp.parse(args);
  } on FormatException catch (e) {
    print("error: ${e.message}");
    printUsage(argp);
    exit(1);
  }
  
  
  if (opts['help']) {
    printUsage(argp);
    exit(0);
  }
  
  var config = new Configuration();
  
  config.directory = new Directory(opts['directory']);
  config.warnings = opts['warn'];
  config.explain = opts['explain'];
  config.prefix = opts['prefix'];
  
  check(config);
}

void check(Configuration config) {
  if (!config.directory.existsSync()) {
    print("[ERROR] ${config.directory.path} does not exist.");
    exit(5);
  }
  
  var context = new Context(config);
  
  initializeChecks();
  
  checks.forEach((check) {
    if (!config.warnings && check.type == CheckType.WARN) {
      return;
    }
    
    check.execute(context);
  });
  
  if (context.success) {
    context.info("All checks passed.", global: true);
  } else if (context.warnings) {
    context.info("Some checks failed with warnings.");
  } else {
    context.error("Some checks failed.");
  }
}

void printUsage(ArgParser argp) {
  print("usage: dent [options]");
  print(argp.getUsage());
}