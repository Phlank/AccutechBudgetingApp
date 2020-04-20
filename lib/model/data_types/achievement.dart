import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Achievement extends Serializable {
  String name, title, description;
  int currentProgress, targetProgress;

  Achievement({
    @required this.name,
    @required this.title,
    @required this.description,
    this.currentProgress = 0,
    this.targetProgress = 1,
  }) : assert(currentProgress <= targetProgress);

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = new Serializer();
    serializer.addPair(nameKey, name);
    serializer.addPair(titleKey, title);
    serializer.addPair(achievementDescriptionKey, description);
    serializer.addPair(currentProgressKey, currentProgress);
    serializer.addPair(targetProgressKey, targetProgress);
    return serializer.serialize;
  }

  /// Returns true if the criteria for the achievement has been met.
  bool get earned => currentProgress == targetProgress;

  /// Sets the achievement to 'earned'.
  void earn() {
    currentProgress = targetProgress;
  }

  /// Returns a double between 0.0 and 1.0 indicating the progress made towards completing this achievement.
  double get progress => currentProgress.toDouble() / targetProgress.toDouble();

  /// Increments currentProgress by 1 and returns true if the achievement is not earned prior to the method call.
  ///
  /// If the achievement was earned prior to calling this method, it will return false. However, if the achievement was not earned prior to calling this method, it will return true.
  bool incrementProgress() {
    if (currentProgress < targetProgress) {
      currentProgress++;
      return earned;
    }
    return false;
  }

  bool operator ==(Object other) => other is Achievement && _equals(other);

  bool _equals(Achievement other) => name == other.name;

  int get hashCode => name.hashCode;
}
