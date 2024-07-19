library(tidymodels)

set.seed(1993)

# Train/test split
recipes_split = recipes_cleaned %>% initial_split()
recipes_train = recipes_split %>% training()
recipes_test = recipes_split %>% testing()

# Folds for cross-validation
recipes_folds = recipes_train %>% vfold_cv(v = 5, strata = high_traffic)

recipes_train %>% write_csv("data/recipes_train.csv")
recipes_test %>% write_csv("data/recipes_test.csv")