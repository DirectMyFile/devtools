part of devtools.util;

ArgParser createArgumentParser() {
  var argp = new ArgParser(allowTrailingOptions: false);
  argp.addFlag("help", abbr: "h", help: "Prints this Help Message", defaultsTo: false, negatable: false);
  return argp;
}
