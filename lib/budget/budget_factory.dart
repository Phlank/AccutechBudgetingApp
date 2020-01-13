import 'package:budgetflow/budget/budget.dart';
import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/budget_type.dart';

class BudgetFactory {
	Map<BudgetCategory, double> _allottedSpending;
	double _housingRatio;
	String budgetPlan;

	double income;
	double wantsRatio;
	double needsRatio;
	double savingsRatio;
	double wantsAmount;
	double needsAmount;
	double savingsAmount;
	double targetWantsAmount;
	double targetNeedsAmount;
	double targetNeedsRatio;
	double targetWantsRatio;
	double targetSavingsRatio;
	double remainingNeedsRatio;
	double remainingWantsRatio;
	double remainingBudgetRatio;

	double usedBudget;
	double usedNeeds;
	double usedWants;
	double UsedSavings;
	double newWants;
	double newNeeds;
	double NewSavings;
	double NewBudgetSplit;
	double RemainingPercentage;
	double RemainingMoney;

	BudgetFactory() {
		_allottedSpending = new Map();
	}

	static Budget newFromInfo(double income, double housing, BudgetType type) {
		BudgetFactory bf = new BudgetFactory();
		bf.startFactory(type);
		Budget newBudget = new Budget(income);
		newBudget.setType(type);
		newBudget.setAllotment(BudgetCategory.housing, housing);
		bf._housingRatio = housing / income;
		bf.startFactory(type);
		bf.updateWantsAndNeeds();
		bf.checkForSwitch();
		newBudget = bf.updateAllottments(newBudget);
		return newBudget;
	}

	static Budget newFromBudget(Budget old) {
		BudgetFactory bf = new BudgetFactory();
		bf.income = old.getMonthlyIncome();
		double remaining = bf.calculateRemainingAllottment(old);
		double spent = bf.income - remaining;
		bf.usedWants = spent * old.wantsRatio;
		bf.usedNeeds = spent * old.needsRatio;
		if (spent > 0.0) {
			// They can't get their own budget working for them, need more time
			Budget newBudget = Budget.fromOldAllottments(old);
			return newBudget;
		}
		bf.newWants = bf.usedWants / bf.income;
		bf.newNeeds = bf.usedNeeds / bf.income;
		double remainingMoney = bf.income * (1 - bf.newWants + bf.newNeeds);
		bf.checkForSwitch();
		Budget newBudget = new Budget(bf.income);
		bf.allocateBudget(bf.budgetPlan);
		newBudget = bf.updateAllottments(newBudget);
		return newBudget;
	}

	void startFactory(BudgetType type) {
		if (type == BudgetType.savingDepletion) {
			setBudgetDepletionRatio();
		} else {
			type = BudgetType.savingGrowth;
			setBudgetGrowthRatio();
		}
	}

	void updateWantsAndNeeds() {
		wantsAmount = income * wantsRatio;
		needsAmount = income * needsRatio;
		targetWantsAmount = income * targetWantsRatio;
		targetNeedsAmount = income * targetNeedsRatio;
	}

	void setBudgetDepletionRatio() {
		if (_housingRatio < 0 && _housingRatio > .3) {
			budgetPlan = "Stage 1-2";
			allocateBudget(budgetPlan);
		} else if (_housingRatio < .3 && _housingRatio > .5) {
			budgetPlan = "Stage 2-2";
			allocateBudget(budgetPlan);
		} else if (_housingRatio < .5 && _housingRatio > .8) {
			budgetPlan = "Stage 3-2";
			allocateBudget(budgetPlan);
		} else if (_housingRatio < .8) {
			budgetPlan = "Stage 4-2";
			allocateBudget(budgetPlan);
		}
	}

	void setBudgetGrowthRatio() {
		if (_housingRatio < 0 && _housingRatio > .3) {
			budgetPlan = "Stage 1-1";
			allocateBudget(budgetPlan);
		} else if (_housingRatio < .3 && _housingRatio > .5) {
			budgetPlan = "Stage 2-1";
			allocateBudget(budgetPlan);
		} else if (_housingRatio < .5 && _housingRatio > .8) {
			budgetPlan = "Stage 3-1";
			allocateBudget(budgetPlan);
		} else if (_housingRatio < .8) {
			budgetPlan = "Stage 4-1";
			allocateBudget(budgetPlan);
		}
	}

	void allocateBudget(String s) {
		switch (s) {
			case ("Stage 1-2"):
				setDepletingBudget(0.6, 0.4);
				break;
			case ("Stage 2-2"):
				setDepletingBudget(0.75, 0.25);
				setDepletingTargetBudget(0.6, 0.4);
				break;
			case ("Stage 3-2"):
				setDepletingBudget(0.85, 0.15);
				setDepletingTargetBudget(0.75, 0.25);
				break;
			case ("Stage 4-2"):
				setDepletingBudget(0.95, 0.05);
				setDepletingTargetBudget(0.85, 0.15);
				break;
			case ("Stage 1-1"):
				setGrowthBudget(0.5, 0.2, 0.3);
				break;
			case ("Stage 2-1"):
				setGrowthBudget(0.65, 0.2, 0.15);
				setTargetBudget(0.5, 0.2, 0.3);
				break;
			case ("Stage 3-1"):
				setGrowthBudget(0.75, 0.1, 0.15);
				setTargetBudget(0.65, 0.2, 0.15);
				break;
			case ("Stage 4-1"):
				setGrowthBudget(0.9, 0.05, 0.05);
				setTargetBudget(0.75, 0.1, 0.15);
				break;
			default:
				break;
		}
	}

	Budget updateAllottments(Budget budget) {
		needsRatio -= _housingRatio;
		double dNeedsRatio = income * needsRatio / 4.0;
		double dWantsRatio = income * wantsRatio / 5.0;
		budget.setAllotment(BudgetCategory.utilities, dNeedsRatio);
		budget.setAllotment(BudgetCategory.groceries, dNeedsRatio);
		budget.setAllotment(BudgetCategory.health, dNeedsRatio);
		budget.setAllotment(BudgetCategory.transportation, dNeedsRatio);
		budget.setAllotment(BudgetCategory.education, dWantsRatio);
		budget.setAllotment(BudgetCategory.entertainment, dWantsRatio);
		budget.setAllotment(BudgetCategory.kids, dWantsRatio);
		budget.setAllotment(BudgetCategory.pets, dWantsRatio);
		budget.setAllotment(BudgetCategory.miscellaneous, dWantsRatio);
		budget.setAllotment(BudgetCategory.savings, income * savingsRatio);
		return budget;
	}

	double setNeeds(needs) {
		this.needsRatio = needs;
		this.needsAmount = income * needs;
	}

	double getNeeds() {
		return wantsRatio;
	}

	double getNeedsAmount() {
		return wantsAmount;
	}

	double setWants(Wants) {
		this.wantsRatio = Wants;
		this.wantsAmount = income * Wants;
	}

	double getWants() {
		return wantsRatio;
	}

	double getWantsAmount() {
		return wantsAmount;
	}

	double setRemainingBudget() {
		this.remainingBudgetRatio = remainingNeedsRatio + remainingWantsRatio;
	}

	void setDepletingBudget(double n, double w) {
		needsRatio = n;
		wantsRatio = w;
	}

	double setDepletingTargetBudget(double n, double w) {
		targetNeedsRatio = n;
		targetWantsRatio = w;
	}

	void setGrowthBudget(double n, double s, double w) {
		needsRatio = n;
		savingsRatio = s;
		wantsRatio = w;
	}

	double setTargetBudget(double n, double s, double w) {
		targetNeedsRatio = n;
		targetSavingsRatio = s;
		targetWantsRatio = w;
	}

	double calculateRemainingAllottment(Budget old) {
		double remainingNeeds = old.getAllotment(BudgetCategory.utilities) +
			old.getAllotment(BudgetCategory.groceries) +
			old.getAllotment(BudgetCategory.health) +
			old.getAllotment(BudgetCategory.transportation) -
			old.getSpending(BudgetCategory.utilities) +
			old.getSpending(BudgetCategory.groceries) +
			old.getSpending(BudgetCategory.health) +
			old.getSpending(BudgetCategory.transportation);
		double remainingWants = old.getAllotment(BudgetCategory.education) +
			old.getAllotment(BudgetCategory.entertainment) +
			old.getAllotment(BudgetCategory.kids) +
			old.getAllotment(BudgetCategory.pets) +
			old.getAllotment(BudgetCategory.miscellaneous) -
			old.getSpending(BudgetCategory.education) -
			old.getSpending(BudgetCategory.entertainment) -
			old.getSpending(BudgetCategory.kids) -
			old.getSpending(BudgetCategory.pets) -
			old.getSpending(BudgetCategory.miscellaneous);
		usedWants = remainingWants;
		usedNeeds = remainingNeeds;
		return remainingNeeds + remainingWants;
	}

	void checkForSwitch() {
		if (newWants < wantsRatio && newNeeds < needsRatio) {
			switch (budgetPlan) {
				case ("Stage 1-2"):
					budgetPlan = "Stage 1-2";
					allocateBudget(budgetPlan);
					break;
				case ("Stage 2-2"):
					budgetPlan = "Stage 1-2";
					allocateBudget(budgetPlan);
					break;
				case ("Stage 3-2"):
					budgetPlan = "Stage 2-2";
					allocateBudget(budgetPlan);
					break;
				case ("Stage 4-2"):
					budgetPlan = "Stage 3-2";
					allocateBudget(budgetPlan);
					break;
				case ("Stage 1-1"):
					budgetPlan = "Stage 1-1";
					allocateBudget(budgetPlan);
					break;
				case ("Stage 2-1"):
					budgetPlan = "Stage 1-1";
					allocateBudget(budgetPlan);
					break;
				case ("Stage 3-1"):
					budgetPlan = "Stage 2-1";
					allocateBudget(budgetPlan);
					break;
				case ("Stage 4-1"):
					budgetPlan = "Stage 3-1";
					allocateBudget(budgetPlan);
					break;
				default:
					break;
			}
		}
	}

	void bruh() {}
}
