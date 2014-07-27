part of devtools.dent;

void execute(List<String> args) {
  var argp = new ArgParser();
  argp.addFlag("help", abbr: "h", help: "Prints this Help Message", negatable: false);
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
  
  check(config);
}

void check(Configuration config) {
  if (!config.directory.existsSync()) {
    print("[ERROR] ${config.directory.path} does not exist.");
    exit(5);
  }
  
  var context = new Context(config.directory);
  
  init_checks();
  
  checks.forEach((check) {
    check.execute(context);
  });
  
  if (context.success) {
    context.info("All Checks Passed");
  } else {
    context.error("Some Checks Failed");
  }
}

void printUsage(ArgParser argp) {
  print("usage: dent [options]");
  print(argp.getUsage());
}