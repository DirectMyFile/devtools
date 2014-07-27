part of devtools.dent;

class Context {
  final Directory directory;
  final AnsiPen pen = new AnsiPen();
  bool success = true;

  Context(this.directory) {
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
  }

  void fix(String message) {
    pen.xterm(7);
    print(pen("[FIX] ${message}"));
    success = false;
  }
  
  void info(String message) {
    pen.xterm(1);
    print(pen("[INFO] ${message}"));
  }
}

class Check {
  Function execute;

  Check(void execute(Context ctx)) {
    this.execute = execute;
  }
}

class FileExists extends Check {
  FileExists(List<String> filenames, {String error, String warn, String fix, String info}) : super((Context context) {
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
      });
}

List<Check> checks = [];

void init_checks() {
  var readmes = ["README.md", "README", "README.txt"];
  var authors = ["AUTHORS", "AUTHORS.md"];
  var changelogs = ["CHANGELOG", "CHANGELOG.md"];
  checks.add(new FileExists(readmes, info: "Checking for README", error: "No README Found", fix: "Create a README"));
  checks.add(new FileExists(authors, info: "Checking for Authors File", warn: "No Authors File Found", fix: "Create an Authors file"));
  checks.add(new FileExists(changelogs, info: "Checking for Changelog", warn: "No Changelog Found", fix: "Create a Changelog"));
}
