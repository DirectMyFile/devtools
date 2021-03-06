part of devtools.util;

Directory _DEVTOOLS_HOME;

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
  if (_DEVTOOLS_HOME != null) {
    return _DEVTOOLS_HOME;
  }
  
  var directory = new File.fromUri(Platform.script).parent;
  while (!new File("${directory.path}/pubspec.yaml").existsSync()) {
    if (directory == null) {
      throw new Exception("Unable to find the devtools home");
    }
    directory = directory.parent;
  }
  
  _DEVTOOLS_HOME = directory;
  
  return directory;
}

bool fileExists(String path) => new File(path).existsSync();

File firstExistingFile(List<File> files) {
  for (var file in files) {
    if (file.existsSync()) {
      return file;
    }
  }
  return null;
}