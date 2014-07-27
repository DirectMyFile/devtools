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

Directory get tool_dir => new File.fromUri(Platform.script).parent.parent;

void inheritIO(Process process) {
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
}