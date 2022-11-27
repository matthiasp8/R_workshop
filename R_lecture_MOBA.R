# https://github.com/matthiasp8/R_lecture/
# R workshop: basics - data preparation - ggplot2
# mpr09

library("tidyverse")


#######################################
# PART I - R basics
#######################################

#####################
# basic calculations
#####################

x <- 1 + 2
x

##########
# vectors
##########

x <- c(1, 1, 2.5, 3.4)
x
y <- c("a", "b", "c")
y

# functions (round brackets)
log2(x)
mean(x)
median(x)
summary(x)

# get help
?mean

# vector classes
class(x)
class(y)

# change class
as.numeric(x)
as.integer(x)
as.character(x)
as.factor(x)

# subset data - square brackets
#e.g. second entry of the vector  y:
y[2]

##########
# matrices
##########

random_numbers <- rnorm(15) #normal distribution with mean = 0
random_numbers
m <- matrix(random_numbers, ncol = 3)
m
colnames(m)
colnames(m) <- y
m
rownames(m) <- LETTERS[1:5]
m


# matrix subsetting
# second column
m[, 1]
#third row
m[3, ]
# number in third row and first column
m[3, 1]

# functions for matrices
t(m)
rowSums(m)
colSums(m)
colMeans(m)

# different functions take different classes

# apply function
apply(m, 2, mean)
colMeans(m)
#apply can be also used for more fancy calculations - another lesson


#############
# data.frame - table with mixed classes
##############
df <- data.frame(m, characters = letters[1:5], factor = as.factor(c("A", "A", "B", "C", "C")))
df
str(df)
head(df)
tail(df)

#subset a data frame
df$b
df[, 2]

################
# lists
###############

# list of matrices
matrix_list <- list(m, m)
names(matrix_list) <- c("matrix", "same_matrix")
matrix_list

mixed_list <- list(m, m, df)
names(mixed_list) <- c("matrix", "same_matrix", "data_frame")
mixed_list

# list subsetting
mixed_list[[1]][2, 1]

##############
# load data
###############

# in general: read files
phenotypes <- read.csv2("/data/orga/MOBAcourses/220919_ggplot2_introduction/phenotypes.csv", row.names=1)
#norm_reads <- read.csv2("/data/datasets/rna_seq/2203__4__rna_seq__PAO1_pleD__LBpl__Sarina/edgeR/PAO1_pleD/edgeR_normalized_reads.csv", row.names = 1)

# data sets implemented in R
data()
head(iris)
str(iris)

###################
# Tasks - by Dmytro
##################




###############################################
# PART II - data preparation - 16:00
###############################################


##########################
# convert data structures
##########################

library("reshape2")

# melt - convert data into long format
head(french_fries)
french_fries_long <- melt(french_fries, measure.vars = c("potato", "buttery", "grassy", "rancid", "painty"))
melt(french_fries, id.vars = c("time", "treatment", "subject", "rep"))

# convert matrix into long format
tab_long <- melt(m)
tab_long
class(tab_long)
#str(tab_long)

#and back to matrix again
tab_wide <- dcast(tab_long, Var1 ~ Var2)
#dcast(tab_long, Var2 ~ Var1)

head(tab_wide)

#use first column as rownames
column_to_rownames(tab_wide, var = "Var1")


#another approach (than dcast) in standard R library
#x<-reshape(tab_long, idvar = "Var1", timevar = "Var2", direction = "wide")
#x

##################
#how to use pipes (pipes make sense if different functions are applied to one data object) 
##################

#without pipe
tab_wide <- dcast(tab_long, Var1 ~ Var2)
tab_wide2 <- column_to_rownames(tab_wide, var = "Var1")
colSums(tab_wide2)

#or 
colSums(column_to_rownames(dcast(tab_long, Var1 ~ Var2), var = "Var1"))

#pipe
tab_long %>% 
  dcast(Var1 ~ Var2) %>% 
  column_to_rownames(var = "Var1") %>% 
  colSums()


# base R pipe: |>

################
# summarize data
################

iris_long <- melt(iris)
head(iris_long)

# summarize iris_long data frame
iris_long %>%
  summarise(mean = mean(value), maximum = max(value))

##statistics by Species
iris_long %>%
  group_by(Species) %>%
  summarise(mean = mean(value), maximum = max(value))

##statistics by Species and variable
iris_long %>%
  group_by(Species, variable) %>%
  summarise(mean = mean(value), maximum = max(value))

# add statistics etc. to the full table
iris_long %>% 
  group_by(Species, variable) %>% 
  mutate(mean = mean(value))


#########################
# some more useful functions to prepare data for ggplot2
##########################

# convert several columns as factors - e.g. if there are "numeric data" that are actually not numeric
phenotypes <- phenotypes %>% mutate_at(vars(Colony.size.1_4, Margin.0_1_2), as.factor)

str(phenotypes)

# reorder factors
iris %>% 
    ggplot(aes(x = Species, y = Petal.Width, color = Petal.Length, size  = Sepal.Length)) + 
    geom_point()

str(iris)
iris_reordered <- iris %>% 
    mutate(Species = factor(Species, levels=c("virginica", "versicolor","setosa"))) 

str(iris_reordered)

iris_reordered %>% 
    ggplot(aes(x = Species, y = Petal.Width, color = Petal.Length, size = Sepal.Length)) + 
    geom_point()

##################
# Tasks
#################

# 1)
# Transform the table DNase into a long format using "conc" and "density" as "measure.var".
# add new columns with the median and log2 for "Run" and "variable"
# call the new object DNAse_new


##############################################
# PART III - ggplot2 - 16:30
##############################################

###########
# reminder - make a plot object, add aestetics and save the object as p (see ggplot_introduction.R)
#############

p <- iris %>% ggplot(aes(x = Species, y = Petal.Width, color = Petal.Length, size = Sepal.Length))

# add geom and plot p
p + geom_point() 


##########
#  add more layers
#################

p + geom_violin() + geom_jitter(width = 0.2, size = 4, alpha = 0.6) 


#######
# change theme
########
p + geom_violin() + geom_jitter(width = 0.2, size = 4, alpha = 0.6) + theme_bw()

######
# save plot
######

ggsave(filename = "test.pdf", width = 10, height = 6)
browseURL("test.pdf")


########################
#make individual plots
#######################
# google
# https://r-graph-gallery.com/
# https://r-charts.com/
# https://www.rstudio.com/resources/cheatsheets/
# https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-visualization.pdf

# example from https://r-charts.com/

library(ggplot2)


ggplot(iris_long, aes(x = Species, y = value, color = Species)) +
  geom_violin(trim = FALSE) +
  geom_boxplot(width = 0.07) + 
  theme_classic()


###########################################
# Tasks
##########################################

#make plots using "https://r-graph-gallery.com/" and "https://r-charts.com/"

# plot 1
#https://r-charts.com/
# "iris" dataset

# plot 2
#https://r-graph-gallery.com/
# "iris" dataset

# plot 3
#iris dataset

# plot 4
# https://r-graph-gallery.com/
# french_fries dataset

#plot 5
#https://r-graph-gallery.com/
# "DNAse" dataset



########################################
# some plot functions outside of ggplot2
#####################################

# Standard R plot function
plot(x = iris$Sepal.Length, y = iris$Sepal.Width)

# heatmaps
library(pheatmap)
pheatmap(m)


#######################################
# topics for future: stats in R, (t,l,s)apply, linear regression, define functions etc. --> other preferences?

