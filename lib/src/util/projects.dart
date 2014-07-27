part of devtools.util;

bool hasPubSpec(Directory directory) {
  return file("pubspec.yaml", directory).existsSync();
}
