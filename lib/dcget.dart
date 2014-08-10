library devtools.tool.dcget;

import "dart:async";
import "dart:io";

import "package:args/args.dart";
import "package:github/client.dart";
import "package:devtools/console.dart";
import "package:devtools/util.dart";

part 'src/tool/dcget/main.dart';

const String GITHUB_TOKEN = "46e1cb141b638b78dcd3315429b294c572a50951";
const String ORGANIZATION_NAME = "DirectMyFile";