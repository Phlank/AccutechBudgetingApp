import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter/cupertino.dart';

class InteractionChecking {
  // interaction, date of most previous interacted day
  List<Interaction> checkDates;

  InteractionChecking() {
    checkDates = [
      new Interaction(name: 'transaction list', date: DateTime.now()),
      new Interaction(name: 'add transaction', date: DateTime.now()),
      new Interaction(name: 'checked catagories', date: DateTime.now())
    ];
  }

  InteractionChecking.fromLoad(List loadedList) {
    checkDates = loadedList;
  }
}

class Interaction extends Serializable {
  String name;
  int count;
  DateTime date;

  Interaction({@required this.name, this.count = 0, @required this.date});

  void addInteraction() {
    DateTime current = DateTime.now();
    if (current.month == date.month && current.day == date.day) {
      count++;
    } else {
      date == current;
      count = 0;
    }
  }

  @override
  String get serialize {
    Serializer seal = new Serializer();
    seal.addPair(interactionNameKey, name);
    seal.addPair(interactionDateKey, date.toString());
    seal.addPair(interactionCountKey, count);
    return seal.serialize;
  }
}
