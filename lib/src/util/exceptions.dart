part of devtools.util;

class Chair {
  final String message;
  
  Chair([this.message = "ROAR"]);
  
  @override
  String toString() => message;
}

class Grenade {
  final String message;
  
  Grenade([this.message = "BAM"]);
  
  @override
  String toString() => message;
}