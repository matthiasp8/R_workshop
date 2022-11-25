
##############################
# PART II
##############################

# 1)
DNAse_new <- DNase %>% 
  melt(measure.var=c("conc","density")) %>% 
  group_by(Run,variable) %>%  
  summarise(value=value, median = median(value), log2 = log2(value))


################################
# PART III
################################

###################
# plot 1
###################

ggplot(iris, aes(x=Petal.Length, y=Petal.Width, color=Species)) +
  geom_point() +
  stat_ellipse() +
  theme_classic()

# hint: https://r-charts.com/ --> correlation

ggsave("part3_task_plot1.pdf", width = 6, height = 4)
browseURL("part3_task_plot1.pdf")

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

#new: if saving is needed
htmlwidgets::saveWidget(ggplotly(p), "part3_task_plot2.html")
browseURL("part3_task_plot2.html")

######################
# plot 3 - combine 1 and 2
#####################

p <- iris %>%
  ggplot( aes(x=Petal.Length, y=Petal.Width, size = Sepal.Width, color=Species)) +
  geom_point() + 
  stat_ellipse() +
  theme_bw()

ggplotly(p)

#new: if saving is needed
htmlwidgets::saveWidget(ggplotly(p), "part3_task_plot3.html")
browseURL("part3_task_plot3.html")

###########################
# plot 4
###########################

# library
library(ggridges)
library(ggplot2)

#bring into long format
french_fries_long <- melt(french_fries, id.vars = c("time", "treatment", "subject", "rep"))

str(french_fries_long)
french_fries_long <- french_fries_long %>% mutate(variable = factor(variable, levels=sort(levels(french_fries_long$variable)))) 

french_fries_long %>%
  ggplot(aes(x = value, y = variable, fill = variable)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none", axis.title.x = element_text(hjust= 0.5)) +
  ylab("") 


#hints: https://r-graph-gallery.com/

ggsave("part3_task_plot4.pdf", width = 6, height = 4)
browseURL("part3_task_plot4.pdf")


####################
# plot 5 
##################

# plot
DNase %>% 
  melt() %>% 
  ggplot(aes(x=variable, y=value, fill=variable)) +
  geom_boxplot(alpha=0.7) +
  stat_summary(fun=mean, geom="point", shape=20, size=14, color="red", fill="red") +
  theme(legend.position="none") +
  scale_fill_brewer(palette="Set1") 
  
ggsave("part3_task_plot5.pdf", width = 6, height = 4)
browseURL("part3_task_plot5.pdf")

