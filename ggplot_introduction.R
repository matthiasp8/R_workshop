# Aim: Basic introduction to ggplot2
# mpr09

library(tidyverse)
library(ggpubr)

################
# Basic R
###############

# basic calculations
x <- 1 + 2
x

# vectors
1:3
c(1,2,3)
x <- c(1,2,3)
x

# functions
# calculate the sum of 1, 2, and 3.

#1st variant
sum(x)

#2nd variant
x %>% sum(.)

# basic R cheatsheet:
#https://raw.githubusercontent.com/rstudio/cheatsheets/main/base-r.pdf

#more cheatsheets
#https://www.rstudio.com/resources/cheatsheets/

#################
# ggplot2
################

##########
#load data (by clicking: Environment -> Import dataset) - copy command
###########

phenotypes <- read.csv2("phenotypes.csv", row.names=1)


##########
# 1) make a ggplot object
#########

#1st variant
ggplot(data= phenotypes)

#2nd variant
phenotypes %>% 
  ggplot()


##########
# 2) add aestetics
#########

str(phenotypes)

phenotypes %>% 
  ggplot(aes(x=Background, y=Survival.24, color= Background))

###########
# add geom
#########

phenotypes %>% 
  ggplot(aes(x=Background, y=Survival.24, color= Background)) +  #plot object and aestetic
  geom_point(size=3) #geom

#warnings - missing values
phenotypes$Survival.24 %>% is.na() %>% sum()

#remove NAs
phenotypes %>%
  drop_na() %>% 
  ggplot(aes(x=Background, y=Survival.24, color= Background)) +  #plot object and aestetic
  geom_point(size=3) #geom

#####################
# Adopt plots
####################
# save plot object and and aestetic as "p"
p <- phenotypes %>%
  drop_na() %>% 
  ggplot(aes(x=Background, y=Survival.24, color= Background))   #plot object and aestetic
p

#try different geoms
#principle: p is the saved plot object including data and aestetics, everything else can be added using a "+"
p + geom_jitter(width = 0.2, size = 4, alpha = 0.6)
p + geom_boxplot()
p + geom_violin()

# add more layers
p + geom_boxplot() + geom_jitter(width = 0.2, size = 4, alpha = 0.6)
p + geom_violin() + geom_jitter(width = 0.2, size = 4, alpha = 0.6)

#change themes
p + geom_boxplot() + geom_jitter() + theme_classic2()

################
# pitfalls
###############

p <- phenotypes %>% 
  ggplot(aes(x=Margin.0_1_2, y= Survival.24))
p + geom_boxplot()

str(phenotypes)
phenotypes <- phenotypes %>% mutate_at(vars(Margin.0_1_2, Colony.size.1_4), as.factor)
str(phenotypes)

p <- phenotypes %>% drop_na() %>% 
  ggplot(aes(x=Margin.0_1_2, y= Survival.24))
p + geom_boxplot()

############
# add more dimensions
#############

p <- phenotypes %>% drop_na() %>% 
  ggplot(aes(x=Survival.24, y= IL.10, color= IL.6, shape = Margin.0_1_2))

p + geom_point() + facet_grid(Background ~ TOB_c) + theme_bw()

#save the plot
ggsave(filename = "test.pdf", width = 12, height = 6)
browseURL("test.pdf")

########################
#make individual plots
#######################
# e.g.
# https://r-graph-gallery.com/
# https://r-charts.com/
# https://www.rstudio.com/resources/cheatsheets/
# https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-visualization.pdf
