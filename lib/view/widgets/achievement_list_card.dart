import 'package:budgetflow/view/pages/achievements_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AchievementListCard extends StatelessWidget{
  List<Achievement> earnedAchievements;
  int show;
  AchievementListCard({@required this.earnedAchievements, this.show = 1000}); // arbitrary large number
  List<AchievementCard> showing;

  getListViewVersion(){
    int count =0;
    for(Achievement a in earnedAchievements.reversed){
      showing.add(new AchievementCard(a));
      count ++;
      if(count>=show)
        break;
    }
    return ListView(
        shrinkWrap: true,
        children: showing,
    );
  }


  @override
  Widget build(BuildContext context) {

    return Card(
        child: Column(
            children: <Widget>[
              Padding(
                child: Text('Recent Transactions',
                  style: TextStyle(fontSize: 20),),
                padding: EdgeInsets.all(8.0),),
              Column(children: showing),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text('View more'),
                    onPressed: (() {
                      Navigator.pushNamed(context, AchievementsPage.ROUTE);
                    }),
                    materialTapTargetSize: MaterialTapTargetSize.padded,)],),]));
  }
}

class AchievementCard extends StatelessWidget{

  Achievement achievement;
  AchievementCard(this.achievement);

  @override
  Widget build(BuildContext context) {

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


