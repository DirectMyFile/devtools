part of devtools.util;

List<String> splitMultiple(String input, List<String> delimiters) {
  var regex = new RegExp(delimiters.map((it) => escapeRegex(it)).join("|"));
  return input.split(regex);
}