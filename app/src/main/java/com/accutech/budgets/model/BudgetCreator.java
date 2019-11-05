package com.accutech.budgets.model;

import static com.accutech.budgets.model.BudgetCategory.HOUSING;

public class BudgetCreator {

    private static Budget budget;
    private static int age;
    private static int monthlyIncome;
    private static HousingOwnership housingOwnership;
    private static int housingPayment;
    private static int debt;
    private static int savings;
    private static double remainingMoney;

    public static void setAge(int age) {
        BudgetCreator.age = age;
    }

    public static void setMonthlyIncome(int income) {
        monthlyIncome = income;
    }

    public static void setHousingOwnership(HousingOwnership ownership) {
        housingOwnership = ownership;
    }

    public static void setHousingPayment(int payment) {
        housingPayment = payment;
    }

    public static void setDebt(int debt) {
        BudgetCreator.debt = debt;
    }

    public static void setSavings(int savings) {
        BudgetCreator.savings = savings;
    }

    public Budget createBudget() {
        settleNonNegotiableCategories();
        // TODO finish this
        return budget;
    }

    private void settleNonNegotiableCategories() {
        settleHousing();
        settleUtilities();
        settleGroceries();
    }

    private void settleHousing() {
        budget.setRecommendation(HOUSING, (double) housingPayment);
        remainingMoney -= housingPayment;
    }

    private void settleUtilities() {
        // TODO average utilites based on housing cost in location?
    }

    private void settleGroceries() {
        // TODO average groceries based on housing cost in location?
    }

    private void setMonthlyIncome(Budget budget) {

    }

    private void setSpendingLimits(Budget budget) {

    }

}
