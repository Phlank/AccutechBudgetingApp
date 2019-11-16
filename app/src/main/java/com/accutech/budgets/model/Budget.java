package com.accutech.budgets.model;

import java.util.HashMap;
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
    private Map<BudgetCategory, Double> allottedSpending = new HashMap<>();
    private Map<BudgetCategory, Double> actualSpending =  new HashMap<>();

    public Budget() {
        populateAllottedSpending();
        populateActualSpending();
    }

    private void populateAllottedSpending() {
        allottedSpending.put(HOUSING, 0.0);
        allottedSpending.put(UTILITIES, 0.0);
        allottedSpending.put(GROCERIES, 0.0);
        allottedSpending.put(SAVINGS, 0.0);
        allottedSpending.put(HEALTH, 0.0);
        allottedSpending.put(TRANSPORTATION, 0.0);
        allottedSpending.put(EDUCATION, 0.0);
        allottedSpending.put(ENTERTAINMENT, 0.0);
        allottedSpending.put(KIDS, 0.0);
        allottedSpending.put(PETS, 0.0);
        allottedSpending.put(MISCELLANEOUS, 0.0);
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
        final Double remove = allottedSpending.remove(category);
        allottedSpending.put(category, amount);
        return remove;
    }

    public Double addSpending(BudgetCategory category, Double amount) {
        Double currentSpending = actualSpending.get(category);
        currentSpending += amount;
        actualSpending.remove(category);
        actualSpending.put(category, currentSpending);
        return currentSpending;
    }

    public Double getAllotment(BudgetCategory category) {
        return allottedSpending.get(category);
    }

    public Double getSpending(BudgetCategory category) {
        return actualSpending.get(category);
    }

    public Double getMonthlyIncome() {
        return monthlyIncome;
    }

}
