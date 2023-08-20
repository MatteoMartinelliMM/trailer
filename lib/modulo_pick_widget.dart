import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trailer/ext.dart';
import 'package:trailer/player.dart';
import 'package:trailer/team_title.dart';

class ModuloPickWidget extends StatefulWidget {
  static const String route = '/moduloPick/';
  final Animation<double> animation;

  ModuloPickWidget(this.animation, {super.key});

  @override
  State<StatefulWidget> createState() => ModuloPickState();
}

class ModuloPickState extends State<ModuloPickWidget> with SingleTickerProviderStateMixin {
  bool loaded = false;
  List<Player> players = [];
  List<String> moduli = [];

  bool done = false;

  bool completed = false;
  late PageController _controller;

  @override
  Widget build(BuildContext context) {
    print('build');
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    const green = const Color(0xFF238450);
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.75),
      appBar: AppBar(
        toolbarHeight: 72,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 72,
            color: green,
          ),
          onPressed: () {
            loaded = false;
            done = false;
            setState(() {});
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 35,
            top: 10,
            child: Hero(
              tag: 'logo',
              flightShuttleBuilder: (BuildContext flightContext, Animation<double> animation,
                  HeroFlightDirection flightDirection, BuildContext fromHeroContext, BuildContext toHeroContext) {
                final Hero toHero = toHeroContext.widget as Hero;
                return RotationTransition(
                  turns: animation,
                  child: toHero.child,
                );
              },
              child: SizedBox(
                height: h / 6,
                child: Image.asset('assets/images/logo_fakefootball.png'),
              ),
            ),
          ),
          AnimatedPositioned(
            left: 50,
            bottom: !loaded ? -475 : 60,
            curve: Curves.decelerate,
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              width: w / 1.5,
              child: Image.asset('assets/images/modulo.png'),
            ),
          ),
          AnimatedPositioned(
            right: 40,
            bottom: !loaded ? -475 : 110,
            curve: Curves.decelerate,
            duration: const Duration(milliseconds: 300),
            child: Container(
              decoration: BoxDecoration(color: const Color(0xD9232b2b), border: Border.all(color: green, width: 2)),
              height: h * 0.55,
              width: w / 4,
              child: AnimatedOpacity(
                opacity: done ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 10,
                      child: FakeFootballTitle(
                        title: 'VERDI',
                        width: w / 4,
                        color: green,
                      ),
                    ),
                    Positioned(
                      top: 65,
                      child: Text(
                        players.map((e) => e.name.capitalize()).toList().join('\n'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: (w / 4) * 0.85,
                      child: Column(
                        children: [
                          FakeFootballTitle(
                            title: 'MODULO',
                            width: w / 4,
                            color: green,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              width: w * 0.20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                    onPressed: () => _controller.previousPage(
                                        duration: const Duration(milliseconds: 200), curve: Curves.decelerate),
                                  ),
                                  SizedBox(
                                    height: (h * 0.55) * 0.12,
                                    width: (w / 4) * 0.50,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: PageView.builder(
                                        controller: _controller,
                                        itemBuilder: (context, index) => Center(
                                          child: Text(
                                            moduli[index % moduli.length],
                                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chevron_right_outlined,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                    onPressed: () => _controller.nextPage(
                                        duration: const Duration(milliseconds: 200), curve: Curves.decelerate),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    players.add(Player.simple(8, 'teo'));
    players.add(Player.simple(19, 'andre'));
    players.add(Player.simple(5, 'ade'));
    players.add(Player.simple(20, 'luchino'));
    players.add(Player.simple(21, 'carmine'));
    players.add(Player.simple(71, 'albi'));
    players.add(Player.simple(93, 'alecormi'));

    moduli.add('3-2-1');
    moduli.add('1-4-1');
    moduli.add('2-3-1');
    moduli.add(('3-2-1(2)'));
    //_controller = AnimationController(vsync: this);
    //_animation = Tween<Offset>(begin: )
    _controller = PageController();
    widget.animation.addListener(() {
      print(widget.animation.value);
      if (widget.animation.value > 0.1 && !loaded) {
        loaded = true;
        setState(() {});
      }
      if (widget.animation.value > 0.5) {
        done = true;
        setState(() {});
      }
      if (widget.animation.isCompleted) {
        completed = true;
      }
    });
  }
}
