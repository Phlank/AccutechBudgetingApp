import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AchievementsPage extends StatefulWidget{
  @override
  _AchievementPageState createState() => _AchievementPageState();

}

class _AchievementPageState extends State<AchievementsPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:ListView.builder(
        itemCount: BudgetingApp.control.earnedAchievements.length,
        itemBuilder:(BuildContext context, int index){
          return achievementCard(BudgetingApp.control.earnedAchievements[index]);
        },

      )
    );
  }

  Card achievementCard(Achievement achievement) {
    TextStyle style = TextStyle(
      fontSize: 20,
      color: Colors.black
    );

    return Card(
      child: Table(
        children: <TableRow>[
          TableRow(
            children: <TableCell>[
              TableCell(child: Text(achievement.name, style: style, textAlign: TextAlign.left,)),
              TableCell(child: achievement.icon)
            ]
          ),
          TableRow(
            children: <TableCell>[
              TableCell(child: Text(achievement.description, style: style, textAlign: TextAlign.left,)),
              TableCell(child: Text(''))
            ]
          )
        ],
      ),
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