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
  /// Creates an Achievement.
  ///
  /// Though [name] and [title] can be equal, it isn't necessary. The displayed
  /// parts of the achievement to the user are [title] and [description], while
  /// [name] is used to compare Achievements to determine equality.
  /// [currentProgress] should start at `0` if the Achievement isn't being
  /// created through loading.
  ///
  /// [currentProgress] must be less than or equal to [targetProgress].
  /// [currentProgress] must be greater than or equal to `0`, while
  /// [targetProgress] must be greater than or equal to `1`.
  Achievement({
    @required this.name,
    @required this.title,
    @required this.description,
    this.currentProgress = 0,
    this.targetProgress = 1,
              })
      : assert(currentProgress <= targetProgress),
        assert(targetProgress > 0),
        assert(currentProgress >= 0);

  /// The unique identifier of the achievement.
  String name;

  /// The displayed title of the achievement.
  String title;

  /// The displayed description of the achievement.
  String description;

  /// An `int` of the number of times the achievement has been triggered.
  int currentProgress;

  /// An `int` of the number of triggers required to earn this achievement.
  int targetProgress;


  /// Returns the value side of a key-value pair as a JSON object.
  ///
  /// Serializes the [name], [title], [description], [currentProgress], and
  /// [targetProgress].
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
