#'

library(tidyverse)

outcome_colors <- c(coexistence = "dodgerblue3", exclusion = "firebrick")
tb <- tibble(
    community = rep(1:10, each = 2),
    outcome = rep(c("coexistence", "exclusion"), 10),
    fraction = c(.5, .5, .5, .5, .5, .5,
                 .4, .6, 0, 1, .1, .9,
                 .35, .65, .3, .7, .25, .75, .6, .4)
) 
p <- tb %>% 
    ggplot() +
    geom_col(aes(x = community, y = fraction, fill = outcome), width = .8) +
    scale_fill_manual(values = outcome_colors) +
    scale_x_continuous(breaks = 1:10, expand = c(0, .3)) +
    scale_y_continuous(breaks = seq(0, 1, .2), expand = c(0,0)) +
    theme_classic() +
    coord_cartesian(clip = "off") +
    theme(
        legend.title = element_blank(),
        panel.border = element_rect(color = "black", fill = NA)
    ) +
    guides() +
    labs(x = "Community", y = "Fraction")

ggsave(here::here("plots/modeling.png"), p, width = 6, height = 3)
