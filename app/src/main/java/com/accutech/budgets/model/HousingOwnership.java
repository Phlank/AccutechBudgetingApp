package com.accutech.budgets.model;

public enum HousingOwnership {

    RENT,
    OWN_PAID,
    OWN_MORTGAGE;

    private static final String RENT_PARSE = "I rent my housing";
    private static final String OWN_MORTGAGE_PARSE = "I own my housing with a mortgage";
    private static final String OWN_PAID_PARSE = "I own my housing";

    public static HousingOwnership parseHousingOwnership(String string) {
        switch (string) {
            case RENT_PARSE:
                return RENT;
            case OWN_MORTGAGE_PARSE:
                return OWN_MORTGAGE;
            case OWN_PAID_PARSE:
                return OWN_PAID;
            default:
                return null;
        }
    }

}
