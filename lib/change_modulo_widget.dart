import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trailer/modulo_pick_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_win/video_player_win_plugin.dart';

class ChangeModuloWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChangeModuloState();
}

class ChangeModuloState extends State<ChangeModuloWidget> {
  String videoPath = 'C:\\Users\\matteoma\\Desktop\\FakeFootball\\Video\\prova.mp4';
  late VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return controller.value.isInitialized
        ? Stack(
            fit: StackFit.expand,
            children: [
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(
                      controller,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: h - (h * 0.97),
                right: 15,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 700),
                      opaque: false,
                      pageBuilder: (_, animation, ___) => ModuloPickWidget(animation),
                    ),
                  ),
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: h / 10,
                      child: Image.asset('assets/images/logo_fakefootball.png'),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  @override
  void initState() {
    super.initState();
    controller =
        VideoPlayerController.file(File(videoPath), videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true));
    print('initState');
    controller.initialize().then((value) {
      print('gesu');
      if (controller.value.isInitialized) {
        controller.setLooping(true);
        controller.play();
        setState(() {});
      } else {}
    }).catchError((e) => print(e));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
