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

void inheritIO(Process process, {String prefix, bool skipBlank: false}) {
  process.stdout.transform(UTF8.decoder).transform(new LineSplitter()).listen((String data) {
    if (skipBlank && data.isEmpty) return;
    if (prefix != null) {
      stdout.write(prefix);
    }
    stdout.writeln(data);
  });
  
  process.stderr.transform(UTF8.decoder).transform(new LineSplitter()).listen((String data) {
    if (skipBlank && data.isEmpty) return;
    if (prefix != null) {
      stderr.write(prefix);
    }
    stderr.writeln(data);
  });
}