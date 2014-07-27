part of devtools.dent;

void execute(List<String> args) {
  var argp = new ArgParser();
  argp.addOption("directory", abbr: "d", help: "Directory to Check", defaultsTo: ".");
  var opts = argp.parse(args);
  var dir = new Directory(opts['directory']);
  check(dir);
}

void check(Directory directory) {
  if (!directory.existsSync()) {
    print("[ERROR] ${directory.path} does not exist.");
    exit(5);
  }
  
  var context = new Context(directory);
  
  init_checks();
  
  checks.forEach((check) {
    check.execute(context);
  });
  
  if (context.success) {
    print("[INFO] All Checks Passed");
  }
}

void printUsage(ArgParser argp) {
  print("usage: dent [options]");
  print(argp.getUsage());
}