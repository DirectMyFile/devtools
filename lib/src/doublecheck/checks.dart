part of devtools.doublecheck;

Map<String, dynamic> config = {};

Future load_config() {
  var cfg_file = file(".doublecheck", directory);
  if (cfg_file.existsSync()) {
    config = loadYaml(cfg_file.readAsStringSync());
  }
  return new Future.value(0);
}

Future<int> dent(int code) {
  handle_exit(code);
  return Process.start("dart", [file("bin/dent.dart", tool_dir).path, "--directory=${directory.path}"]).then((process) {
    inheritIO(process);
    return process.exitCode;
  });
}

Future<int> analyze(int code) {
  if (config['analyze'] == null) {
    return new Future.value(0);
  }
  return Process.start("dartanalyzer", []..addAll(config['analyze']['files'])).then((process) {
    inheritIO(process);
    return process.exitCode;
  });
}

void handle_exit(int code) {
  if (code != 0) {
    exit(code);
  }
}