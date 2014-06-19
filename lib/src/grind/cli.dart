part of devtools.grind;

class grind {
  static void main(List<String> args) {
    launch(Directory.current, args);
  }

  static void launch(Directory directory, List<String> args) {
    Directory.current = directory;
    var buildScript = new File("${directory.path}${Platform.pathSeparator}build.dart");

    buildScript.exists().then((exists) {
      if (!exists) {
        print("ERROR: build.dart not found!");
        exit(5);
      }
      var procArgs = [buildScript.absolute.path];
      procArgs.addAll(args);
      return Process.start("dart", procArgs);
    }).then((process) {
      stdout.addStream(process.stdout);
      stderr.addStream(process.stderr);
      process.stdin.addStream(stdin);
      return process.exitCode;
    }).then((code) {
      exit(code);
    });
  }
}