library(GGally)

recipes_cleaned %>%
  select_if(~!is.numeric(.x)) %>%
  select(-recipe) %>%
  ggpairs(mapping = ggplot2::aes(colour = high_traffic), upper = NULL, showStrips = TRUE, axisLabels = "none", title = "Qualitative variables' pairplot") %>%
  ggsave(filename = "graphics/EDA03.png", width = 6, height = 4, units = "in", dpi = 300)