// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trailer/ext.dart';
import 'package:trailer/player.dart';

class ChangePlayerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChangePlayerState();
}

class ChangePlayerState extends State<ChangePlayerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  Offset startOffset = const Offset(0, 0);
  Offset endOffset = const Offset(0, 0);
  List<Player> players = [];
  Map<Player, AnimationController> controllers = {};
  Map<Player, Animation<Offset>> offsetsByPlayer = {};
  Map<Player, List<Offset>> prova = {};

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xff232b2b),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/pitch.png'),
          ),
          Positioned(bottom: h - (h * 0.90), child: diocane([players.first])),
          Positioned(bottom: h - (h * 0.72), child: diocane(players.sublist(1, 3))),
          Positioned(bottom: h - (h * 0.52), child: diocane(players.sublist(3, 6))),
          Positioned(bottom: h - (h * 0.30), child: diocane([players.last])),
          Positioned(
              bottom: h - (h * 0.98),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                    size: 48,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '3-2-1',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                  Transform.rotate(
                    angle: pi,
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget diocane(List<Player> pl) {
    int howManyPlayers = pl.length;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: pl.map(
        (currPlayer) {
          int i = pl.indexOf(currPlayer);
          return Padding(
            padding: EdgeInsets.only(
                left: howManyPlayers != 3 ? 16 : 4,
                right: howManyPlayers != 3 ? 16 : 4,
                bottom: howManyPlayers > 2 && (i == 0 || i == howManyPlayers - 1) ? 25 : 0,
                top: howManyPlayers > 2 && (i == 1 || i == 2) ? 25 : 0),
            child: DragTarget<Player>(
              onWillAccept: (p) {
                print('${currPlayer.playerId} onWillAccept() ${p?.playerId ?? 'void'}');
                return p != currPlayer;
              },
              onAccept: (p) {
                players.swap(players.indexOf(p), players.indexOf(currPlayer));
                setState(() {});
              },
              builder: (context, accepted, rejected) {
                return Draggable<Player>(
                  data: currPlayer,
                  feedback: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3,
                    child: Image.asset(currPlayer.cardSocialAssets),
                  ),
                  childWhenDragging: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3,
                    child: Image.asset('assets/images/prova.png'),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3,
                    child: Image.asset(currPlayer.cardSocialAssets),
                  ),
                );
              },
            ),
          );
        },
      ).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    players.add(Player.simple(7, 'feb'));
    players.add(Player.simple(23, 'frenk'));
    players.add(Player.simple(9, 'mik'));
    players.add(Player.simple(5, 'ade'));
    players.add(Player.simple(21, 'carmine'));
    players.add(Player.simple(27, 'mauri'));
    players.add(Player.simple(30, 'magna'));
  }
}
