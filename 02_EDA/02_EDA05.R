recipes_cleaned %>%
  ggplot(aes(x = servings, fill = high_traffic)) +
  geom_bar() +
  xlab("") +
  ylab("") +
  theme(
    axis.text.x = element_text(angle = 45, vjust = 1, size = 8, hjust = 1)
  )

ggsave(filename = "graphics/EDA05.png", width = 6, height = 4, units = "in", dpi = 300)