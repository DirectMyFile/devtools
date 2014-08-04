part of devtools.dent;

class Context {
  final Configuration config;
  final AnsiPen pen = new AnsiPen();
  
  bool success = true;
  bool warnings = false;
  
  Directory get directory => config.directory;

  Context(this.config) {
    pen.xterm(3);
  }

  void error(String message) {
    pen.xterm(1);
    print(pen("[ERROR] ${message}"));
    success = false;
  }

  void warning(String message) {
    pen.xterm(3);
    print(pen("[WARN] ${message}"));
    success = false;
    warnings = true;
  }

  void fix(String message) {
    pen.xterm(7);
    print(pen("[FIX] ${message}"));
    success = false;
  }

  void info(String message) {
    pen.xterm(15);
    print(pen("[INFO] ${message}"));
  }
}

class CheckType {
  static const CheckType ERROR = const CheckType("ERROR", 1);
  static const CheckType WARN = const CheckType("WARN", 2);
  
  final String name;
  final int id;
  
  const CheckType(this.name, this.id);
}

abstract class Check {
  CheckType get type;
  
  void execute(Context context);
}

class FileExists implements Check {
  @override
  final CheckType type;
  final List<String> filenames;
  
  String error;
  String warn;
  String fix;
  String info;

  FileExists(this.filenames, {this.type: CheckType.WARN, this.error, this.warn, this.fix, this.info});

  @override
  void execute(Context context) {
    bool exists = false;

    for (var filename in filenames) {
      var file = new File("${context.directory.path}/${filename}");

      if (file.existsSync()) {
        exists = true;
        break;
      }
    }

    if (!exists) {
      if (error != null) {
        context.error(error);
      }

      if (warn != null) {
        context.warning(warn);
      }

      if (fix != null) {
        context.fix(fix);
      }
    } else {
      if (info != null) {
        context.info(info);
      }
    }
  }
}

List<Check> checks = [];

void initializeChecks() {
  var readmes = ["README.md", "README", "README.txt"];
  var authors = ["AUTHORS", "AUTHORS.md"];
  var changelogs = ["CHANGELOG", "CHANGELOG.md"];
  var contributings = ["CONTRIBUTING", "CONTRIBUTING.md"];
  var licenses = ["LICENSE", "LICENSE.md"];
  checks.add(new FileExists(readmes, type: CheckType.ERROR, info: "Checking for README", error: "No README Found", fix: "Create a README about your project"));
  checks.add(new FileExists(licenses, type: CheckType.ERROR, info: "Checking for License", error: "No License Found", fix: "Find a license suitable for your project at http://choosealicense.com/"));
  checks.add(new FileExists(authors, info: "Checking for Authors File", warn: "No Authors File Found", fix: "Create an authors file with each author of your project"));
  checks.add(new FileExists(changelogs, info: "Checking for Changelog", warn: "No Changelog Found", fix: "Create a changelog for your project with major changes"));
  checks.add(new FileExists(contributings, info: "Checking for Contributing Guide", warn: "No Contributing Guide Found", fix: "Create a Contributing Guide with information about your development workflow"));
}
