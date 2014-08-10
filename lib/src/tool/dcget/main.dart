part of devtools.tool.dcget;

GitHub github;

void execute(List<String> args) {
  var argp = new ArgParser();
  argp.addFlag("list", abbr: "l", help: "List Projects", negatable: false);
  argp.addOption("directory", abbr: "d", help: "Directory to Clone To");
  ArgResults opts;
  try {
    opts = argp.parse(args);
  } on FormatException catch (e) {
    printUsage(argp);
    exit(1);
  }

  if (opts['list']) {
    fetchProjects().then((projects) {
      for (var project in projects) {
        Console.setBold(true);
        Console.write("${project.name}");
        Console.setBold(false);
        if (project.description != null && project.description.isNotEmpty) {
          Console.write(" - ");
          Console.setBold(true);
          Console.write(project.description);
          Console.setBold(false);
        }
      }
    });
  } else {
    var rest = opts.rest;
    
    if (rest.length != 1) {
      printUsage(argp);
      exit(1);
    }
    
    var project = rest.first;
    
    var dir = new Directory(opts['directory'] != null ? opts['directory'] : project).absolute;
    getProject(project, dir); 
  }
}

void getProject(String project, Directory dir) {
  if (dir.existsSync()) {
    print("ERROR: Directory '${dir.path}' already exists.");
    exit(1);
  }
  
  fetchProjects().then((repos) {
    var exists = repos.any((repo) => repo.name.toLowerCase() == project.toLowerCase());
    if (!exists) {
      print("ERROR: Unknown Project '${project}'");
      exit(1);
    }
    var repo = repos.firstWhere((repo) => repo.name.toLowerCase() == project.toLowerCase());
    return clone(repo.cloneUrls.ssh, dir.path);
  }).then((_) {
    exit(0);
  });
}

void initializeClient() {
  if (github == null) {
    github = new GitHub(auth: new Authentication.withToken(GITHUB_TOKEN));
  }
}

Future clone(String url, String directory) {
  var bar = new LoadingBar();
  Console.setBold(true);
  Console.write("Fetching Project");
  Console.setBold(false);
  Console.write(" [ ]");
  Console.moveCursorBack(2);
  return Process.start("git", ["clone", url, directory], includeParentEnvironment: true, runInShell: true).then((process) {
    bar.start();
    return process.exitCode;
  }).then((code) {
    if (code != 0) {
      bar.stop(format("{{color:red}}${Icon.BALLOT_X}{{color:normal}}"));
      exit(code);
    }
    bar.stop(format("{{color:green}}${Icon.CHECKMARK}{{color:normal}}"));
    return new Future.value(null);
  });
}

Future<List<Repository>> fetchProjects() {
  initializeClient();
  return github.userRepositories(ORGANIZATION_NAME);
}

void printUsage(ArgParser argp) {
  print("Usage: dcget [options] <project>");
  stdout.write(argp.getUsage());
}