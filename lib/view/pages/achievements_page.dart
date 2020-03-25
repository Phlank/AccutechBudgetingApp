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
        itemCount: AchievementsInformation.availableAchievements.length,
        itemBuilder:(BuildContext context, int index){
          return achievementCard(AchievementsInformation.availableAchievements[index]);
        },

      )
    );
  }

  Color textStyleColor(bool isAchieved){
    if(isAchieved) return Colors.black;
    return Colors.grey;
  }

  Card achievementCard(Achievement achievement) {
    TextStyle style = TextStyle(
      fontSize: 20,
      color: textStyleColor(achievement.isAchieved),
    );
    return Card(
      child: Table(
        children: <TableRow>[
          TableRow(
            children: <TableCell>[
              TableCell(child: Text(achievement.name, style: style, textAlign: TextAlign.left,)),
              TableCell(child: Text(achievement.xpGoal.toString(), style: style, textAlign: TextAlign.right,))
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

class AchievementsInformation{

  static List<Achievement> availableAchievements = [
    new Achievement(name:'started', description:'Hello new comer', xpGoal: 0, icon:Icon(null), isAchieved:false),
  ];

  static void recordAchieved(Achievement achieved){
    for(Achievement achieve in availableAchievements){
      if(achieve.name==achieved.name){
        achieve.isAchieved=true;
      }
    }
  }

  static void checkEarnedXP(int earnedXp){
    for(Achievement achievement in availableAchievements){
      if(earnedXp==achievement.xpGoal){
        recordAchieved(achievement);
        //todo subtract xp from user
      }
    }
  }

  static void loadAchieved(){
    //todo
  }

  static void saveAchieved(){
    //todo
  }

}

class Achievement{
  int xpGoal;
  String name;
  Icon icon;
  bool isAchieved;
  Function action;
  String description;

  Achievement({
      @required this.name,
      @required this.description,
      @required this.xpGoal,
      @required this.icon,
      @required this.isAchieved,
      this.action}
      );
}