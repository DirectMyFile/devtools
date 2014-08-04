part of devtools.pubgen;

void execute(List<String> args) {
  var argp = new ArgParser();
  argp.addFlag("help", abbr: "h", help: "Prints this Help Message", negatable: false);
  var opts = argp.parse(args);
  
  if (opts['help']) {
    printUsage(argp);
  } else {
    pubgen();
  }
}

void pubgen() {
  var file = new File("pubspec.yaml");
  
  if (file.existsSync()) {
    print("ERROR: pubspec.yaml already exists.");
    exit(1);
  }
  
  var pubspec = {
    "name": prompt("[Name]: "),
    "version": prompt("[Version]: "),
    "description": prompt("[Description]: ")
  };
  
  if (yesOrNo("Do you want to add a homepage? ")) {
    var homepage = prompt("[Homepage]: ");
    if (homepage.trim() != "") {
      pubspec["homepage"] = homepage;
    } 
  }
  
  if (yesOrNo("Do you have more than one author? ")) {
    var authors = prompt("[Authors]: ");
    if (authors.trim() != "") {
      pubspec["authors"] = new List.from(authors.split(",").map((it) => it.trim()));
    }
  } else {
    var author = prompt("[Author]: ");
    if (author.trim() != "") {
      pubspec["author"] = author;
    }
  }
  
  if (yesOrNo("Do you want to apply an SDK Constraint? ")) {
    var sdk = prompt("[SDK Constraint]: ");
    if (sdk.trim() != "") {
      var env = pubspec["environment"] = {};
      env['sdk'] = sdk;
    }
  }
  
  if (yesOrNo("Do you want to add a documentation url? ")) {
    var url = prompt("[Documentation URL]: ");
    if (url.trim() != "") {
      pubspec['documentation'] = url;
    }
  }
  
  if (yesOrNo("Do you want to add dependencies? ")) {
    var deps = pubspec["dependencies"] = {};
    var addMore = true;
    while (addMore) {
      var name = prompt("[Dependency Name]: ");
      
      if (name.trim() == "") {
        addMore = false;
        continue;
      }
      
      var version = prompt("[Dependency Version]: ");
      
      if (version.trim() == "") {
        addMore = false;
        continue;
      }
      
      deps[name] = version;
      
      if (!yesOrNo("Do you want to add another dependency? ")) {
        addMore = false;
        continue;
      }
    }
  }
  
  file.writeAsStringSync(dumpYaml(pubspec));
  
  print("Generated pubspec.yaml");
}

void printUsage(ArgParser argp) {
  print("usage: pubgen [options]");
  print(argp.getUsage());
  exit(0);
}