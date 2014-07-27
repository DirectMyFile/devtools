part of devtools.doublecheck;

Directory directory;

void execute(List<String> args) {
  var argp = new ArgParser();
  argp.addOption("directory", abbr: "d", help: "Directory to Check", defaultsTo: ".");
  var opts = argp.parse(args);
  directory = new Directory(opts['directory']);
  check();
}

void check() {
  load_config()
    .then(dent)
    .then(analyze)
    .then(handle_exit);
}

void printUsage(ArgParser argp) {
  print("usage: doublecheck [options]");
  print(argp.getUsage());
}