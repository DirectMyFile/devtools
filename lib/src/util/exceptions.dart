part of devtools.util;

class Chair {
  final String message;
  
  Chair([this.message = "ROAR"]);
  
  @override
  String toString() => message;
}