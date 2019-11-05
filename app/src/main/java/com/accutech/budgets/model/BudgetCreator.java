package com.accutech.budgets.model;

import static com.accutech.budgets.model.BudgetCategory.HOUSING;

public class BudgetCreator {

    private Budget budget;
    private static int age;
    private static int monthlyIncome;
    private HousingOwnership ownership;
    private int housingPayment;
    private int debt;
    private int savings;
    private double remainingMoney;
    
    public BudgetCreator() {
    }

    public BudgetCreator setAge(int age) {
        this.age = age;
        return this;
    }

    public BudgetCreator setMonthlyIncome(int amount) {
        this.monthlyIncome = amount;
        return this;
    }

    public BudgetCreator setHousingOwnership(HousingOwnership ownership) {
        this.ownership = ownership;
        return this;
    }

    public BudgetCreator setHousingPayment(int amount) {
        this.housingPayment = amount;
        return this;
    }

    public BudgetCreator setDebt(int amount) {
        this.debt = amount;
        return this;
    }

    public BudgetCreator setSavings(int amount) {
        this.savings = amount;
        return this;
    }
    
    public Budget createBudget() {
        checkPrerequisitesNonNull();
        settleNonNegotiableCategories();
        // TODO finish this
        return budget;
    }

    private void checkPrerequisitesNonNull() {
        // TODO add guava and use prerequisites
        // TODO see https://github.com/Phlank/MusicPlayer/blob/master/src/com/github/phlank/musicplayer/model/Song.java
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

}
