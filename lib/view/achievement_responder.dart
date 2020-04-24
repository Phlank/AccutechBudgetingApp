import 'package:achievement_view/achievement_view.dart';
import 'package:budgetflow/model/data_types/achievement.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:flutter/material.dart';

class AchievementResponder {
  static respondTo(Achievement achievement, BuildContext context) {
    bool respond = BudgetingApp.control.dispatcher.achievementService
        .incrementProgress(achievement);
    if (respond) {
      AchievementView(
        context,
        title: achievement.title,
        subTitle: achievement.description,
        icon: Icon(Icons.check_box),
      ).show();
    }
  }
}
