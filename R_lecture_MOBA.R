# learn some R and ggplot2 basics
# mpr09

library("reshape2")
library("tidyverse")

###############
# first basics
################

# basic calculations
x <- 1 + 2
x

# vectors
x <- c(1,1,2.5,3.4)
x
y <- c("a", "b", "c")
y

#functions - round brackets
log2(x)
mean(x)
median(x)
summary(x)

#get help
?mean

#vector classes
class(x)
class(y)

#change class
as.numeric(x)
as.integer(x)
as.character(x)
as.factor(x)

# subset data - square brackets
#e.g. second entry of the vector  y:
y[2]

# matrices
random_numbers <- rnorm(15) #normal distribution with mean = 0
random_numbers
m <- matrix(random_numbers,ncol=3)
m
colnames(m)
colnames(m) <- y
m
rownames(m) <- LETTERS[1:5]
m

#functions for matrices
rowSums(m)
colSums(m)
colMeans(m)
#functions depend on the class

#apply function
apply(m,2,mean)
colMeans(m)
#apply can be also used for more fancy calculations - another lesson

#matrix subsetting
#second column
m[,2]
#third row
m[3,]
#number in third row and first column
m[3,1]

#data.frame - table with mixed classes
df <- data.frame(m, characters = letters[1:5], factor = as.factor(c("A", "A", "B", "C", "C")))
df
str(df)
head(df)
tail(df)

#list of matrices
matrix_list <- list(m,m)
names(matrix_list) <- c("matrix", "same_matrix")
matrix_list

mixed_list <- list(m,m, df)
names(mixed_list) <- c("matrix", "same_matrix", "data_frame")
mixed_list

#in general: read files
phenotypes <- read.csv2("/data/orga/MOBAcourses/220919_ggplot2_introduction/phenotypes.csv", row.names=1)

# data sets implemented in R
data()
head(iris)
str(iris)

########
# Task
########


##########################
# convert data structures
##########################

# melt - convert data into long format
head(french_fries)
melt(french_fries, id.vars = c("time", "treatment", "subject", "rep"))
melt(french_fries, measure.vars = c("potato", "buttery", "grassy", "rancid", "painty"))

# melt for m
tab_long <- melt(m)
tab_long
class(tab_long)
str(tab_long)

#and back to wide format
dcast(tab_long, Var1 ~ Var2)
dcast(tab_long, Var2 ~ Var1)

tab_wide <- dcast(tab_long, Var2 ~ Var1)
class(tab_wide)
head(tab_wide)
#use first culumn as rownames
tab_wide2 <- column_to_rownames(tab_wide)
head(tab_wide2)

#another approach (in standard R library)
x<-reshape(tab_long, idvar = "Var1", timevar = "Var2", direction = "wide")
x
#reshape(tab_long, idvar = "Var2", timevar = "Var1", direction = "wide")

##########
# Task
###########

##################
#how to use pipes (pipes make sense if different functions are applied to one data object) 
##################

tab_long   %>% 
  dcast(Var2 ~ Var1)  %>%  
  column_to_rownames() %>% 
  as.matrix() %>% 
  colSums()

# |>

################
# summarize data
###############

head(iris_long)

# summarize iris_long data frame
iris_long %>%
  summarise(n = n(), mean = mean(value), maximum = max(value))

##statistics by Species
iris_long %>%
  group_by(Species) %>%
  summarise(n = n(), mean = mean(value), maximum = max(value))

##statistics by Species and variable
iris_long %>%
  group_by(Species, variable) %>%
  summarise(n = n(), mean = mean(value), maximum = max(value))

# add statistics etc. to the full table
iris_long %>% 
  group_by(Species, variable) %>% 
  mutate(mean = mean(value))


# Standard R plot function
plot(x=iris$Sepal.Length, y= iris$Sepal.Width)

###################
# ggplot2
####################

###########
# reminder - make a plot object, add aestetics and save the object as p (see ggplot_introduction.R)
#############

p <- iris %>% ggplot(aes(x=Species, y=Petal.Width, color=Petal.Length, size=Sepal.Length))

# add geom and plot p
p + geom_point()


##########
#  add more layers
#################

p + geom_violin() + geom_jitter(width = 0.2, size = 4, alpha = 0.6)

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

#################
#Tasks: 
#################

# heatmaps
library(pheatmap)
pheatmap(m)

m %>% melt() %>% 
  ggplot(aes(x=Var1 ,y=Var2 , fill=value)) + geom_tile()

#make this plot:
iris_long <- melt(iris)
iris_long %>% ggplot(aes(x=Species, y= value, color=variable)) + geom_jitter() + theme_classic()


iris %>% ggplot(aes(x=Petal.Length, y=Petal.Width)) + geom_tile()

#############
#excursion - statistics using ggpubr
##############
library("ggpubr")

my_comparisons <- list( c("0", "1"), c("1", "2"), c("0", "2") )
phenotypes %>%
  drop_na() %>%
  ggboxplot(x = "Margin.0_1_2", y = "Survival.24", color="Margin.0_1_2",
            palette = "jco")+ 
  stat_compare_means(comparisons = my_comparisons)+ # Add pairwise comparisons p-value
  stat_compare_means(label.y = 150)     # Add global p-value



#if there is time: left: (t,l,s)apply


#topics for future: stats in R - (t,l,s)apply, linear regression, define functions etc.