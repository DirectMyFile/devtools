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
  printToolInfo("Dent", "Lints your project's structure");
  return Process.start("dart", [file("bin/dvt.dart", toolDir).path, "dent", "--directory=${directory.path}"]).then((process) {
    inheritIO(process, prefix: createPrefix("Dent"));
    return process.exitCode;
  });
}

void printToolInfo(String name, String description) {
  var out = new StringBuffer();
  out.write("[");
  pen.xterm(3);
  out.write(pen("Executing ${name}"));
  pen.reset();
  out.write(" - ");
  pen.xterm(3);
  out.write(pen(description));
  pen.reset();
  out.write("]");
  print(out);
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
  
  printToolInfo("Analyzer", "Lints your Dart Code");
  
  return Process.start("dartanalyzer", []..addAll(config['analyze']['files'])).then((process) {
    inheritIO(process, prefix: createPrefix("Analyzer"));
    
    return process.exitCode;
  });
}

void handleExitCode(int code) {
  if (code != 0) {
    exit(code);
  }
}