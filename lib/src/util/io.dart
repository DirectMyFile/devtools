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

Directory get toolDir => new File.fromUri(Platform.script).parent.parent;

bool fileExists(String path) => new File(path).existsSync();
