import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/global_widgets/main_drawer.dart';
import 'package:budgetflow/view/utils/output_formater.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GeneralCategory extends StatefulWidget {
  String section;
  static const String NEEDS_ROUTE = '/needs';
  static const String WANTS_ROUTE = '/wants';
  static const String SAVINGS_ROUTE = '/savings';

  GeneralCategory(String section) {
    this.section = section;
  }

  @override
  State<StatefulWidget> createState() => _GeneralCategoryState(section);
}

class _GeneralCategoryState extends State<GeneralCategory> {
  BudgetControl userController;
  MockBudget playBudget;
  String section;
  double allotedForCategory;
  double allotedForSection;
  double beginningAlotttments;


  _GeneralCategoryState(String section) {
    this.userController = BudgetingApp.userController;
    this.playBudget = new MockBudget(userController.getBudget());
    this.section = section;
    this.beginningAlotttments = playBudget.getNewTotalAllotted(section);
  }

  Card unbudgetedCard() {
    allotedForSection = playBudget.getNewTotalAllotted(section);
    return Card(
      shape: BeveledRectangleBorder(),
      child: Text.rich(
        TextSpan(
          text: 'Total alloted \t' +
              Format.dollarFormat(allotedForSection) +
              '\n',
          children: <TextSpan>[
            TextSpan(
                text: 'Unbudgeted in Section \t' +
                    Format.dollarFormat(allotedForSection -
                        beginningAlotttments))
          ],
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Slider sectionSlider(Category category) {
    return Slider(
      activeColor: Colors.lightGreen,
      value: allotedForCategory,
      onChanged: (value) {
        setState(() {
          allotedForCategory = value;
        });
        playBudget.setCategory(
            category, allotedForCategory);
      },
      min: 0,
      max: userController.sectionBudget(section),
      label: category.name,
    );
  }

  ListTile categoryTile(Category category) {
    allotedForCategory =
    (playBudget.budget.allotted[category]);
    return ListTile(
      title: Text(category.name + '\t' + Format.dollarFormat(allotedForCategory)),
      subtitle: sectionSlider(category),
    );
  }

  Card changeCard() {
    return Card(
      child: ListView.builder(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: userController.sectionMap[section].length,
        itemBuilder: (context, int index) {
          return categoryTile(userController.sectionMap[section][index]);
        },
      ),
    );
  }

  Scaffold generalDisplay() {
    //todo init the fluctuating allotments

    return Scaffold(
      appBar: AppBar(
        title: Text('Change ' + section + ' alotments'),
      ),
      drawer: SideMenu().sideMenu(userController),
      body: Column(
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          unbudgetedCard(),
          changeCard(),
        ],
      ),
      persistentFooterButtons: <RaisedButton>[
        RaisedButton(
          child: Text('submit'),
          onPressed: () {
            for (String category in userController.categoryMap.keys.toList()) {
              userController.changeAllotment(category,
                  playBudget.getCategory(userController.categoryMap[category]));
            }
            print(allotedForSection);
            if (allotedForSection >= 0) {
              Navigator.pushNamed(context, '/knownUser');
              userController.save();
            }
          },
        ),
        RaisedButton(
          child: Text('cancel'),
          onPressed: () {
            Navigator.pushNamed(context, '/knownUser');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => generalDisplay();
}
