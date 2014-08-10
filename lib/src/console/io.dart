part of devtools.console;

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