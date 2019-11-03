package com.accutech.budgets;

import org.junit.Test;

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
import static com.accutech.budgets.model.Priority.HIGH;
import static com.accutech.budgets.model.Priority.LOW;
import static com.accutech.budgets.model.Priority.NON_NEGOTIABLE;
import static org.junit.Assert.assertTrue;

public class BudgetCategoryTest {

    @Test
    public void testHousingPriorityIsNonNegotiable() {
        assertTrue(HOUSING.getPriority() == NON_NEGOTIABLE);
    }

    @Test
    public void testUtilitiesPriorityIsNonNegotiable() {
        assertTrue(UTILITIES.getPriority() == NON_NEGOTIABLE);
    }

    @Test
    public void testGroceriesPriorityIsNonNegotiable() {
        assertTrue(GROCERIES.getPriority() == NON_NEGOTIABLE);
    }

    @Test
    public void testHealthPriorityIsHigh() {
        assertTrue(HEALTH.getPriority() == HIGH);
    }

    @Test
    public void testSavingsPriorityIsHigh() {
        assertTrue(SAVINGS.getPriority() == HIGH);
    }

    @Test
    public void testTransportationPriorityIsHigh() {
        assertTrue(TRANSPORTATION.getPriority() == HIGH);
    }

    @Test
    public void testEducationPriorityIsHigh() {
        assertTrue(EDUCATION.getPriority() == LOW);
    }

    @Test
    public void testEntertainmentPriorityIsLow() {
        assertTrue(ENTERTAINMENT.getPriority() == LOW);
    }

    @Test
    public void testKidsPriorityIsHigh() {
        assertTrue(KIDS.getPriority() == HIGH);
    }

    @Test
    public void testPetsPriorityIsLow() {
        assertTrue(PETS.getPriority() == LOW);
    }

    @Test
    public void testMiscellaneousPriorityIsLow() {
        assertTrue(MISCELLANEOUS.getPriority() == LOW);
    }

}
