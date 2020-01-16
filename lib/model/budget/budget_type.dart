enum BudgetType{
  savingGrowth,
  savingDepletion
}

Map<BudgetType, String> budgetTypeJson = {
  BudgetType.savingGrowth: "Growth",
  BudgetType.savingDepletion: "Depletion"
};

Map<String, BudgetType> jsonBudgetType = {
  "Growth": BudgetType.savingGrowth,
  "Depletion": BudgetType.savingDepletion
};