package com.accutech.budgets.model;

public enum BudgetCategory {

    HOUSING,
    UTILITIES,
    GROCERIES,
    SAVINGS,
    HEALTH,
    TRANSPORTATION,
    EDUCATION,
    ENTERTAINMENT,
    KIDS,
    PETS,
    MISCELLANEOUS;

    private static final Double HOUSING_MINIMUM = 0.0;
    private static final Double UTILITIES_MINIMUM = 0.0;
    private static final Double GROCERIES_MINIMUM = 0.0;
    private static final Double SAVINGS_MINIMUM = 0.0;
    private static final Double HEALTH_MINIMUM = 0.0;
    private static final Double TRANSPORTATION_MINIMUM = 0.0;
    private static final Double EDUCATION_MINIMUM = 0.0;
    private static final Double ENTERTAINMENT_MINIMUM = 0.0;
    private static final Double KIDS_MINIMUM = 0.0;
    private static final Double PETS_MINIMUM = 0.0;
    private static final Double MISCELLANEOUS_MINIMUM = 0.0;

    public Double getMinimum() {
        switch (this) {
            case HOUSING:
                return HOUSING_MINIMUM;
            case UTILITIES:
                return UTILITIES_MINIMUM;
            case GROCERIES:
                return GROCERIES_MINIMUM;
            case SAVINGS:
                return SAVINGS_MINIMUM;
            case HEALTH:
                return HEALTH_MINIMUM;
            case TRANSPORTATION:
                return TRANSPORTATION_MINIMUM;
            case EDUCATION:
                return EDUCATION_MINIMUM;
            case ENTERTAINMENT:
                return ENTERTAINMENT_MINIMUM;
            case KIDS:
                return KIDS_MINIMUM;
            case PETS:
                return PETS_MINIMUM;
            case MISCELLANEOUS:
                return MISCELLANEOUS_MINIMUM;
            default:
                return null;
        }
    }

}
