part of devtools.util;

class VersionPart {
  static const int MAJOR = 0;
  static const int MINOR = 1;
  static const int PATCH = 2;
  static const int PRE = 3;
  static const int BUILD = 4;
}

class Version {
  final int major;
  final int minor;
  final int patch;
  final String pre;
  final String build;
  
  const Version(this.major, this.minor, this.patch, this.pre, this.build);
  
  factory Version.fromMap(Map<String, dynamic> tag) {
    return new Version(tag['major'], tag['minor'], tag['patch'], tag['pre'], tag['build']);
  }
  
  factory Version.parse(String tag) {
    _VersionTokenizer t = new _VersionTokenizer(tag);
    return new Version.fromMap(t.tokenize());
  }
  
  Version increment(int part) {
    var map = toMap();
    switch (part) {
      case 0:
        map['major'] = major + 1;
        break;
      case 1:
        map['minor'] = minor + 1;
        break;
      case 2:
        map['patch'] = patch + 1;
        break;
      case 3:
        throw new UnsupportedError("Incrementing the Pre is not yet supported");
        break;
      case 4:
        throw new UnsupportedError("Incrementing the Build is not yet supported");
        break;
      default:
        throw new Exception("Invalid Part");
        break;
    }
    
    return new Version.fromMap(map);
  }
  
  Map<String, dynamic> toMap() {
    return {
      "major": major,
      "minor": minor,
      "patch": patch,
      "pre": pre,
      "build": build
    };
  }
  
  bool operator ==(Object other) {
    return other is Version
        && other.major == major
        && other.minor == minor
        && other.pre == pre
        && other.build == build;
  }
  
  bool operator >(Version other) {
    return !(this == other || this < other);
  }
  
  bool operator >=(Version other) {
    return (this > other || this == other);
  }
  
  bool operator <=(Version other) {
    return (this < other || this == other);
  }
  
  bool operator <(Version other) {
    if (this.major < other.major) {
      return true;
    }

    if (major == other.major) {
      if (minor < other.minor) {
        return true;
      } else if (minor == other.minor) {
        if (patch != other.patch && patch < other.patch) {
          return true;
        } else if (patch != other.patch) {
          return false;
        }
      }
    } 
    
    if (pre == null && other.pre == null) {
      return false;
    } else if (pre == null && other.pre != null) {
      return false;
    } else if (pre != null && other.pre == null) {
      return true;
    }

    if (this.pre == other.pre) {
      return false;
    }

    var isSmaller = _comparePreReleasePart(_splitPreReleaseParts(this.pre),
        _splitPreReleaseParts(other.pre));
    return isSmaller == -1 ? true : false;
  }
  
  @override
  String toString() {
    var version = "${major}.${minor}.${patch}";

    if (this.pre != null) {
      version = "$version-${pre}";
    }

    if (this.build != null) {
      version = "$version+${build}";
    }

    return version;
  }
}

int _comparePreReleasePart(List a, List b) {
  for(var i = 0; i < a.length; i++) {
    if (i >= b.length) {
      return 1;
    }

    var elemA = a[i];
    var elemB = b[i];

    if (elemA is String && elemB is !String) {
      return 1;
    } else if (elemA is !String && elemB is String) {
      return -1;
    } else if (elemA is int && elemB is int) {
      if (elemA < elemB) {
        return -1;
      } else if (elemA > elemB) {
        return 1;
      }
    } else {
      switch (_compareStrings(elemA, elemB)) {
        case -1:
          return -1;
        case 1:
          return 1;
        default:
      }
    }
  }

  if (a.length == b.length) {
    return 0;
  }

  return a.length > b.length ? 1 : -1;
}

class _VersionTokenizer {
  final String _source;
  int _index = -1;
  Map _version = new Map();

  _VersionTokenizer(this._source);

  String get current => this._source[this._index];

  String consume() {
    this._index++;
    if (this._index > (this._source.length - 1)) {
      this._index--;
      throw new Exception('EOF');
    }
    return this.current;
  }

  int tokenizeInt() {
    StringBuffer unparsedInt = new StringBuffer();
    unparsedInt.write(this.current);

    try {
      while ('01234567890'.contains(this.consume())) {
        unparsedInt.write(this.current);
      }
    }
    catch (Exception) {/* ignore */}
    finally { return int.parse(unparsedInt.toString()); }
  }

  void setMandatoryPart(int value) {
    if (this._version.isEmpty) {
      this._version['major'] = value;
    } else if (!this._version.containsKey('minor')) {
      this._version['minor'] = value;
    } else {
      this._version['patch'] = value;
    }
  }

  void tokenizeMandatoryParts() {
    if (!'0123456789'.contains(this.current)) {
      throw new Exception('wrong format: ${this._source}');
    }
    this.setMandatoryPart(this.tokenizeInt());

    if (this.current != '.') {
      throw new Exception('wrong format: ${this._source}');
    }
    this.consume();
    this.setMandatoryPart(this.tokenizeInt());

    if (this.current != '.') {
      throw new Exception('wrong format: ${this._source}');
    }
    this.consume();
    this.setMandatoryPart(this.tokenizeInt());
  }

 void tokenizePreRelease() {
   StringBuffer everything = new StringBuffer();
   everything.write(this._source[this._index]);

   try {
     while (this.consume() != '+') {
       everything.write(this.current);
     }
   }
   catch (Exception) {/* ignore */}
   finally { this._version['pre'] = everything.toString(); }
 }

 void tokenizeBuild() {
   StringBuffer everything = new StringBuffer();
   everything.write(this._source[this._index]);

   try {
     while (this.consume() != '') {
       everything.write(this.current);
     }
   }
   catch (Exception) {/* ignore */}
   finally { this._version['build'] = everything.toString(); }
 }

  Map tokenize() {
    this.consume();
    this.tokenizeMandatoryParts();

    if (this._index < (this._source.length - 1)) {
      switch (this.current) {
        case '-':
          this.consume();
          this.tokenizePreRelease();
          break;
        case '+':
          this.consume();
          this.tokenizeBuild();
          return this._version;
        default:
          throw new Exception('bad tag');
      }
    }

    if (this._index < (this._source.length - 1)) {
      if (this.current == '+') {
          this.consume();
          this.tokenizeBuild();
      } else {
          throw new Exception('bad tag');
      }
    }

    return this._version;
  }
}

List _splitPreReleaseParts(String thing) {
  return thing.split('.').map((element) {
    try {
      return int.parse(element, radix: 10);
    } catch (FormatException) {
      return element;
    }
  }).toList(growable:false);
}

int _compareStrings(String a, String b) {
  if (a == b) {
    return 0;
  }
  var sorted = [a, b]..sort();
  return identical(sorted[0], a) ? -1 : 1;
}