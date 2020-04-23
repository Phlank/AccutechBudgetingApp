import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A data type which holds information relevant to earning achievements.
///
/// Used for one-event achievements or achievements that require repeated
/// actions taking place.
class Achievement extends Serializable {
  String name, title, description;
  int currentProgress, targetProgress;

  ///
  Achievement({
    @required this.name,
    @required this.title,
    @required this.description,
    this.currentProgress = 0,
    this.targetProgress = 1,
  }) : assert(currentProgress <= targetProgress);

  /// Returns the value side of a key-value pair as a JSON object.
  ///
  /// Serializes the [name], [title], [description], [currentProgress], and
  /// [targetProgress]. Unserializes with [achievementKey].
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

  /// Sets the achievement to `earned`.
  void earn() {
    currentProgress = targetProgress;
  }

  /// Returns a double between 0.0 and 1.0 indicating the progress made towards completing this achievement.
  double get progress => currentProgress.toDouble() / targetProgress.toDouble();

  /// Returns `true` if this [Achievement] and [other] share the same [name].
  bool operator ==(Object other) => other is Achievement && _equals(other);

  bool _equals(Achievement other) => name == other.name;

  int get hashCode => name.hashCode;
}
