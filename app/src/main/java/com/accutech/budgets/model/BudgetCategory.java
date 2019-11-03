package com.accutech.budgets.model;

import static com.accutech.budgets.model.Priority.HIGH;
import static com.accutech.budgets.model.Priority.LOW;
import static com.accutech.budgets.model.Priority.NON_NEGOTIABLE;

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

    public Priority getPriority() {
        switch (this) {
            case HOUSING:
                return NON_NEGOTIABLE;
            case UTILITIES:
                return NON_NEGOTIABLE;
            case GROCERIES:
                return NON_NEGOTIABLE;
            case SAVINGS:
                return HIGH;
            case HEALTH:
                return HIGH;
            case TRANSPORTATION:
                return HIGH;
            case EDUCATION:
                return LOW;
            case ENTERTAINMENT:
                return LOW;
            case KIDS:
                return HIGH;
            case PETS:
                return LOW;
            case MISCELLANEOUS:
                return LOW;
            default:
                return LOW;
        }
    }

}
