package com.accutech.budgets.model;

import java.util.Map;

import static com.accutech.budgets.model.BudgetCategory.EDUCATION;
import static com.accutech.budgets.model.BudgetCategory.ENTERTAINMENT;
import static com.accutech.budgets.model.BudgetCategory.GROCERIES;
import static com.accutech.budgets.model.BudgetCategory.HEALTH;
import static com.accutech.budgets.model.BudgetCategory.HOUSING;
import static com.accutech.budgets.model.BudgetCategory.KIDS;
import static com.accutech.budgets.model.BudgetCategory.MISCELLANEOUS;
import static com.accutech.budgets.model.BudgetCategory.PETS;
import static com.accutech.budgets.model.BudgetCategory.SAVINGS;
import static com.accutech.budgets.model.BudgetCategory.TRANSPORTATION;
import static com.accutech.budgets.model.BudgetCategory.UTILITIES;

public class Budget {

    private Double monthlyIncome = 0.0;
    private Map<BudgetCategory, Double> allotedSpending;
    private Map<BudgetCategory, Double> actualSpending;

    public Budget() {
        populateRecommendedSpending();
        populateActualSpending();
    }

    private void populateRecommendedSpending() {
        allotedSpending.put(HOUSING, 0.0);
        allotedSpending.put(UTILITIES, 0.0);
        allotedSpending.put(GROCERIES, 0.0);
        allotedSpending.put(SAVINGS, 0.0);
        allotedSpending.put(HEALTH, 0.0);
        allotedSpending.put(TRANSPORTATION, 0.0);
        allotedSpending.put(EDUCATION, 0.0);
        allotedSpending.put(ENTERTAINMENT, 0.0);
        allotedSpending.put(KIDS, 0.0);
        allotedSpending.put(PETS, 0.0);
        allotedSpending.put(MISCELLANEOUS, 0.0);
    }

    private void populateActualSpending() {
        actualSpending.put(HOUSING, 0.0);
        actualSpending.put(UTILITIES, 0.0);
        actualSpending.put(GROCERIES, 0.0);
        actualSpending.put(SAVINGS, 0.0);
        actualSpending.put(HEALTH, 0.0);
        actualSpending.put(TRANSPORTATION, 0.0);
        actualSpending.put(EDUCATION, 0.0);
        actualSpending.put(ENTERTAINMENT, 0.0);
        actualSpending.put(KIDS, 0.0);
        actualSpending.put(PETS, 0.0);
        actualSpending.put(MISCELLANEOUS, 0.0);
    }

    public void setMonthlyIncome(double income) {
        this.monthlyIncome = income;
    }

    public Double setAllotment(BudgetCategory category, Double amount) {
        final Double remove = allotedSpending.remove(category);
        allotedSpending.put(category, amount);
        return remove;
    }

    public Double addSpending(BudgetCategory category, Double amount) {
        Double currentSpending = actualSpending.get(category);
        currentSpending += amount;
        actualSpending.remove(category);
        actualSpending.put(category, currentSpending);
        return currentSpending;
    }

}
