library(tidyverse)

recipes = read_csv('data/recipe_site_traffic_2212.csv', show_col_types = FALSE)

recipes_cleaned = recipes %>%
  # Clean servings
  mutate(servings = ifelse(servings == "4 as a snack", "4", servings)) %>%
  mutate(servings = ifelse(servings == "6 as a snack", "6", servings)) %>%
  mutate(servings = factor(servings)) %>%
  # Clean high_traffic, using null to detect 0's
  mutate(high_traffic = ifelse(is.na(high_traffic), 0, 1)) %>%
  mutate(high_traffic = factor(high_traffic)) %>%
  # Factor category variable
  mutate(category = factor(category)) %>%
  # Clean missing values
  group_by(category) %>%
  mutate(across(
    .cols = where(is.numeric),
    .fns = ~ifelse(is.na(.x), median(.x, na.rm = TRUE), .x),
    .names = "{col}"
  )) %>%
  ungroup()

recipes_cleaned %>% write_csv('data/recipe_cleaned.csv')