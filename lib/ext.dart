import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trailer/constants.dart';
import 'package:trailer/player.dart';

extension ListUtils<T> on List<T> {

  void swap(int first, int second) {
    final temp = this[first];
    this[first] = this[second];
    this[second] = temp;
  }

  T? firstOrNullWhere(Function(T) f) {
    var list = where((t) => f.call(t)).toList();
    return list.isNotEmpty ? list.first : null;
  }

  void addOrRemove(T t) => contains(t) ? remove(t) : add(t);

  int countWhere(Function(T) f) => where((t) => f.call(t)).toList().length;

  void forEachIndexed(Function(T, int) f) {
    int i = 0;
    forEach((e) {
      f.call(e, i);
      i++;
    });
  }
}

extension NullableListUtils<T> on List<T>? {
  bool isNullOrEmpty() => this != null ? this!.isEmpty : true;

  T? firstOrNull() => this != null && this!.isNotEmpty ? this!.first : null;
}

extension MapUtils<K, V> on Map<K, V> {
  String printMap() {
    String print = '';
    keys.forEach((k) => print += '$k - ${this[k]}\n');
    return print.trimRight();
  }

  Map<K, V> fromIterableWhere(Iterable<K> iterable,
      {required K Function(K) key, required V Function(K) value, required bool Function(K) where}) {
    iterable.forEach((e) {
      if (where(e)) this[key.call(e)] = value.call(e);
    });
    return this;
  }

  K? firstKeyWhere(bool Function(K, V?) where) {
    K? ret;
    for (K k in keys)
      if (where(k, this[k])) {
        ret = k;
      }
    return ret;
  }
}

extension NullableMapUtils<K, V> on Map<K, V>? {
  bool isNullOrEmpty() => this != null ? this!.isEmpty : true;
}

extension PlayerFinder on Player {
  String getPath(String file) {
    switch (file) {
      case CARD_FORMAZIONE:
        return '$BASE_PATH$dirName$cardFormazione$PNG';
      case CARD_PORTIERE:
        return '$BASE_PATH$dirName$cardPortiere$PNG';
      case CARD_SOCIAL:
        return '$BASE_PATH$dirName$cardSocial$PNG';
      case PLAYER_INTERO:
        return '$BASE_PATH$dirName$playerIntero$PNG';
      case PLAYER_MEZZO_BUSTO:
        return '$BASE_PATH$dirName$playerMezzoBusto$PNG';
      case PLAYER_TAGLIATO:
        return '$BASE_PATH$dirName$playerTagliato$PNG';
      case TESTA:
      default:
        return '$BASE_PATH$dirName$testa$PNG';
    }
  }

  String getRoasterDir() =>
      [ROASTER_DIR, (!this.isRookie ? SQUAD_DIR : ROOKIES_DIR)].buildFilePath();

  String getTeam() => isYellow ? 'GIALLI' : 'VERDI';

  bool isRookie() => isYellow
      ? YELLOW_ROOKIES.contains(number) || YELLOW_KEEPER == number
      : GREEN_ROOKIES.contains(number) || GREEN_KEEPER == number;

  List<Shadow> textStrokeTeam() {
    Color color = isYellow ? Colors.black87 : Colors.white;
    return [
      Shadow(
        offset: const Offset(-1.5, -1.5),
        color: color,
      ),
      Shadow(
        offset: const Offset(1.5, -1.5),
        color: color,
      ),
      Shadow(
        offset: const Offset(1.5, 1.5),
        color: color,
      ),
      Shadow(
        offset: const Offset(-1.5, 1.5),
        color: color,
      ),
    ];
  }
}

extension PlayerCollectionUtils on List<Player> {
  List<Player> getRookies() {
    if (isNotEmpty) {
      List<int> rookiesNumbers = first.isYellow ? YELLOW_ROOKIES : GREEN_ROOKIES;
      return where((p) => rookiesNumbers.contains(p.number)).toList();
    }
    return [];
  }

  Player? getKeeper() {
    if (isNotEmpty) {
      int keeperNumber = first.isYellow ? YELLOW_KEEPER : GREEN_KEEPER;
      var list = where((element) => element.number == keeperNumber).toList();
      return list.isNotEmpty ? list.first : null;
    }
    return null;
  }

  bool haveRookies() {
    if (isNotEmpty) {
      return where((p) =>
      YELLOW_ROOKIES.contains(p.number) ||
          GREEN_ROOKIES.contains(p.number) ||
          YELLOW_KEEPER == p.number ||
          GREEN_KEEPER == p.number).toList().isNotEmpty;
    }
    return false;
  }

  Map<String, dynamic> toJsonConvocati() {
    Map<String, dynamic> map = {};
    forEach((p) => map.addAll(p.toJsonConvocati()));
    return map;
  }

  void sortByNumber() => sort((p1, p2) => p1.number.compareTo(p2.number));

  void marskAsGreenTeam() => forEach((p) => p.isYellow = false);

  void marskAsYellowTeam() => forEach((p) => p.isYellow = true);

  void sortByRole(String role) {
    sort((a, b) {
      var compareTo = a.roles.indexOf(role).compareTo(b.roles.indexOf(role));
      if (compareTo == 0) return a.roles.length.compareTo(b.roles.length);
      return compareTo;
    });
  }

  Map<String, List<Player>> sortPlayersByLineUp(String modulo, [bool? needKeeper]) {
    List<String> howManyPlayersPerRoleString = modulo.split(SECOND_VERSION).first.split('-');
    int i = 0;
    needKeeper = needKeeper ?? true;
    Map<String, int> howManyPlayersPerRole = Map.fromIterable(howManyPlayersPerRoleString,
        key: (k) {
          String role = i.toFieldZone();
          i++;
          return role;
        },
        value: (v) => int.parse(v));

    Map<String, List<Player>> playersPerRole = {};
    List<Player> temp = [...this];
    if (needKeeper) {
      Player? keeper = temp.firstOrNullWhere((p) => p.roles.contains(POR));
      keeper = keeper ?? temp.firstOrNullWhere((p) => p.isRookie);
      keeper ?? temp.shuffle(Random(7));
      keeper = keeper ?? temp.first;
      playersPerRole[POR] = [keeper];
      temp.remove(keeper);
    }

    howManyPlayersPerRole.keys.forEach(
          (role) {
        int playersAmount = howManyPlayersPerRole[role]!;
        List<Player> inRole = [];
        List<Player> canDoRole = temp.where((p) => p.roles.contains(role)).toList()
          ..sortByRole(role);
        int playersToTake = playersAmount != 3 && playersAmount != 4
            ? playersAmount
            : playersAmount - 2; //(fausto) le ali vengono gestite a parte
        if (canDoRole.isNotEmpty) {
          while (inRole.length != playersToTake) {
            if (canDoRole.isEmpty) break;
            Player p = canDoRole.first;
            canDoRole.remove(canDoRole.first);
            inRole.add(p);
            temp.remove(p);
          }
        }
        if (playersToTake != playersAmount) {
          List<Player> ali = temp.where((p) => p.roles.contains(ALA)).toList()..sortByRole(ALA);
          if (ali.length > 2) {
            temp.remove(ali.first);
            temp.remove(ali[1]);
            inRole.insert(0, ali.first);
            inRole.add(ali[1]);
          }
          if (ali.length == 2) {
            inRole.insert(0, ali.first);
            inRole.add(ali.last);
          }
        }
        playersPerRole[role] = inRole;
      },
    );
    if (temp.isNotEmpty) {
      howManyPlayersPerRole.keys.forEach((role) {
        int howManyPlayers = howManyPlayersPerRole[role]!;
        if (playersPerRole[role]!.length != howManyPlayers) {
          while (playersPerRole[role]!.length != howManyPlayers) {
            Player p = temp.first;
            playersPerRole[role]!.add(p);
            temp.remove(p);
          }
        }
      });
    }
    return playersPerRole;
  }
}

extension TaglieNrBinding on int {
  String getTaglia() {
    switch (this) {
      case 20:
      case 33:
      case 69:
      case 74:
        return "M";
      case 44:
      case 90:
        return "L";
      default:
        return "S";
    }
  }

  String toFieldZone() {
    switch (this) {
      case 0:
        return DC;
      case 1:
        return CC;
      case 2:
        return ATT;
    }
    return '';
  }

  bool isYellow() => YELLOW_ROOKIES.contains(this);
}

extension StringListUtils on List<String> {
  String buildFilePath() => join(Platform.isWindows ? r'\' : '/');

}

extension StringUtils on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String? getFileExt() {
    if (RegExp(IS_FILE).hasMatch(this)) return '.${split('.').last}';
    return null;
  }

  double fieldPositionKByRole() {
    switch (this) {
      case POR:
        return 0.99;
      case DC:
        return 0.75;
      case CC:
        return 0.50;
      case ATT:
        return 0.25;
      default:
        return 0;
    }
  }

  void printOut() => print(this);

  void printOutMsg(String ms) => print(ms + this);

  Icon getIconBySettings() {
    switch (this) {
      case ROOT_PATH:
        return const Icon(
          Icons.folder,
          color: Colors.yellow,
          size: 48,
        );
      case VIDEO_READER_PATH:
        return const Icon(
          Icons.ondemand_video,
          color: Colors.white,
          size: 48,
        );
      case PS_PATH:
        return const Icon(
          Icons.adobe,
          color: Colors.white,
          size: 48,
        );
      case PLACEHOLDER_PRIMO_TEMPO:
      case PLACEHOLDER_SECONDO_TEMPO:
      case PLACEHOLDER_FFMOMENTS:
        return const Icon(
          Icons.video_file_outlined,
          color: Colors.white,
          size: 48,
        );
      default:
        return const Icon(
          Icons.file_open_outlined,
          color: Colors.white,
          size: 48,
        );
    }
  }
}