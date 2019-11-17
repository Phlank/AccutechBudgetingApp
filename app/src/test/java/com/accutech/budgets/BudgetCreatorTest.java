package com.accutech.budgets;

import com.accutech.budgets.model.Budget;
import com.accutech.budgets.model.BudgetCreator;

import org.junit.Before;
import org.junit.Test;

import static com.accutech.budgets.model.BudgetCategory.HOUSING;
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
    public void testHousingIsAllotedTo710() {
        assertEquals(710.0, budget.getAllotment(HOUSING), 0.0);
    }

    @Test
    public void testHousingIsAllotedTo710() {
        assertEquals(710.0, budget.getAllotment(HOUSING), 0.0);
    }

    @Test
    public void testHousingIsAllotedTo710() {
        assertEquals(710.0, budget.getAllotment(HOUSING), 0.0);
    }

    @Test
    public void testHousingIsAllotedTo710() {
        assertEquals(710.0, budget.getAllotment(HOUSING), 0.0);
    }

    @Test
    public void testHousingIsAllotedTo710() {
        assertEquals(710.0, budget.getAllotment(HOUSING), 0.0);
    }

}
