library(GGally)

# Data pairplot with scaling
recipes_cleaned %>%
  # Min-Max scaling
  mutate(
    across(
      .cols = where(is.numeric),
      .fns = ~( (.x -min(.x)) / (max(.x) - min(.x)) )
    )
  ) %>%
  ggpairs(mapping = ggplot2::aes(colour = high_traffic), columns = recipes_cleaned %>% select_if(is.numeric) %>% names(), title = "Pairplot of numeric variables after scaling") %>%
  ggsave(filename = "graphics/EDA02.png", width = 6, height = 4, units = "in", dpi = 300)
