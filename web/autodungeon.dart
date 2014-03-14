import 'package:angular/angular.dart';
import 'package:angular/animate/module.dart';

import '../lib/game-model.dart';
import '../lib/gdata.dart';

import 'ui/ui.dart';
import 'dart:html';





//import '../packages/polymer/polymer.dart';





void main() {
  HttpRequest.getString("data/test").then((s) {
    print(s);
  });

  //GameData.clean();
  Module ui = new Module()
      ..install(new NgAnimateModule())
      ..type(BarComponent)
      ..type(MonsterComponent)
      ..type(BtnComponent)
      ..type(ContentComponent)
      ..type(ActBorder)
      ..type(ActBackground)
      ..type(InlineHtml)
      ..type(LingerText)
      ..type(Rect)
      ..type(AutoController);

  if (!GameData.hasData("data")) {
    String key = "0Av9TUrdkDYNsdHVtbU8xR1pkcm1WRU1POGUyT1FGQ0E";
    GameData.loadAllCsv(key, ["game", "role", "item", "monster", "action"], () {
      //print(GameData.DB);
      ngBootstrap(module: ui);
    });
  } else {
    GameData.DB = GameData.load("data");
    ngBootstrap(module: ui);
  }

}



@NgController(selector: '[auto-dungeon]', publishAs: 'c')
class AutoController {
  //Stopwatch sw=new Stopwatch();
  var data = GameData.DB;

  //Role tr=new Role(77);
  String inner = "{WTF} is {1} and {2}.";
  //Team team;
  String cTab = "冒險";
  List<String> tabs = <String>["冒險", "地圖", "道具", "收藏", "研究", "合成", "日誌"];
  //List<Role> roles;
  //Storage data = window.localStorage;
  //List<Monster> Monsters;
  //List<int> Rooms;
  //String inf = "";

  GameModel game;
  
  void clickRemove(LogString ls){
    game.logs.remove(ls);
  }

  AutoController() {
    //sw.start();

    //data.clear();

    String file = "team";

    //Team team;

    if (GameData.hasData(file)) {
      game = GameData.load(file);
    } else {
      game = new GameModel();
      //team.roles.add(Role.get("worrier"));
    }



    


    //roles = team.Roles;
    //Monsters = game.Monsters;

    //Rooms=[1,2,3];
  }


  String tabStyle(String tab) {
    if (tab == cTab) {
      return "White";
    }
    return "";
  }

  void clickTab(String tab) {
    cTab = tab;
  }

  void clickSave() {
    GameData.save("team", game);
    GameData.save("data", GameData.DB);
    //print(data["team"]);
  }

  void clickClean() {
    GameData.clean();
  }
}
