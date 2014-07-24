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
      Map mp = obj;
      this._dumpMap(mp);
    }
  }
  
  void _dumpMap(Map mp, [int indent = 0]) {
    String indentStr = this._indentionString(indent);
    String indentStrSub = this._indentionString(indent + 1);
    mp.forEach((k, v) {
      String val;
      
      if (v is String) {
        val = v;
      } else if (v is Map) {
        buffer.writeln(indentStr + k + ':');
        this._dumpMap(v, indent + 1);
        return;
      } else {
        val = v.toString();
      }
      
      if (val.contains('\n')) {
        val = val.replaceAll('\n', '\n' + indentStrSub);
        val = '|\n' + indentStrSub + val;
      }
      
      buffer.writeln(indentStr + k + ': ' + val);
    });
  }
  
  String _indentionString(int indent) {
    var str = "";
    for (int i = 0; i < indent; i++) str += "  ";
    return str;
  }

}
