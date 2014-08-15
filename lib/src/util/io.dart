part of devtools.util;

File file(String path, [Directory directory]) {
  var it = "";
  if (directory != null) {
    it += directory.path;
  } else {
    it = path;
  }
  return new File(path);
}

Directory findDevToolsHome() {
  var directory = new File.fromUri(Platform.script).parent;
  while (!new File("${directory.path}/pubspec.yaml").existsSync()) {
    if (directory == null) {
      throw new Exception("Unable to find the devtools home");
    }
    directory = directory.parent;
  }
  return directory;
}

bool fileExists(String path) => new File(path).existsSync();
