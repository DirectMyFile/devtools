import "dart:async";

typedef void TestArea();

void testZone(TestArea area) {
  var spec = new ZoneSpecification(print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
    if (line.startsWith("unittest-") || line.isEmpty) {
      return;
    } else {
      parent.print(zone, line);
    }
  });
  runZoned(area, zoneSpecification: spec);
}