part of devtools.util;

typedef ErrorHandler(Exception err);
typedef NotFoundHandler();

File findExecutable(String name, {NotFoundHandler notFound: null, ErrorHandler onError: null}) {
  if (onError == null) onError = (err) {};
  if (notFound == null) notFound = () {};
  
  var pathVar = Platform.environment["PATH"];
  if (pathVar == null) onError(new Exception("PATH Variable is Empty"));
  
  var sep = Platform.isWindows ? ";" : ":";
  var PATH = pathVar.split(sep).toSet();
  
  for (String path in PATH) {
    var fullPath = path + Platform.pathSeparator + name;
    var file = new File(fullPath);
    if (file.existsSync()) return file;
  }
  
  return null;
}
