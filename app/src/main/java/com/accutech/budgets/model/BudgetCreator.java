package com.accutech.budgets.model;

import static com.accutech.budgets.model.BudgetCategory.HOUSING;
import static com.google.common.base.Preconditions.checkNotNull;

public class BudgetCreator {

    private static String ageInput;
    private static String incomeInput;
    private static String housingOwnershipInput;
    private static String housingPaymentInput;
    private static String debtInput;
    private static String savingsInput;
    private static String locationInput;

    private int age;
    private double income;
    private HousingOwnership housingOwnership;
    private double housingPayment;
    private double debt;
    private double savings;

    private Budget budget;
    private static Double remainingMoney;

    public BudgetCreator() {
    }

    public BudgetCreator setAge(String age) {
        ageInput = age;
        return this;
    }

    public BudgetCreator setMonthlyIncome(String amount) {
        incomeInput = amount;
        return this;
    }

    public BudgetCreator setHousingOwnership(String ownership) {
        housingOwnershipInput = ownership;
        return this;
    }

    public BudgetCreator setHousingPayment(String amount) {
        housingPaymentInput = amount;
        return this;
    }

    public BudgetCreator setDebt(String amount) {
        debtInput = amount;
        return this;
    }

    public BudgetCreator setSavings(String amount) {
        savingsInput = amount;
        return this;
    }

    public BudgetCreator setLocation(String location) {
        locationInput = location;
        return this;
    }
    
    public Budget createBudget() {
        return createBudgetFromInputs(
                checkNotNull(ageInput),
                checkNotNull(incomeInput),
                checkNotNull(housingOwnershipInput),
                checkNotNull(housingPaymentInput),
                checkNotNull(debtInput),
                checkNotNull(savingsInput));
    }

    private Budget createBudgetFromInputs(String age, String income, String housingOwnership, String housingPayment, String debt, String savings) {
        budget = new Budget();
        return budget;
    }

    private void allocateHousing() {
        budget.setAllotment(HOUSING, housingPayment);
        remainingMoney -= housingPayment;
    }

    private void settleUtilities() {
        // TODO average utilites based on housing cost in location?
    }

    private void settleGroceries() {
        // TODO average groceries based on housing cost in location?
    }

}
