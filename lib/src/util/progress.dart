part of devtools.util;

class ProgressBar {
  final int width;
  final int complete;
  
  int current = 0;
    
  ProgressBar({int width, this.complete: 100}) : this.width = width != null ? width : stdout.terminalColumns;
  
  void update(int progress) {
    if (progress == current) {
      return;
    }
    
    current = progress;
    
    if (current == 0) {
      stdout.write("");
    }
    
    var ratio = progress / complete;
    var percent = (ratio * 100).toInt();

    var digits = percent.toString().length;
    
    var w = width - digits - 4;
    
    var count = (ratio * w).toInt();
    var before = "${percent}% [";
    var after = "]";
    
    var out = new StringBuffer(before);
    
    for (int x = 0; x < count -1; x++)
      out.write("=");
    
    out.write(">");
    
    for (int x = count; x < w; x++)
      out.write(" ");
    
    out.write(after);
    
    Console.overwriteLine(out.toString());
  }
}
