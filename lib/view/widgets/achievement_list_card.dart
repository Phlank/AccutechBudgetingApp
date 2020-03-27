import 'package:budgetflow/view/pages/achievements_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AchievementListCard extends StatelessWidget {
  final List<Achievement> earnedAchievements;
  final int show;

  AchievementListCard({@required this.earnedAchievements,
    this.show = 1000}); // arbitrary large number

  getListViewVersion() {}

  @override
  Widget build(BuildContext context) {
    List<AchievementListItem> showing;
    int count = 0;
    showing = [];
    for (Achievement a in earnedAchievements.reversed) {
      showing.add(new AchievementListItem(a));
      count++;
      if (count >= show) break;
    }
    return Card(
        child: Column(children: <Widget>[
          Padding(
            child: Text(
              'Earned Achievements',
              style: TextStyle(fontSize: 20),
            ),
            padding: EdgeInsets.all(8.0),
          ),
          Column(
            children: showing,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('View more'),
                onPressed: (() {
                  Navigator.pushNamed(context, AchievementsPage.ROUTE);
                }),
                materialTapTargetSize: MaterialTapTargetSize.padded,
              )
            ],
          ),
        ]));
  }
}

class AchievementListItem extends StatelessWidget {
  final Achievement achievement;

  AchievementListItem(this.achievement);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 20, color: Colors.black);

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
