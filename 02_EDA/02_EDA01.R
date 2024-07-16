library(GGally)

# Data pairplot without scaling
recipes_cleaned %>%
  # Numeric correlation
  ggpairs(mapping = ggplot2::aes(colour = high_traffic), columns = recipes %>% select_if(is.numeric) %>% names(), title = "Pairplot of numeric variables") %>%
  ggsave(filename = "graphics/EDA01.png", width = 6, height = 4, units = "in", dpi = 300)
