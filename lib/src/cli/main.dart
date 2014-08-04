part of devtools.cli;

void execute(List<String> args) {
  var argp = new ArgParser();

  argp.addFlag("update", abbr: "u", help: "Updates devtools", negatable: false);
  argp.addFlag("help", abbr: "h", help: "Prints this Help Message", negatable: false);
  argp.addFlag("version", abbr: "v", help: "Prints the Version", negatable: false);

  var opts = argp.parse(args);

  if (opts['update']) {
    update();
  } else if (opts['version']) {
    version();
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
    var result = Process.runSync(cmd, args, workingDirectory: toolDir.path);
    if (result.exitCode != 0) {
      fail(result);
    }
  }

  execute("git pull origin master", (result) {
    print("Failed to Pull Changes!");
    exit(1);
  });

  execute("pub upgrade", (result) {
    print("Failed to Update Dependencies!");
    exit(1);
  });
}

void version() {
  var version = loadYaml(file("pubspec.yaml", toolDir).readAsStringSync())['version'] as String;
  print("devtools v${version}");
}

void printUsage(ArgParser argp) {
  print("usage: devtools [options]");
  print(argp.getUsage());
}