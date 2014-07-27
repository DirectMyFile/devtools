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

void inheritIO(Process process, {bool handleExit: false}) {
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  process.stdin.addStream(stdin);
  
  if (handleExit) {
    process.exitCode.then((code) {
      if (code != 0) {
        exit(code);
      }
    });
  }
}