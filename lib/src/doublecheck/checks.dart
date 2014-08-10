part of devtools.doublecheck;

AnsiPen pen = new AnsiPen();

Map<String, dynamic> config = {};

Future loadConfiguration() {
  var cfg_file = file(".doublecheck", directory);
  if (cfg_file.existsSync()) {
    config = loadYaml(cfg_file.readAsStringSync());
  }
  return new Future.value(0);
}

Future<int> dent(int code) {
  handleExitCode(code);
  
  bool explain = false;
  bool prefix = false;
  
  if (!getBoolOption("dent", "enabled", defaultValue: true)) {
    return new Future.value(0);
  }
  
  explain = getBoolOption("dent", "explain", defaultValue: false);
  prefix = getBoolOption("dent", "prefix", defaultValue: false);
  
  printToolInfo("Dent", "Lints your project's structure");
  var args = [file("bin/dvt.dart", toolDir).path, "dent", "--directory=${directory.path}"];
  
  if (!explain) {
    args.add("--no-explain");
  }
  
  if (!prefix) {
    args.add("--no-prefix");
  }
  
  return Process.start("dart", args).then((process) {
    inheritIO(process, prefix: createPrefix("Dent"));
    return process.exitCode;
  });
}

void printToolInfo(String name, String description) {
  Console.write("[");
  Console.setTextColor(3, xterm: true);
  Console.write("Executing ${name}");
  Console.resetAll();
  Console.write(" - ");
  Console.setTextColor(3, xterm: true);
  Console.write(description);
  Console.resetAll();
  Console.write("]");
  Console.write("\n");
}


String createPrefix(String name) {
  var out = "[";
  pen.magenta();
  out += pen(name);
  out += "] ";
  pen.reset();
  return out;
}

Future<int> analyze(int code) {
  if (config['analyze'] == null) {
    return new Future.value(0);
  }
  
  if (!getBoolOption("analyze", "enabled", defaultValue: true)) {
    return new Future.value(0);
  }
  
  printToolInfo("Analyzer", "Lints your Dart Code");
  
  return Process.start("dartanalyzer", []..addAll(config['analyze']['files'])).then((process) {
    inheritIO(process, prefix: createPrefix("Analyzer"));
    
    return process.exitCode;
  });
}

bool getBoolOption(String tool, String key, {bool defaultValue: false}) {
  if (config[tool] == null) return defaultValue;
  if (config[tool][key] == null) return defaultValue;
  if (config[tool][key] is! bool) throw new FormatException("${tool}.${key} should be a boolean");
  return config[tool][key] == true ? true : false;
}

void handleExitCode(int code) {
  if (code != 0) {
    exit(code);
  }
}