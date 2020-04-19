import 'package:budgetflow/view/widgets/achievement_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AchievementsPage extends StatefulWidget {
  static const String ROUTE = '/trophyRoom';

  @override
  _AchievementPageState createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: AchievementListCard());
  }
}
