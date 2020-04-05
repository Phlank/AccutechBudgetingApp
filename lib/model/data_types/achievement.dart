import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Achievement extends Serializable {
  String name, title, description;
  Icon icon;
  Function action;

  Achievement({
    @required this.name,
    @required this.title,
    @required this.description,
    this.icon,
    this.action,
  });

  @override
  String get serialize {
    Serializer serializer = new Serializer();
    serializer.addPair(nameKey, name);
    serializer.addPair(achievementDescripKey, description);
    return serializer.serialize;
  }

  bool operator ==(Object other) => other is Achievement && _equals(other);

  bool _equals(Achievement other) => name == other.name;

  int get hashCode => name.hashCode;
}
