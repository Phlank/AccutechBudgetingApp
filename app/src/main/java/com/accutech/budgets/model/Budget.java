package com.accutech.budgets.model;

public class Budget {

    public class BudgetFactory {

        int age;
        int monthlyIncome;
        HousingOwnership housingOwnership;
        int housingPayment;
        int debt;
        int savings;

        public BudgetFactory() {
        }

        public void setAge(int age) {
            this.age = age;
        }

        public void setMonthlyIncome(int income) {
            monthlyIncome = income;
        }

        public void setHousingOwnership(HousingOwnership ownership) {
            housingOwnership = ownership;
        }

        public void setHousingPayment(int payment) {
            housingPayment = payment;
        }

        public void setDebt(int debt) {
            this.debt = debt;
        }

        public void setSavings(int savings) {
            this.savings = savings;
        }

        public Budget createBudget() {
            return new Budget(age, monthlyIncome, housingOwnership, housingPayment, debt, savings);
        }

    }

    private Budget(int age, int monthlyIncome, HousingOwnership housingOwnership, int housingPayment, int debt, int savings) {
        // TODO implement budget from minimum info required
    }

}
