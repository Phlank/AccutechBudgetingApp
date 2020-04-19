import 'package:budgetflow/global/presets.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/model/implementations/budget_accountant.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/utils/output_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GeneralCategory extends StatefulWidget {
  String section;
  static final String needsRoute = '/' + Priority.needs.name;
  static final String wantsRoute = '/' + Priority.wants.name;
  static final String savingsRoute = '/' + Priority.savings.name;

  GeneralCategory(String section) {
    this.section = section;
  }

  @override
  State<StatefulWidget> createState() => _GeneralCategoryState(section);
}

class _GeneralCategoryState extends State<GeneralCategory> {
  BudgetAccountant accountant =
  BudgetAccountant(BudgetingApp.control.getBudget());
  BudgetControl userController;
  MockBudget playBudget;
  String section;
  double allottedForCategory;
  double allottedForSection;
  double beginningAllotments;

  _GeneralCategoryState(String section) {
    this.userController = BudgetingApp.control;
    this.playBudget = new MockBudget(userController.getBudget());
    this.section = section;
    this.beginningAllotments = playBudget.getNewTotalAllotted(section);
  }

  Card unbudgetedCard() {
    allottedForSection = playBudget.getNewTotalAllotted(section);
    return Card(
      shape: BeveledRectangleBorder(),
      child: Text.rich(
        TextSpan(
          text: 'Total alloted \t' +
              Format.dollarFormat(allottedForSection) +
              '\n',
          children: <TextSpan>[
            TextSpan(
                text: 'Unbudgeted in Section \t' +
                    Format.dollarFormat(
                        allottedForSection - beginningAllotments))
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
      value: allottedForCategory,
      onChanged: (value) {
        setState(() {
          if (allottedForSection >
              accountant.getAllottedOfPriority(category.priority)) return;
          allottedForCategory = value;
        });
        playBudget.setCategory(category, allottedForCategory);
      },
      min: 0,
      max: accountant.getAllottedOfPriority(Priority.fromName(section)),
      label: category.name,
    );
  }

  ListTile categoryTile(Category category) {
    allottedForCategory =
        playBudget.budget.allotted
            .getCategory(category)
            .value;
    return ListTile(
      title:
      Text(category.name + '\t' + Format.dollarFormat(allottedForCategory)),
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
        itemCount: userController
            .getBudget()
            .getCategoriesOfPriority(Priority.fromName(section))
            .length,
        itemBuilder: (context, int index) {
          return categoryTile(userController
              .getBudget()
              .getCategoriesOfPriority(Priority.fromName(section))[index]);
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
            // To anyone reads this in the near future, I'm sorry, I recognize
            // that this type of chaining shouldn't need to exist, though I'm
            // not sure what to do to fix it right now.
            for (Category category in BudgetingApp.control
                .getBudget()
                .getCategoriesOfPriority(Priority.fromName(section))) {
              BudgetingApp.control
                  .getBudget()
                  .allotted
                  .getCategory(category)
                  .value = playBudget.getCategory(category);
            }
            BudgetingApp.control.dispatcher
                .getAchievementService()
                .earn(achChangedAllotment);
            if (allottedForSection >= 0) {
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
