library game;
import 'dart:math';
import 'dart:async';

import '../lib/gdata.dart';
import 'dart:collection';

Random rand = new Random();
const String ID = 'name';
//abstract class Serializable {
//  Map toJson() {
//    Map map = new Map();
//    InstanceMirror im = reflect(this);
//    ClassMirror cm = im.type;
//    var decls = cm.declarations.values.where((dm) => dm is VariableMirror);
//    decls.forEach((dm) {
//      var key = MirrorSystem.getName(dm.simpleName);
//      var val = im.getField(dm.simpleName).reflectee;
//      map[key] = val;
//    });
//    return map;
//  }
//}

//class test {
//  int a=1;
//
//  List l=[Role.get("worrier")];
//
//  Map<String,int> b= { 'a': Role.get("worrier")};
//
//
//  test();
//
//  test.create();
//
//  Role role=Role.get("worrier");
//}


class Role {
  String name = "";
  String desc = "";
  String descTokens = "";

  num damage = 0;
  //  num AttackRate;

  num level = 1;
  num exp = 0;
  num maxExp = 24;
  Map<String, Action> actions = new Map<String, Action>();
  List<State> States = new List<State>();

  //Role(this.name, this.damage);

  Role.create();


  static Role get(String name) {
    Role role = new Role.create();
    //print(GameData.DB["role"][name]["damage"]);
    var info = GameData.DB["role"][name];
    role.name = info["name"];
    role.damage = num.parse(info["damage"]);
    role.actions[info["@action"]] = Action.get(info["@action"]);
    role.desc = info["desc"];
    role.descTokens = info["descTokens"];

    return role;//new Role("戰士", 1)..addAction("Attack", Action.Attack);
  }

  addAction(String name, Action a) {
    actions[name] = a;
  }

  update(num dt, GameModel game) {
    for (var a in actions.values) {
      a.update(dt, this, game);
    }
  }

  obtainExp(num xp) {
    exp += xp.ceil();
    if (exp >= maxExp) {
      level += 1;
      exp -= maxExp;
      maxExp = (maxExp * 1.05 + level * 2).ceil();
      damage += 1;
      //print("Level up! ${Player.Level} with exp ${Player.MExp}");
    }
  }
}

class Team {
  num money;
  num MAP = 100;
  num AP = 100;
  List<Role> roles;
  List<Item> items = new List<Item>();
  List<Treasure> treasures = new List<Treasure>();
  List<Research> researches = new List<Research>();
  Map<String, int> rooms = new Map<String, int>();
  //List<Room> Rooms=new List<Room>();
  String currentRoom = "私宅";
  int currentLevel;

  Team() {
    money = 0;
    roles = new List<Role>();
    items = new List<Item>();
    treasures = new List<Treasure>();
    researches = new List<Research>();
    rooms["私宅"] = 1;
    //Rooms=new List<Room>();
    //Rooms.add(Room.getRoom("私宅"));
    //CurRoom=Rooms.first;
  }

  get maps => items;

  Team.create();

  update(num dt, GameModel game) {
    for (var r in roles) {
      r.update(dt, game);
    }
  }
}

class State {
  String name;

}

class Action {
  //  final GameModel game;
  //  final Role owner;
  String allowUpdate = "戰鬥";
  num timer = 0;
  num cd = 0;

  num attack = 0;
  num attackRange = 0;
  String name;

  //  Action(this.timer, {this.allowUpdate: "戰鬥", this.attack: 0, this.attackRange:
  //      0});
  Action.create();

  static Action get(String name) {
    var a = new Action.create();
    var info = GameData.DB["action"][name];
    a.name = name;
    a.timer = num.parse(info['timer']);
    a.attack = num.parse(info['attack']);

    return a;
  }

  void update(num dt, Role role, GameModel game) {
    if (game.advState != allowUpdate) return;
    cd += dt;
    if (cd >= timer) {
      cd -= timer;
      DoAction(dt, role, game);
    }
  }

  DoAction(num dt, Role role, GameModel game) {
    if (attack != 0) {
      var mons = game.monsters.where((s) => s.HP > 0);
      if (mons.length == 0) {
        return;
      }
      var mon = mons.first;
      num dmg = role.damage * attack;
      mon.damage(dmg);
      game.addLog("[${role.name}]攻擊!造成(${dmg})點傷害!");
      if (mon.HP < 0) {
        //Attack(Player, Monsters.first);

      }
    }
  }

  //static Action get Attack => new Action(1, attack: 1);
}



class Item {
  String name;

  Item.create();
  Item(this.name);
  static Item get(String name) {
    switch (name) {
      case "":
        return new Item(name);
    }
    return null;
  }

}


class Treasure {
  String name;

  Treasure.create();
}

class Research {
  String name;

  Research.create();
}



//class Zone {
//  int level;
//  String name;
//
//  num bonus;
//
//  List<Room> rooms = new List<Room>();
//
//  //Map<String,int> Monsters={"小老鼠":10,"毛毛蟲":1};
//
//}

class Room {
  RandomList monsters;
  RandomList loots;

  num bonus;

  String name;

  int maxMon = 4;
  int minMon = 1;


  Room.create();
  Room(this.name, Map<String, int> mons, Map<String, int> loot) {
    monsters = new RandomList(mons);
    loots = new RandomList(loot);
  }




  static Room get(String name) {
    switch (name) {
      case "私宅":
        return new Room(name, {
          "小老鼠": 10,
          "毛毛蟲": 1
        }, {
          "倉庫鑰匙": 1,
          "麵包": 50
        });


      case "":

    }
    return null;
  }

  Monster getRandomMonster() {
    return Monster.get(monsters.getRandomName());
  }

}

class RandomList {
  Map<String, int> map;
  int totalExp;
  RandomList(this.map) {
    totalExp = map.values.fold(0, (s, e) => s + e);
  }

  RandomList.create();

  String getRandomName() {
    int r = rand.nextInt(totalExp);
    for (var it in map.keys) {
      if (map[it] <= r) {
        r -= map[it];
        continue;
      }
      return it;
    }
    return null;
  }

}

//class Rect {
//  num width;
//  num height;
//  num left;
//  num top;
//
//  Rect(this.left, this.top, this.width, this.height);
//
//  Rect.create();
//}


class TickerList<T extends Ticker> {
  List<T> list = new List<T>();
  TickerList();
  TickerList.create();

  void update(num dt) {
    list.forEach((t) {
      t.update(dt);
    });
    list.removeWhere((s) => s.dead);
  }

  void add(T t) {
    list.add(t);
  }
}

abstract class Ticker {
  num timer = 0;
  num _count = 0;
  bool reset = false;
  bool dead = false;

  Ticker();

  Ticker.create();

  void update(num dt) {
    _count += dt;
    if (timer < _count) {
      timeup();
      if (reset) {
        _count = 0;
      } else {
        dead = true;
      }
    }
  }

  void timeup();
}

class LogString {
  String msg;

  LogString(this.msg);

  LogString.create();

  num timer = 0;
}

class FloatText extends Ticker {
  String text = "";
  num top=0;
  num left=0;
  num x = rand.nextDouble()*10 - 5;
  num y = rand.nextDouble()*10 - 5;
  num opacity=1;

  FloatText() {
    timer = 1;
  }

  FloatText.create(): this();

  @override
  void timeup() {

  }
  
  @override
  void update(num dt) {
    super.update(dt);
    top+=y;
    left+=x;
    opacity-=dt;
    if(opacity<=0.1){
      opacity=0.1;
    }
    //print(top);
  }
}



class Monster {

  TickerList<FloatText> floatTexts = new TickerList<FloatText>();

  //Rect rect=new Rect.create();
  String name = "";
  String desc = "";
  num HP = 10;
  num MHP = 10;

  num defense = 0;

  num exp = 0;

  RandomList items = new RandomList.create();

  Monster.create();
  Monster(this.name, this.desc, this.MHP, this.exp, {this.defense}) {
    HP = MHP;
  }

  check() {
    if (HP < 0) HP = 0;
  }

  static Monster get(String name) {
    switch (name) {
      case "小老鼠":
        return new Monster(name, "一隻令人感到噁心的老鼠。", 6, 3);
      case "毛毛蟲":
        return new Monster(name, "一隻討厭的毛毛蟲。", 8, 5)
            ..defense = 1
            ..defense = 2;
      case "":
        return new Monster(name, "", 16, 10);

    }
    return new Monster("小老鼠", "一隻令人感到噁心的老鼠。", 6, 3);
  }

  void addFloatText(String text) {
    floatTexts.add(new FloatText()..text = text);
  }

  void update(num dt) {
    floatTexts.update(dt);
  }

  void damage(num dmg) {
    HP -= dmg;
    check();
    addFloatText("$dmg");
  }

  //static const Monster m_小老鼠
}

//class MonsterGroup {
//  final List<Monster> Monsters;
//  num Bonus;
//}

class AdventureState {
  static const String Seeking = "探索";
  static const String Fighting = "戰鬥";
  static const String Prayering = "禱告";
  static const String Resting = "休息";
  static const String Unlocking = "解鎖";

  //  final String text;
  //  const AdventureState._(this.text);
  //  const AdventureState.create();
}




const Duration dt = const Duration(milliseconds: 100);
const Duration logdt = const Duration(seconds: 1);
const num t = 0.1;
class GameModel {
  List<LogString> logs = new List<LogString>();

  Team team;

  GameModel(): this.create();

  GameModel.create() {
    Timer loop = new Timer.periodic(dt, update);
    team = new Team();
    var RoleDB = GameData.DB["role"];
    team.roles.add(Role.get(RoleDB[RoleDB.keys.first][ID]));
  }

  String advState = AdventureState.Seeking;
  String tempState = AdventureState.Seeking;

  int seekCount = 0;


  num get MAP => team.MAP;
  num get AP => team.AP;

  //  Role Player = Role.Cloud;

  List<Monster> monsters = new List<Monster>();
  num bonus;




  void update(Timer timer) {

    team.update(t, this);
    logs.forEach((s) => s.timer += t);
    logs.removeWhere((s) => s.timer > 5);


    monsters.forEach((s) {
      s.update(t);
    });

    //Monsters.removeWhere((s)=>s.HP<=0);

    switch (advState) {
      case AdventureState.Seeking:
        seekCount++;
        if (seekCount >= 10) {
          PrepareFighting();

          addLog("遇到敵人!");

        }
        break;
      case AdventureState.Fighting:
        var mons = monsters.where((s) => s.HP > 0);

        team.AP -= 0.1 * mons.fold(1, (s, e) => s + 1);
        if (team.AP <= 0) {
          team.AP = 0;
          tempState = advState;
          advState = AdventureState.Resting;
        }


        if (mons.length == 0) {
          FinishFighting();
        }
        break;
      case AdventureState.Resting:
        team.AP += 1;
        if (team.AP >= team.MAP) {
          team.AP = team.MAP;
          advState = tempState;
        }
        break;
      default:
        break;
    }
  }

  String getTime() {
    var time = new DateTime.now();
    return "${time.hour}H/${time.minute}M/${time.second}S";
  }

  void addLog(String msg) {
    logs.add(new LogString(msg));


    //    Timer timer = new Timer(logdt, () {
    //      logs.removeAt(0);
    //    });
  }

  //  Attack(Role r, Monster m) {
  //    m.HP -= r.Damage;
  //  }

  num getExp(Role killer, Monster body) {
    return body.exp;
  }

  void PrepareFighting() {
    advState = AdventureState.Fighting;
    //print("Mouse!");
    int n = rand.nextInt(4) + 1;
    for (int i = 0; i < n; i++) {
      String mName = Room.get(team.currentRoom).monsters.getRandomName();
      monsters.add(Monster.get(mName)); //.Mouse);
    }
    //print(Monsters.first);
  }

  int endFightCount = 0;
  void FinishFighting() {
    endFightCount++;
    if (endFightCount > 5) {
      advState = AdventureState.Seeking;
      seekCount = 0;

      endFightCount = 0;


      num exp = getTotalExp();
      num aexp = exp / team.roles.length;
      for (var r in team.roles) {
        r.obtainExp(aexp);
      }
      getRandomItem(monsters.length);

      monsters.clear();
    }
  }

  num getTotalExp() {
    num result = 0;
    for (var m in monsters) {
      result += m.exp;
    }
    return result;
  }

  void getRandomItem(num n) {
    if (rand.nextInt(100) < 30) {
      addLog("你得到錢!");
      //print("got money!");
    }

    if (rand.nextInt(100) < 10) {
      addLog("你得到錢1!");
      //print("got item!");
    }
  }

}
