import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Achievement extends Serializable {
  String name, title, description;
  Icon icon;
  Function action;
  bool earned = false;

  Achievement({
    @required this.name,
    @required this.title,
    @required this.description,
    this.icon,
    this.action,
  }) {
    if (this.icon == null) {
      this.icon = Icon(Icons.check);
    }
  }

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = new Serializer();
    serializer.addPair(nameKey, name);
    serializer.addPair(titleKey, title);
    serializer.addPair(achievementDescriptionKey, description);
    return serializer.serialize;
  }

  bool operator ==(Object other) => other is Achievement && _equals(other);

  bool _equals(Achievement other) => name == other.name;

  int get hashCode => name.hashCode;

  void setEarned() {
    earned = true;
  }
}
