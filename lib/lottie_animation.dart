import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimation extends StatelessWidget {
  final int countRepeats;
  final String pathAnimatiom;
  final bool useAudio;
  final String audioFile;
  final bool useRepeat;
  final AnimationController animationController;
  final bool reverse;
  final double width;
  final double height;
  final BoxFit fit;

  LottieAnimation(
      {Key key,
      this.countRepeats,
      this.pathAnimatiom,
      this.useAudio = false,
      this.audioFile,
      this.useRepeat = false,
      this.animationController,
      this.reverse = false,
      this.fit = BoxFit.fill,
      this.width,
      this.height})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    int repeats = 0;
    AudioCache audioPlayer = AudioCache(prefix: 'assets/audio/');
    return Container(
      height: height,
      width: width,
      child: Lottie.asset(
        pathAnimatiom,
        fit: BoxFit.fitWidth,
        reverse: reverse,
        controller: animationController,
        onLoaded: (composition) async {
          if (useAudio) audioPlayer.play(audioFile);

          animationController
            ..duration = composition.duration
            ..forward();

          //Контроль состояния
          animationController.addStatusListener((status) {
            if (useRepeat == true) {
              if (status == AnimationStatus.completed) {
                animationController.forward(from: 0.0);
                repeats++;
              }
              if (status == AnimationStatus.completed &&
                  repeats == countRepeats) {
                animationController.reset();
              }
            } else {
              if (status == AnimationStatus.completed) {}
            }
          });
        },
      ),
    );
  }
}
