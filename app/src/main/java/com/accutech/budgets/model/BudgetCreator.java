package com.accutech.budgets.model;

import static com.accutech.budgets.model.BudgetCategory.GROCERIES;
import static com.accutech.budgets.model.BudgetCategory.HOUSING;
import static com.accutech.budgets.model.BudgetCategory.UTILITIES;
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

    private Double fifty;
    private Double thirty;
    private Double twenty;

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
                checkNotNull(savingsInput),
                checkNotNull(locationInput));
    }

    private Budget createBudgetFromInputs(String age, String income, String housingOwnership, String housingPayment, String debt, String savings, String location) {
        convertInputsToTypes();
        budget = new Budget();
        remainingMoney = this.income;
        allocateMoney();
        return budget;
    }

    private void convertInputsToTypes() {
        age = Integer.parseInt(ageInput);
        income = Double.parseDouble(incomeInput);
        housingOwnership = HousingOwnership.parseHousingOwnership(housingOwnershipInput);
        housingPayment = Double.parseDouble(housingPaymentInput);
        debt = Double.parseDouble(debtInput);
        savings = Double.parseDouble(savingsInput);
        fifty = income * 0.5;
        thirty = income * 0.3;
        twenty = income * 0.2;
    }

    private void allocateMoney() {
        allocateMoneyForHousing();
        allocateMoneyForUtilities();
        allocateMoneyForGroceries();
        allocateMoneyForSavings();
        allocateMoneyForHealth();
        allocateMoneyForTransportation();
        allocateMoneyForEducation();
        allocateMoneyForEntertainment();
        allocateMoneyForKids();
        allocateMoneyForPets();
        allocateMoneyForMiscellaneous();
    }

    private void allocateMoneyForHousing() {
        budget.setAllotment(HOUSING, housingPayment);
        remainingMoney -= housingPayment;
    }

    private void allocateMoneyForUtilities() {
        Double remainingFifty = fifty - (income - remainingMoney);
        budget.setAllotment(UTILITIES, remainingFifty * 0.5); // Split remaining fifty between here and groceries
    }

    private void allocateMoneyForGroceries() {
        Double remainingFifty = fifty - (income - remainingMoney);
        budget.setAllotment(GROCERIES, remainingFifty * 0.5);
    }

    private void allocateMoneyForSavings() {

    }

    private void allocateMoneyForHealth() {

    }

    private void allocateMoneyForTransportation() {

    }

    private void allocateMoneyForEducation() {

    }

    private void allocateMoneyForEntertainment() {
    }

    private void allocateMoneyForKids() {
    }

    private void allocateMoneyForPets() {
    }

    private void allocateMoneyForMiscellaneous() {
    }

}
