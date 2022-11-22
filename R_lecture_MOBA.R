# learn some R basics
# mpr09


library("reshape2")
library("tidyverse")
library("textshape")

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
read.csv ...

# data sets implemented in R
data()
head(iris)
str(iris)

###
# Task?
##


##########################
# convert data structures
##########################

#convert matrix into long format (needed for ggplot2)
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
#how to use pipes
##################

tab_long   %>% 
  dcast(Var2 ~ Var1)  %>%  
  column_to_rownames() %>% 
  as.matrix() %>% 
  colSums()

# |>



# introduction to ggplot2 - I need to adopt this

library(ggplot2)
ggplot(iris, aes(x=Sepal.Length, y= Sepal.Width, color=Species)) + geom_point()

#webpage with graphics
#example plot



#################
#task: make this plot:
iris_long <- melt(iris)
ggplot(iris_long, aes(x=Species, y= value, color=variable)) + geom_jitter() + theme_classic()

#if there is time: left: (t,l,s)apply


# basic R cheatsheet:
#https://raw.githubusercontent.com/rstudio/cheatsheets/main/base-r.pdf

#more cheatsheets
#https://www.rstudio.com/resources/cheatsheets/


#extra lecture: stats in R - (t,l,s)apply, linear regression, define functions etc.
