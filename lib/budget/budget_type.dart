enum BudgetType{
  savingGrowth,
  savingDepletion
}

Map<BudgetType, String> typeJson = {
  BudgetType.savingGrowth: "Growth",
  BudgetType.savingDepletion: "Depletion"
};

Map<String, BudgetType> jsonType = {
  "Growth": BudgetType.savingGrowth,
  "Depletion": BudgetType.savingDepletion
};