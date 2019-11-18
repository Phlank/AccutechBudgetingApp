package com.accutech.budgets;

import com.accutech.budgets.model.HousingOwnership;

import org.junit.Assert;
import org.junit.Test;

public class HousingOwnershipTests {

    @Test
    public void testRentReturn(){
        Assert.assertEquals(HousingOwnership.RENT, HousingOwnership.parseHousingOwnership("Renting"));
    }

    @Test
    public void testOwn_morgatge(){
        Assert.assertEquals(HousingOwnership.OWN_MORTGAGE, HousingOwnership.parseHousingOwnership("I own my housing with a mortgage"));
    }

    @Test
    public void testOwn_paid(){
        Assert.assertEquals(HousingOwnership.OWN_PAID, HousingOwnership.parseHousingOwnership("I own my housing"));
    }
}

