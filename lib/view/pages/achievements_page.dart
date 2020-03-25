import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/widgets/achievement_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AchievementsPage extends StatefulWidget{
  static  const String ROUTE = '/trophyRoom';

  @override
  _AchievementPageState createState() => _AchievementPageState();

}

class _AchievementPageState extends State<AchievementsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: AchievementListCard(earnedAchievements: BudgetingApp.control.earnedAchievements ).getListViewVersion()
    );
  }
}

class Achievement extends Serializable{
  //todo make icons for achievements
  String name;
  Icon icon;
  Function action;
  String description;

  Achievement({
      @required this.name,
      @required this.description,
      @required this.icon,
      this.action}
      );

  @override
  String get serialize {
    Serializer seal = new Serializer();
    seal.addPair(achievementNameKey, name);
    seal.addPair(achievementDescripKey, description);
    return seal.serialize;
  }

}