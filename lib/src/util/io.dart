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

void inheritIO(Process process, {String prefix}) {
  process.stdout.transform(UTF8.decoder).transform(new LineSplitter()).listen((data) {
    if (prefix != null) {
      stdout.write(prefix);
    }
    stdout.writeln(data);
  });
  
  process.stderr.transform(new LineSplitter()).listen((data) {
    if (prefix != null) {
      stderr.writeln(prefix);
    }
    stderr.writeln(data);
  });
}