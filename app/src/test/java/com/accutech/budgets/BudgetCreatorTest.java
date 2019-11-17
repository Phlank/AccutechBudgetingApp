package com.accutech.budgets;

import com.accutech.budgets.model.Budget;
import com.accutech.budgets.model.BudgetCreator;

import org.junit.Before;
import org.junit.Test;

import static com.accutech.budgets.model.BudgetCategory.EDUCATION;
import static com.accutech.budgets.model.BudgetCategory.ENTERTAINMENT;
import static com.accutech.budgets.model.BudgetCategory.GROCERIES;
import static com.accutech.budgets.model.BudgetCategory.HEALTH;
import static com.accutech.budgets.model.BudgetCategory.HOUSING;
import static com.accutech.budgets.model.BudgetCategory.KIDS;
import static com.accutech.budgets.model.BudgetCategory.MISCELLANEOUS;
import static com.accutech.budgets.model.BudgetCategory.PETS;
import static com.accutech.budgets.model.BudgetCategory.TRANSPORTATION;
import static com.accutech.budgets.model.BudgetCategory.UTILITIES;
import static org.junit.Assert.assertEquals;

public class BudgetCreatorTest {

    private Budget budget;
    private BudgetCreator creator = new BudgetCreator();

    @Before
    public void setupTests() {
        creator.setAge("25").
                setDebt("0").
                setHousingOwnership("Renting").
                setHousingPayment("710").
                setLocation("").
                setMonthlyIncome("2500").
                setSavings("2000");
        budget = creator.createBudget();
    }

    @Test
    public void testHousingIsAllottedTo710() {
        assertEquals(710.0, budget.getAllotment(HOUSING), 0.0);
    }

    @Test
    public void testGroceriesIsAllottedTo135() {
        assertEquals(135.0, budget.getAllotment(GROCERIES), 0.0);
    }

    @Test
    public void testUtilitiesIsAllottedTo135() {
        assertEquals(135.0, budget.getAllotment(UTILITIES), 0.0);
    }

    @Test
    public void testEducationIsAllottedTo135() {
        assertEquals(135.0, budget.getAllotment(EDUCATION), 0.0);
    }

    @Test
    public void testHealthAllottedTo67_5() {
        assertEquals(67.5, budget.getAllotment(HEALTH), 0.0);
    }

    @Test
    public void testTransportationAllottedTo67_5() {
        assertEquals(67.5, budget.getAllotment(TRANSPORTATION), 0.0);
    }

    @Test
    public void testEntertainmentAllottedTo187_5() {
        assertEquals(187.5, budget.getAllotment(ENTERTAINMENT), 0.0);
    }

    @Test
    public void testKidsAllottedTo187_5() {
        assertEquals(187.5, budget.getAllotment(KIDS), 0.0);
    }

    @Test
    public void testPetsAllottedTo187_5() {
        assertEquals(187.5, budget.getAllotment(PETS), 0.0);
    }

    @Test
    public void testMiscellaneousAllottedTo187_5() {
        assertEquals(187.5, budget.getAllotment(MISCELLANEOUS), 0.0);
    }

}
