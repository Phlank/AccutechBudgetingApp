package com.accutech.budgets;

import com.accutech.budgets.model.Budget;

import org.junit.Before;
import org.junit.Test;

import static com.accutech.budgets.model.BudgetCategory.GROCERIES;
import static com.accutech.budgets.model.BudgetCategory.HOUSING;
import static com.accutech.budgets.model.BudgetCategory.UTILITIES;
import static org.junit.Assert.assertEquals;

public class BudgetTest {

    private Budget budget;

    @Before
    public void setupTests() {
        budget = new Budget();
        budget.setAllotment(HOUSING, 710.0);
        budget.setAllotment(GROCERIES, 300.0);
        budget.setAllotment(UTILITIES, 200.0);
    }

    @Test
    public void testHousingAllotmentIs710() {
        assertEquals(710.0, budget.getAllotment(HOUSING), 0.0);
    }

    @Test
    public void testGrocieriesAllotmentIs300() {
        assertEquals(300.0, budget.getAllotment(GROCERIES), 0.0);
    }

    @Test
    public void testUtilitiesAllotmentIs200() {
        assertEquals(200.0, budget.getAllotment(UTILITIES), 0.0);
    }

    @Test
    public void testAddingSpendingToBudget() {
        budget.addSpending(HOUSING, 710.0);
        assertEquals(710.0, budget.getSpending(HOUSING), 0.0);
    }

}
