import "package:devtools/console.dart";

void main() {
  var username = prompt("Username: ");
  var password = prompt("Password: ", secret: true);
  print("${username}:${password}");
}