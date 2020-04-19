import 'package:budgetflow/model/data_types/achievement.dart';
import 'package:budgetflow/model/implementations/services/achievement_service.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/achievements_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AchievementListCard extends StatelessWidget {
  final AchievementService achievementService =
  BudgetingApp.control.dispatcher.getAchievementService();
  final int numAchievements;

  AchievementListCard({this.numAchievements}); // arbitrary large number

  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List();
    List<AchievementListItem> showing = new List();
    if (numAchievements != null) {
      // Either display the number of achievements chosen in the constructor or display all achievements if there are fewer.
      if (numAchievements > achievementService.earned.length) {
        for (Achievement achievement in achievementService.earned) {
          showing.add(new AchievementListItem(
            achievement: achievement,
            styleColor: Colors.black,
          ));
        }
      } else {
        for (int i = 0; i < numAchievements; i++) {
          showing.add(new AchievementListItem(
            achievement: achievementService.earned[i],
            styleColor: Colors.black,
          ));
        }
      }
      children = <Widget>[
        Padding(
          child: Text(
            'Earned Achievements',
            style: TextStyle(fontSize: 20),
          ),
          padding: EdgeInsets.all(8.0),
        ),
        ListView(
          shrinkWrap: true,
          children: showing,
        ),
      ];
    } else {
      Color color = Colors.grey;
      for (Achievement achievement in BudgetingApp.control.dispatcher
          .getAchievementService()
          .earned
          .toList(growable: false)) {
        if (achievement.earned) {
          color = Colors.black;
        }
        showing.add(new AchievementListItem(
            achievement: achievement, styleColor: color));
      }
      children = <Widget>[
        Padding(
          child: Text(
            'Earned Achievements',
            style: TextStyle(fontSize: 20),
          ),
          padding: EdgeInsets.all(8.0),
        ),
        ListView(
          children: showing,
        ),
        ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
          FlatButton(
            child: Text('View more'),
            onPressed: (() {
              Navigator.pushNamed(context, AchievementsPage.ROUTE);
            }),
            materialTapTargetSize: MaterialTapTargetSize.padded,
          )
        ])
      ];
    }

    return Card(
      child: Column(children: children),
    );
  }
}

class AchievementListItem extends StatelessWidget {
  final Achievement achievement;
  final Color styleColor;

  AchievementListItem({@required this.achievement, @required this.styleColor});

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 20, color: this.styleColor);

    return Padding(
      child: Table(
        children: <TableRow>[
          TableRow(children: <TableCell>[
            TableCell(
                child: Text(
                  achievement.name,
                  style: style,
                  textAlign: TextAlign.left,
                )),
            TableCell(child: achievement.icon)
          ]),
          TableRow(children: <TableCell>[
            TableCell(
                child: Text(
                  achievement.description,
                  style: style,
                  textAlign: TextAlign.left,
                )),
            TableCell(child: Text(''))
          ])
        ],
      ),
      padding: EdgeInsets.all(8.0),
    );
  }
}
