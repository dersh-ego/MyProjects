import 'package:audioplayers/audio_cache.dart';
import 'package:drag_n_drop/lottie_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class DragNDrop extends StatefulWidget {
  @override
  _DragNDropState createState() => _DragNDropState();
}

class _DragNDropState extends State<DragNDrop> with TickerProviderStateMixin {
  AnimationController animationController;
  AnimationController monsterController;
  AnimationController fruitController;
  Map<String, Widget> animations;
  Map<String, Map<String, dynamic>> fruitAnimations;
  int countChoices;
  AudioCache player;

  @override
  void initState() {
    player = AudioCache(prefix: 'assets/audio/');
    animationController = AnimationController(vsync: this);
    monsterController = AnimationController(vsync: this);
    fruitController = AnimationController(vsync: this);
    fruitReset();
    super.initState();
  }

  @override
  void dispose() async {
    animationController.dispose();
    monsterController.dispose();
    fruitController.dispose();
    super.dispose();
  }

  void fruitReset() {
    setState(() {
      countChoices = 0;
      if (fruitAnimations != null) fruitAnimations.clear();
      fruitController.reset();
      fruitAnimations = {
        'apple': {'path': 'assets/animations/apple.json', 'choice': false},
        'cherry': {'path': 'assets/animations/cherry.json', 'choice': false},
        'grapes': {'path': 'assets/animations/grapes.json', 'choice': false},
        'peach': {'path': 'assets/animations/peach.json', 'choice': false},
        'pear': {'path': 'assets/animations/pear.json', 'choice': false},
        'orange': {'path': 'assets/animations/orange.json', 'choice': false},
      };
    });
  }

  _dragFruit({String fruitPath, String fruit}) {
    return Draggable<String>(
      data: fruit,
      child: fruitAnimations[fruit]['choice']
          ? Container()
          : LottieAnimation(
              width: 100,
              height: 100,
              pathAnimatiom: fruitPath,
              animationController: fruitController,
            ),
      feedback: LottieAnimation(
        width: 150,
        height: 150,
        pathAnimatiom: fruitPath,
        animationController: fruitController,
      ),
      childWhenDragging: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    if (countChoices == 6) {
      // setState(() {
      //   countChoices = 0;
      //   fruitAnimations.clear();
      //   fruitController.reset();
      //   fruitAnimations = {
      //     'apple': {'path': 'assets/animations/apple.json', 'choice': false},
      //     'cherry': {'path': 'assets/animations/cherry.json', 'choice': false},
      //     'grapes': {'path': 'assets/animations/grapes.json', 'choice': false},
      //     'peach': {'path': 'assets/animations/peach.json', 'choice': false},
      //     'pear': {'path': 'assets/animations/pear.json', 'choice': false},
      //     'orange': {'path': 'assets/animations/orange.json', 'choice': false},
      //   };
      // });
      fruitReset();
    }
    return Scaffold(
      body: Container(
        child: Center(
          child: Stack(
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: LottieAnimation(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  pathAnimatiom: 'assets/animations/stars_in_space.json',
                  animationController: animationController,
                  useRepeat: true,
                  countRepeats: 5,
                ),
              ),
              Row(children: [
                Expanded(
                    child: Container(
                  child: Center(
                    child: DragTarget<String>(
                      builder: (BuildContext context, List<String> incoming,
                          List rejected) {
                        return LottieAnimation(
                          pathAnimatiom: 'assets/animations/monster.json',
                          animationController: monsterController,
                        );
                      },
                      onAccept: (data) async {
                        monsterController.forward(from: 0.0);
                        player.play('munch.mp3');

                        setState(() {
                          fruitAnimations[data]['choice'] = true;
                          countChoices++;
                        });
                      },
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ...fruitAnimations.keys
                                  .map((fruit) => _dragFruit(
                                      fruitPath: fruitAnimations[fruit]['path'],
                                      fruit: fruit))
                                  .toList()
                                  .getRange(0, 3)
                                  .toList()
                                    ..shuffle()
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ...fruitAnimations.keys
                                  .map((fruit) => _dragFruit(
                                      fruitPath: fruitAnimations[fruit]['path'],
                                      fruit: fruit))
                                  .toList()
                                  .getRange(3, 6)
                                  .toList()
                                    ..shuffle()
                            ],
                          ),
                        ]),
                  ),
                )),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
