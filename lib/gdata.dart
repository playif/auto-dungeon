library data;

import 'dart:html';
import 'dart:async';

@MirrorsUsed(targets: const ['data','LinkedHashMap'])
import 'dart:mirrors';
import 'dart:convert';
import 'azdg.dart';
//import 'dart:collection';

//LinkedHashMap map;
MirrorSystem mirrors = currentMirrorSystem();
const creator = const Symbol('create');
LibraryMirror Library = mirrors.findLibrary(#game);
bool isBasicType(s) {
  //  if (s is String && (s == 'int' || s == 'num' || s == 'String')){
  //    return true;
  //  }
  //print(s is num || s is String);
  return s is num || s is String;
  //_isBasicType(reflect(s).type.reflectedType.toString());
}


//0Av9TUrdkDYNsdE9FSU55RnQ5ZjVvSWh3V2FUczVud3c
AzDG azdg = new AzDG(cipher: "XDDD");
Storage data = window.localStorage;

class CacheData {
  Map<String, Map<String, Map<String, String>>> DB = new Map<String, Map<String,
      Map<String, String>>>();
}

class GameData {

  //  static CacheData _DB=new CacheData();
  //  static Map<String, Map<String, Map<String, String>>> get DB=>_DB.DB;
  static Map<String, Map<String, Map<String, String>>> DB = new Map<String,
      Map<String, Map<String, String>>>();

  static Future<String> getCSV(String key, int page) {
    return HttpRequest.getString(
        "https://docs.google.com/spreadsheet/pub?key=$key&single=true&gid=$page&output=txt"
        );
  }


  static void loadAllCsv(String key, List<String> pages, fn) {
    int c = 0;
    for (int i = 0; i < pages.length; i++) {
      getCSV(key, i).then((s) {
        DB[pages[i]] = createEntityMap(s);
        c++;
        if (c >= pages.length) {
          fn();
        }
      });
    }
  }


  static Map<String, Map<String, String>> createEntityMap(String data) {
    Map<String, Map<String, String>> m = new Map<String, Map<String, String>>();
    var lines = data.split('\n');
    //print(lines.length);
    var headers = lines[0].split("\t");
    for (int i = 1; i < lines.length; i++) {
      var cells = lines[i].split("\t");
      var row = {};

      for (int j = 0; j < headers.length; j++) {
        row[headers[j]] = cells[j];
      }
      m[cells[0]] = row;
    }

    //print(m);
    return m;
  }

//  static getEntity(type, String Name) {
//
//  }

  static void save(String key, gameModel) {
    data[key] = azdg.Crypt(JSON.encode(toMap(gameModel)));
  }
  
  static void clean() {
    data.clear();
  }

  static bool hasData(String key) {
    return data.containsKey(key);
  }

  static load(String key) {
    //print(data[key]);
    return fromMap(JSON.decode(azdg.Decrypt(data[key])));
  }

  static toMap(val) {

    InstanceMirror im = reflect(val);
    ClassMirror cm = im.type;
    var key = MirrorSystem.getName(cm.simpleName);
    if (val == null) {
      return null;
    }
    if (isBasicType(val)) {
      return val;
    }
    if (val is List) {
      return val.map((s) {
        if (isBasicType(s)) return s;
        return toMap(s);
      }).toList();
    }
    if (val is Map) {
      Map map = new Map();
      val.forEach((k, v) {
        if (isBasicType(v)) {
          map[k] = v;
        } else {
          map[k] = toMap(v);
        }
      });
      return map;
    }
    Map map = new Map();
    map['classType'] = key;
    var decls = cm.declarations.values.where((dm) => dm is VariableMirror);
    decls.forEach((VariableMirror dm) {
      var val = im.getField(dm.simpleName).reflectee;
      map[MirrorSystem.getName(dm.simpleName)] = toMap(val);
    });
    return map;

  }

  static fromMap(m) {
    if (m == null) return null;

    if (isBasicType(m)) return m;
    if (m is List) {
      return m.map((s) => fromMap(s)).toList();
    }

    String type = m['classType'];
    m.remove('classType');


    if (m is Map && type == null) {
      Map map = {};
      m.forEach((k, v) {
        map[k] = fromMap(v);
      });
      return map;
    }


    ClassMirror cm = Library.declarations[new Symbol(type)];
    InstanceMirror im = cm.newInstance(creator, []);

    m.forEach((String key, value) {
      im.setField(new Symbol(key), fromMap(value));
    });
    return im.reflectee;
  }

}
