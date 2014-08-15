import "dart:io";

import "package:unittest/vm_config.dart";
import "package:unittest/unittest.dart";

import "package:devtools/util.dart";

import "test_helper.dart";

void main() {
  testZone(() {
    useVMConfiguration();
    
    group("IO", () {
      test("findDevToolsHome produces actual devtools home", () {
        var home = findDevToolsHome();
        expect(new File("${home.path}/pubspec.yaml").existsSync(), isTrue);
      });
    });
  });
}