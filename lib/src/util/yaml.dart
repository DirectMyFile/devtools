part of devtools.util;

String dumpYaml(input) {
  var dumper = new YamlDumper();
  dumper.dump(input);
  return dumper.buffer.toString();
}

class YamlDumper {

  StringBuffer buffer = new StringBuffer();
  
  YamlDumper();

  void dump(Object obj) {
    if (obj is Map) {
      _dumpMap(obj);
    } else if (obj is List) {
      _dumpList(obj);
    }
  }
  
  void _dumpMap(Map mp, [int indent = 0]) {
    var indentStr = _indentionString(indent);
    var indentStrSub = _indentionString(indent + 1);
    mp.forEach((k, v) {
      String val;
      
      if (v is String) {
        val = _string(v);
      } else if (v is Map) {
        buffer.writeln(indentStr + k + ':');
        _dumpMap(v, indent + 1);
        return;
      } else if (v is List) {
        buffer.writeln(indentStr + k + ':');
        _dumpList(v, indent + 1);
        return;
      } else {
        val = _string(v.toString());
      }
      
      if (val.contains('\n')) {
        val = val.replaceAll('\n', '\n' + indentStrSub);
        val = '|\n' + indentStrSub + val;
      }
      
      buffer.writeln(indentStr + k + ': ' + val);
    });
  }
  
  void _dumpList(List list, [int indent = 0]) {
    if (list.length == 0) {
      buffer.write("[]");
      return;
    }
    
    for (var item in list) {
      var val = "";
      buffer.write(_indentionString(indent) + "- ");
      if (item is Map) {
        _dumpMap(item, indent + 1);
        continue;
      } else if (item is String) {
        val = _string(item);
      } else {
        val = _string(item.toString());
      }
      buffer.write(val + "\n");
    }
  }
  
  String _string(String input) {
    if ([ ">", "<", ":" ].any((it) => input.contains(it))) {
      return '"' + input + '"';
    } else {
      return input;
    }
  }
  
  String _indentionString(int indent) {
    var str = "";
    for (int i = 0; i < indent; i++) str += "  ";
    return str;
  }

}
