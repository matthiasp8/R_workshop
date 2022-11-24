###################
# plot 1
###################

ggplot(iris, aes(x=Petal.Length, y=Petal.Width, color=Species)) +
  geom_point() +
  stat_ellipse() +
  theme_classic()

# hint: https://r-charts.com/ --> correlation


########################
# plot 2
######################

library(ggplot2)
library(plotly)
library(gapminder)

p <- iris %>%
  ggplot( aes(x=Petal.Length, y=Petal.Width, size = Sepal.Width, color=Species)) +
  geom_point() +
  theme_bw()

ggplotly(p)

#hints: https://r-graph-gallery.com/ --> general knowledge --> interactive charts


######################
# plot 3 - combine 1 and 2
#####################

p <- iris %>%
  ggplot( aes(x=Petal.Length, y=Petal.Width, size = Sepal.Width, color=Species)) +
  geom_point() + 
  stat_ellipse() +
  theme_bw()

ggplotly(p)


###########################
# plot 3
###########################

# library
library(ggridges)
library(ggplot2)

#head(diamonds)

# basic example
french_fries_long <- melt(french_fries, id.vars = c("time", "treatment", "subject", "rep"))
french_fries_long %>% ggplot(aes(x = value, y = variable, fill = variable)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")

#hints: https://r-graph-gallery.com/