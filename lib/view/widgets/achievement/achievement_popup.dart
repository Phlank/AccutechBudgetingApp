import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';

class AchievementPopup {
  final String title;
  final String description;
  final BuildContext context;

  AchievementPopup(this.context, {this.title, this.description});

  void show() {
    AchievementView(
      context,
      title: title,
      subTitle: description,
      isCircle: true,
    ).show();
  }
}
