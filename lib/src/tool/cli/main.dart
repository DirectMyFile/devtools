part of devtools.tool.cli;

void execute(List<String> args) {
  var argp = new ArgParser();

  argp.addFlag("update", abbr: "u", help: "Updates devtools", negatable: false);
  argp.addFlag("help", abbr: "h", help: "Prints this Help Message", negatable: false);
  argp.addFlag("version", abbr: "v", help: "Prints the Version", negatable: false);
  argp.addFlag("window", abbr: "w", help: "Display Version in a Window", negatable: false, hide: true);

  var opts = argp.parse(args);

  if (opts['update']) {
    update();
  } else if (opts['version']) {
    version(opts['window']);
  } else if (opts['help']) {
    printUsage(argp);
  } else {
    printUsage(argp);
  }
}

void update() {
  void execute(String command, void fail(ProcessResult result)) {
    var split = command.split(" ");
    var cmd = split[0];
    var args = new List.from(split)..removeAt(0);
    var result = Process.runSync(cmd, args, workingDirectory: findDevToolsHome().path);
    if (result.exitCode != 0) {
      fail(result);
    }
  }

  execute("git pull origin master", (result) {
    Console.setBold(true);
    print("Failed to Pull Changes!");
    Console.setBold(false);
    exit(1);
  });

  execute("pub upgrade", (result) {
    Console.setBold(true);
    print("Failed to Update Dependencies!");
    Console.setBold(false);
    exit(1);
  });
}

void version(bool window) {
  var version = loadYaml(file("pubspec.yaml", findDevToolsHome()).readAsStringSync())['version'] as String;
  if (!window) {
    Console.setBold(true);
    print("devtools v${version}");
    Console.setBold(false);
  } else {
    var it = new VersionWindow();
    it.display();
  }
}

void printUsage(ArgParser argp) {
  print("usage: devtools [options]");
  print(argp.getUsage());
}