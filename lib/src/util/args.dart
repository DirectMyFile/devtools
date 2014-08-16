part of devtools.util;

ArgParser createArgumentParser({bool version: false}) {
  var argp = new ArgParser(allowTrailingOptions: false);
  argp.addFlag("help", abbr: "h", help: "Prints this Help Message", defaultsTo: false, negatable: false);
  
  if (version) {
    argp.addFlag("version", abbr: "v", help: "Prints the Version", defaultsTo: false, negatable: false);
  }
  
  return argp;
}