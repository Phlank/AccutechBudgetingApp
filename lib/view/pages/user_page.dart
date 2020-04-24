import 'package:budgetflow/global/achievements.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/implementations/services/account_service.dart';
import 'package:budgetflow/model/implementations/services/achievement_service.dart';
import 'package:budgetflow/model/implementations/services/encryption_service.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/services/history_service.dart';
import 'package:budgetflow/model/implementations/services/location_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/view/achievement_responder.dart';
import 'package:budgetflow/view/budgeting_app.dart';
import 'package:budgetflow/view/pages/accounts_page.dart';
import 'package:budgetflow/view/pages/basic_loading_page.dart';
import 'package:budgetflow/view/pages/error_page.dart';
import 'package:budgetflow/view/pages/setup/welcome_page.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:budgetflow/view/widgets/achievement_list_card.dart';
import 'package:budgetflow/view/widgets/page_cards.dart';
import 'package:budgetflow/view/widgets/priority_bar_chart/priority_chart_row.dart';
import 'package:budgetflow/view/widgets/transaction/edit/transaction_edit_page.dart';
import 'package:budgetflow/view/widgets/transaction/transaction_list_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserPage extends StatefulWidget {
  static const ROUTE = '/knownUser';

  @override
  _UserPageState createState() => new _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future _servicesPreparation;

  Future _prepareServices() async {
    print('UserPage: Starting Future...');
    ServiceDispatcher dispatcher = BudgetingApp.control.dispatcher;
    await dispatcher.registerAndStart(FileService(dispatcher));
    await dispatcher.registerAndStart(EncryptionService(dispatcher));
    await dispatcher.registerAndStart(AchievementService(dispatcher));
    await dispatcher.registerAndStart(AccountService(dispatcher));
    await dispatcher.registerAndStart(HistoryService(dispatcher));
    await dispatcher.registerAndStart(LocationService(dispatcher));
    print('UserPage: Finished Future.');
    return true;
  }

  @override
  void initState() {
    super.initState();
    _servicesPreparation = _prepareServices();
  }

  Widget _buildUserScaffold() {
    // TODO break into smaller pieces
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: () {
              while (Navigator.of(context).canPop())
                Navigator.of(context).pop();
              Navigator.of(context)
                  .push(RouteUtil.routeWithSlideTransition(WelcomePage()));
            },
            ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              BudgetingApp.control.forceNextMonthTransition();
            },
            ),
        ],
        ),
//      drawer: SideMenu().sideMenu(BudgetingApp.userController),
      body: ListView(
        padding: EdgeInsets.all(8),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          PriorityChartRow(),
          GlobalCards.cashFlowBudgetCard(),
          TransactionListCard(BudgetingApp.control.getLoadedTransactions()),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(RouteUtil.routeWithSlideTransition(AccountsPage()));
                },
                child: Text('Accounts'),
                ),
            ],
            alignment: MainAxisAlignment.center,
            ),
          AchievementListCard(
            numAchievements: 3,
            ),
        ],
        ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add transaction',
        child: Icon(Icons.add),
        onPressed: () async {
          await TransactionEditPage.show(Transaction.empty, context);
          AchievementResponder.respondTo(
              Achievements.achOneTransaction, context);
          AchievementResponder.respondTo(
              Achievements.achFiveTransactions, context);
        },
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _servicesPreparation,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildUserScaffold();
        } else if (snapshot.hasError) {
          return ErrorPage();
        } else {
          return BasicLoadingPage(
            title: 'Loading',
            message: 'Loading information...',
            );
        }
      },
      );
  }
}

class SectionData {
  final int amt;
  final String state;

  SectionData(this.amt, this.state);
}
