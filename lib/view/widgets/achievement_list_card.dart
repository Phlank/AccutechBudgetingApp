import 'package:budgetflow/global/defined_achievements.dart';
import 'package:budgetflow/model/data_types/achievement.dart';
import 'package:budgetflow/view/pages/achievements_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AchievementListCard extends StatelessWidget {
  final List<Achievement> earnedAchievements;
  final int show;

  AchievementListCard(
      {@required this.earnedAchievements, this.show}); // arbitrary large number

  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List();
    List<AchievementListItem> showing = new List();
    if (show != null) {
      if (show > this.earnedAchievements.length) {
        for (Achievement achievement in this.earnedAchievements) {
          showing.add(new AchievementListItem(
            achievement: achievement,
            styleColor: Colors.black,
          ));
        }
      } else {
        for (int i = 0; i < show; i++) {
          showing.add(new AchievementListItem(
            achievement: this.earnedAchievements[i],
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
      for (Achievement achievement
          in allAchievements.values.toList(growable: false)) {
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
