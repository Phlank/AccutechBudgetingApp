import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/achievement.dart';

/// Class that holds all defined achievements in their initial state.
abstract class Achievements {
  static Achievement achFirstOpen = Achievement(
    name: achFirstOpenName,
    title: achFirstOpenName,
    description: achFirstOpenDesc,
    currentProgress: 0,
    targetProgress: 1,
  ),
      achCameBack = Achievement(
    name: achCameBackName,
    title: achCameBackName,
    description: achCameBackDesc,
    currentProgress: 0,
    targetProgress: 2,
  ),
      achRushing = Achievement(
    name: achRushingName,
    title: achRushingName,
    description: achRushingDesc,
    currentProgress: 0,
    targetProgress: 1,
  ),
      achDetailing = Achievement(
    name: achDetailingName,
    title: achDetailingName,
    description: achDetailingDesc,
    currentProgress: 0,
    targetProgress: 1,
  ),
      achOneTransaction = Achievement(
    name: achOneTransactionName,
    title: achOneTransactionName,
    description: achOneTransactionDesc,
    currentProgress: 0,
    targetProgress: 1,
  ),
      achFiveTransactions = Achievement(
    name: achFiveTransactionsName,
    title: achFiveTransactionsName,
    description: achFiveTransactionsDesc,
    currentProgress: 0,
    targetProgress: 5,
  ),
      achChangedAllotment = Achievement(
    name: achChangedAllotmentName,
    title: achChangedAllotmentName,
    description: achChangedAllotmentDesc,
    currentProgress: 0,
    targetProgress: 1,
  ),
      achAddedGoal = Achievement(
    name: achAddedGoalName,
    title: achAddedGoalName,
    description: achAddedGoalDesc,
    currentProgress: 0,
    targetProgress: 1,
  ),
      achOneCompletedGoal = Achievement(
    name: achOneCompletedGoalName,
    title: achOneCompletedGoalName,
    description: achOneCompletedGoalDesc,
    currentProgress: 0,
    targetProgress: 1,
  );

  static final List<Achievement> defaults = [
    achFirstOpen,
    achCameBack,
    achRushing,
    achDetailing,
    achOneTransaction,
    achFiveTransactions,
    achChangedAllotment,
    achAddedGoal,
    achOneCompletedGoal,
  ];
}
