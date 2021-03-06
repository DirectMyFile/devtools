part of devtools.tool.dcget;

bool verbose = false;
gh.GitHub github;

void execute(List<String> args) {
  stdin.echoMode = false;
  var argp = new ArgParser();
  argp.addFlag("list", abbr: "l", help: "List Projects", negatable: false);
  argp.addOption("directory", abbr: "d", help: "Directory to Clone To");
  argp.addFlag("no-hooks", abbr: "n", help: "Disable Project Hooks", defaultsTo: false, negatable: false);
  argp.addFlag("verbose", abbr: "v", help: "Verbose Output", defaultsTo: false, negatable: false);
  argp.addFlag("help", abbr: "h", help: "Prints this Help Message", defaultsTo: false, negatable: false);

  ArgResults opts;

  try {
    opts = argp.parse(args);
  } on FormatException catch (e) {
    printUsage(argp);
    exit(1);
  }

  verbose = opts['verbose'];

  if (opts['help']) {
    printUsage(argp);
    exit(0);
  } else if (opts['list']) {
    fetchProjects().then((projects) {
      projects.sort((a, b) => a.name.compareTo(b.name));
      for (var project in projects) {
        if (project.size == 0) continue;
        Console.setBold(true);
        Console.write("${project.name}");
        Console.setBold(false);
        if (project.description != null && project.description.isNotEmpty) {
          Console.write(" - ");
          Console.write(project.description);
        }
        Console.write(" - ");
        Console.write("${project.stargazersCount} stars");
        Console.write("\n");
      }
      Console.resetAll();
      exit(0);
    });
  } else {
    var rest = opts.rest;

    if (rest.length != 1) {
      printUsage(argp);
      exit(1);
    }

    var project = rest.first;

    var dir = new Directory(opts['directory'] != null ? opts['directory'] : project).absolute;
    getProject(project, dir, !opts['no-hooks']);
  }
}

void getProject(String project, Directory dir, bool shouldRunHooks) {
  if (dir.existsSync()) {
    print("ERROR: Directory '${dir.path}' already exists.");
    Console.resetAll();
    exit(1);
  }

  fetchProjects().then((repos) {
    var exists = repos.any((repo) => repo.name.toLowerCase() == project.toLowerCase());
    if (!exists) {
      print("ERROR: Unknown Project '${project}'");
      Console.resetAll();
      exit(1);
    }
    var repo = repos.firstWhere((repo) => repo.name.toLowerCase() == project.toLowerCase());
    return clone(repo.cloneUrls.ssh, dir.path);
  }).then((_) {
    if (shouldRunHooks) {
      runHooks(dir);
    } else {
      Console.resetAll();
      exit(0); 
    }
  });
}

void runHooks(Directory directory) {
  var bar = new LoadingBar();

  Console.setBold(true);
  Console.write("Running Project Hooks");
  Console.setBold(false);
  
  if (!verbose) {
    Console.write(" [ ]");
    Console.moveCursorBack(2);
    bar.start();
  }

  var hooks = new File("${directory.path}/tool/hooks.dart");
  var pubspec = new File("${directory.path}/pubspec.yaml");

  var future = new Future.value(null);

  var hookConfig = {
    "fetchDependencies": true,
    "script": true
  };
  
  if (pubspec.existsSync()) {
    var info = loadYaml(pubspec.readAsStringSync());

    hookConfig = info['hooks'] != null ? info['hooks'] : hookConfig;

    if (hookConfig['fetchDependencies'] == true) {
      future = Process.start("pub", ["get"], includeParentEnvironment: true, workingDirectory: directory.path).then((process) {
        if (verbose) {
          print("");
          inheritIO(process, lineBased: false);
        }
        return process.exitCode;
      }).then((code) {
        if (code != 0) {
          var out = format("{{color:red}}${Icon.BALLOT_X}{{color:normal}}");
          if (!verbose) {
            bar.stop(out);
          }
          print("ERROR: Failed to fetch dependencies.");
          Console.resetAll();
          exit(1);
        }
      });
    }
  }

  future.then((_) {
    if (hooks.existsSync() && hookConfig['script'] == true) {
      return Process.start("dart", [hooks.path], includeParentEnvironment: true, workingDirectory: directory.path).then((process) {
        if (verbose) {
          print("");
          inheritIO(process, lineBased: false);
        }
        return process.exitCode;
      }).then((code) {
        if (code != 0) {
          var out = format("{{color:red}}${Icon.BALLOT_X}{{color:normal}}");
          if (!verbose) {
            bar.stop(out);
          }
          print("ERROR: Hook Script exited with code: ${code}");
          Console.resetAll();
          exit(1);
        }
      });
    }
  }).then((_) {
    var out = format("{{color:green}}${Icon.CHECKMARK}{{color:normal}}");
    if (!verbose) {
      bar.stop(out);
    }
    Console.resetAll();
    exit(0);
  });
}

void initializeClient() {
  if (github == null) {
    github = new gh.GitHub(auth: new gh.Authentication.withToken(GITHUB_TOKEN));
  }
}

Future clone(String url, String directory) {
  var bar = new LoadingBar();

  Console.setBold(true);
  Console.write("Fetching Project");
  Console.setBold(false);
  
  if (!verbose) {
    Console.write(" [ ]");
    Console.moveCursorBack(2);
  }
  
  return Process.start("git", ["clone", url, directory, "--progress"], includeParentEnvironment: true, runInShell: true).then((process) {
    if (verbose) {
      print("");
      inheritIO(process, lineBased: false);
    } else {
      bar.start();
    }
    return process.exitCode;
  }).then((code) {
    if (code != 0) {
      var out = format("{{color:red}}${Icon.BALLOT_X}{{color:normal}}");
      if (!verbose) {
        bar.stop(out);
      }
      Console.resetAll();
      exit(1);
    }
    if (!verbose) {
      bar.stop(format("{{color:green}}${Icon.CHECKMARK}{{color:normal}}"));
    }
    return new Future.value(null);
  });
}

Future<List<gh.Repository>> fetchProjects() {
  initializeClient();
  return github.userRepositories(ORGANIZATION_NAME);
}

void printUsage(ArgParser argp) {
  print("Usage: dcget [options] <project>");
  print (argp.getUsage());
  stdin.echoMode = true;
  stdin.lineMode = true;
}
