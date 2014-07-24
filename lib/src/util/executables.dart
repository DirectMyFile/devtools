part of devtools.util;

typedef ErrorHandler(Exception err);
typedef NotFoundHandler();

bool fileExists(String path) {
  return new File(path).existsSync();
}

Future<File> findExecutable(String name, {NotFoundHandler notFound: null, ErrorHandler onError: null}) {
  if (onError == null)
    onError = (err) {};
  if (notFound == null)
    notFound = () {};
  return new Future(() {
    String pathVar = Platform.environment["PATH"];
    if (pathVar == null) {
      onError(new Exception("PATH Variable is Empty"));
    }
    String sep = Platform.isWindows ? ";" : ":";
    Set<String> PATH = pathVar.split(sep).toSet();
    for (String path in PATH) {
      var fullPath = path + Platform.pathSeparator + name;
      if (fileExists(fullPath)) {
        return new File(fullPath);
      }
    }
    return null;
  });
}