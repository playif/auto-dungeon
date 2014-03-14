library ui;
import 'dart:html';
import 'package:angular/angular.dart';
import '../../lib/game-model.dart';
import 'dart:math';


@NgComponent(selector: 'bar', templateUrl: 'ui/bar.html', cssUrl: 'ui/ui.css',
    publishAs: 'cmp')
class BarComponent {
  @NgOneWay('bar-color')
  num color = 0;
  @NgOneWay('max')
  num max = 0;
  @NgOneWay('min')
  num min = 0;

  static String createBar(max, min, [color = 10]) {
    return
        "<bar max='$max' min='$min' bar-color='$color' style='float: left; height:15px; width: 100%;'></bar>";
  }

  String getRate() {
    //if(min==null || max== null)return "";
    return "${100*min/max}%";
  }

  String getColor() {
    return
        "linear-gradient(hsl(${color}, 100%, 60%)  0%, hsl(${color}, 100%, 30%)  100%)";
  }
}

class Rect {
  CssRect rect;
}

@NgComponent(visibility: NgDirective.CHILDREN_VISIBILITY, selector:
    'monster-profile', templateUrl: 'ui/monster.html', cssUrl: 'ui/ui.css',
    publishAs: 'c')
class MonsterComponent extends Object with Rect, NgShadowRootAware {
  @NgTwoWay('monster')
  Monster monster;
  NgAnimate animation;



  @NgOneWayOneTime('id')
  int id;

  Element element;
  MonsterComponent(this.element, this.animation) {
    element..style.display = "flex";
    element..style.display = "-webkit-flex";


    rect = element.borderEdge;




    //print(animation);
    //print(rect);
  }

  void clickMonster() {
    monster.damage(1);
  }

  String removeCSS() {
    if (monster.HP <= 0) return "remove";
    return "";
  }


  @override
  void onShadowRoot(ShadowRoot shadowRoot) {
    //animation.addClass(element, "demo");
    //element.draggable=true;
    //monster.onHit.

    //var r=element.borderEdge;
    //monster.rect= new Rect(r.left,r.top,r.width,r.height);
    //print(rect);
    //print(element.borderEdge);
  }
}


@NgComponent(selector: 'linger-text', template:
    """
<div style="position:absolute;transition:all 0.1s linear;" 
ng-style="{left:c.fText.left+'px',top:c.fText.top+'px',opacity:c.fText.opacity+''}">
{{c.fText.text}}
</div>

""",
    publishAs: 'c')
class LingerText extends NgAttachAware {
  @NgTwoWay('text')
  FloatText fText;
  Element element;
  MonsterComponent monster;
  static const tt = const Duration(milliseconds: 100);
  static Random rand = new Random();
  Map styleMap = {};


  LingerText(this.element, this.monster) {
    //    num startX, startY;
    //    startX = monster.rect.left + monster.rect.width / 2;
    //    startY = monster.rect.top + monster.rect.height / 2;
    element.style.position = "absolute";

    //    element.style
    //        ..top='${startY}px'
    //        ..left='${startX}px';
  }

  Map style() {
    styleMap['left'] = '${fText.left}px';
    styleMap['top'] = '${fText.top}px';
    styleMap['opacity'] = '${fText.opacity}';

    return styleMap;
  }

  @override
  void attach() {
    //    num startX, startY;
    //    startX = monster.rect.left + monster.rect.width / 2;
    //    startY = monster.rect.top + monster.rect.height / 2;
    //    fText.left=startX;
    //    fText.top=startY;
    //    new Timer(tt, () {
    //      element.style
    //          ..opacity = "1";
    //      new Timer(tt, () {
    //        int x = rand.nextInt(100) - 50;
    //        int y = rand.nextInt(100) - 50;
    //
    //        element.style
    //            ..top = "${startY+y}px"
    //            ..left = "${startX+x}px"
    //            ..opacity = "0"
    //            ..transition = "all 2s";
    //      });
    //    });
  }
}



class BaseClass {
  //  @NgOneWay('min')
  num mins = 1;
}

@NgComponent(visibility: NgDirective.CHILDREN_VISIBILITY, selector: 'btn',
    templateUrl: 'ui/button.html', //    cssUrl: 'bar/bar.css',
publishAs: 'cmp')
class BtnComponent extends BaseClass {

  var sides = new List<ContentComponent>();

  void add(ContentComponent side) {
    sides.add(side);
  }

}


@NgComponent(selector: 'cont', templateUrl: 'ui/content.html',
    //    cssUrl: 'bar/bar.css',
publishAs: 'cmp')
class ContentComponent extends BaseClass {
  @NgOneWay('min')
  num min = 1;

  ContentComponent(BtnComponent t1) {
    t1.add(this);
  }

}


@NgDirective(selector: 'act-border')
class ActBorder extends NgAttachAware {
  @NgOneWayOneTime('act-border')
  num color;
  Element element;

  ActBorder(this.element);

  void _mouseOver() {
    element..style.borderColor = "hsl(${color}, 100%, 70%)";
  }

  void _mouseLeave() {
    element..style.borderColor = "hsl(${color}, 100%, 30%)";
  }

  void _mouseDown() {
    element..style.borderColor = "hsl(${color}, 100%, 40%)";
  }

  @override
  void attach() {
    if (color == null) {
      color = 0;
    }

    element
        //        ..style.transition = "border-color 0.5s"
        ..onMouseOver.listen((_) => _mouseOver())
        ..onMouseLeave.listen((_) => _mouseLeave())
        ..onMouseDown.listen((_) => _mouseDown())
        ..onMouseUp.listen((_) => _mouseOver())
        ..style.borderStyle = "solid"
        ..style.borderWidth = "2px"
        ..style.borderColor = "hsl(${color}, 100%, 30%)";
  }
}


@NgDirective(selector: '[act-background]')
class ActBackground extends NgAttachAware {
  @NgOneWayOneTime('act-background')
  num color;
  Element element;

  ActBackground(this.element);

  void _mouseOver() {
    element..style.backgroundColor = "hsl(${color}, 80%, 60%)";
  }

  void _mouseLeave() {
    element..style.backgroundColor = "hsl(${color}, 100%, 70%)";
  }

  void _mouseDown() {
    element..style.backgroundColor = "hsl(${color}, 30%, 60%)";
  }

  @override
  void attach() {
    if (color == null) {
      color = 0;
    }

    element
        //        ..style.transition = "background-color 0.5s"
        ..onMouseOver.listen((_) => _mouseOver())
        ..onMouseLeave.listen((_) => _mouseLeave())
        ..onMouseDown.listen((_) => _mouseDown())
        ..onMouseUp.listen((_) => _mouseOver())
        ..style.backgroundColor = "hsl(${color}, 100%, 70%)";
  }
}

@NgDirective(selector: '[inline-html]')
class InlineHtml extends NgAttachAware {
  @NgOneWayOneTime('inline-html')
  String html = "";

  @NgOneWay('tokens')
  String tokens = "";

  Element element;
  Scope scope;
  Compiler compiler;
  Injector injector;
  DirectiveMap directives;


  InlineHtml(this.element, this.scope, this.compiler, this.injector, this.directives);

  @override
  void attach() {

    if (html == null) {
      html = element.innerHtml;
    }
    //print(element);
    var ns = tokens.split(",");

    for (int i = 0; i < ns.length; i++) {
      html = html.replaceFirst("{$i}",
          '<span style="color:#2fed2f;">${ns[i]}</span>');
    }
    html = html.replaceAllMapped(new RegExp("{(.+?)}"), (s) =>
        '<span style="color:#cf5daf;">${s.group(1)}</span>');

    //print(element.innerHtml);

    //Scope childScope = scope.$new();
    //Injector childInjector = injector.createChild([new Module()..value(Scope,
    //    childScope)]);
    //BarComponent bar=new BarComponent();

    //var parent =element.parent;
    element.createShadowRoot();
    //element.shadowRoot.appendHtml(BarComponent.bar);

    //element.createShadowRoot();
    element.shadowRoot.innerHtml = html;
    BlockFactory template = compiler(element.shadowRoot.children, directives);
    template(injector, element.shadowRoot.children);

  }
}
