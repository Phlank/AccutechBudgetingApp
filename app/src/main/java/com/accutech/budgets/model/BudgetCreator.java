package com.accutech.budgets.model;

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

    //50%

    private void allocateMoneyForHousing() {
        budget.setAllotment(HOUSING, housingPayment);
        remainingMoney -= housingPayment;
    }

    private void allocateMoneyForUtilities() {
        Double remainingFifty = fifty - housingPayment;
        budget.setAllotment(UTILITIES, remainingFifty * .25); // Split remaining fifty between here and groceries
    }

    private void allocateMoneyForGroceries() {
        Double remainingFifty = fifty - housingPayment;
        budget.setAllotment(GROCERIES, remainingFifty * .25);
    }

    private void allocateMoneyForEducation() {
        Double remainingFifty = fifty - housingPayment;
        budget.setAllotment(EDUCATION, remainingFifty * .25);
    }

    private void allocateMoneyForHealth() {
        Double remainingFifty = fifty - housingPayment;
        budget.setAllotment(HEALTH, remainingFifty * .125);
    }

    private void allocateMoneyForTransportation() {
        Double remainingFifty = fifty - housingPayment;
        budget.setAllotment(TRANSPORTATION, remainingFifty * .125);
    }

    //30%
    private void allocateMoneyForEntertainment() {
        Double remainingThirty = thirty;
        budget.setAllotment(ENTERTAINMENT, remainingThirty * .25);
    }

    private void allocateMoneyForKids() {
        Double remainingThirty = thirty;
        budget.setAllotment(KIDS, remainingThirty * .25);
    }

    private void allocateMoneyForPets() {
        Double remainingThirty = thirty;
        budget.setAllotment(PETS, remainingThirty * .25);
    }

    private void allocateMoneyForMiscellaneous() {
        Double remainingThirty = thirty;
        budget.setAllotment(MISCELLANEOUS, remainingThirty * .25);
    }

    //20%
    private void allocateMoneyForSavings() {
        budget.setAllotment(SAVINGS, twenty);
    }

}
