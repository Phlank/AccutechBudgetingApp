package com.accutech.budgets.model;

public class BudgetCreator {

    private static int age;
    private static int monthlyIncome;
    private static HousingOwnership housingOwnership;
    private static int housingPayment;
    private static int debt;
    private static int savings;

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
        // TODO this
        return null;
    }

    private void setMonthlyIncome(Budget budget) {

    }

    private void setSpendingLimits(Budget budget) {

    }

}
