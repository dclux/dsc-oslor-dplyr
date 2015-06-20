# Introduction to Split-Apply using base and dplyr
#
# Calculate the median values for a few parameters for cars with different numbers of cylinders.
#
# mtcars is a data frame with 32 observations on 11 variables.
# 
# [, 1]	mpg	Miles/(US) gallon
# [, 2]	cyl	Number of cylinders
# [, 3]	disp	Displacement (cu.in.)
# [, 4]	hp	Gross horsepower
# [, 5]	drat	Rear axle ratio
# [, 6]	wt	Weight (lb/1000)
# [, 7]	qsec	1/4 mile time
# [, 8]	vs	V/S
# [, 9]	am	Transmission (0 = automatic, 1 = manual)
# [,10]	gear	Number of forward gears
# [,11]	carb	Number of carburetors

library(dplyr)

# Data preparation
data(mtcars)
data = mtcars
data$cyl = factor(data$cyl)

# Global configuration
column.names = c("mpg", "hp", "wt")

# Filter-Split-Apply using base
# Select only required columns
data.base = data[ , colnames(data) %in% column.names]

# Split the data on the number of cylinders
data.base.split = split(data.base, data$cyl)

# Apply function of interest to all columns in our dataset
data.base.results = sapply(data.base.split, function(x) apply(x, 2, median))
(data.base.results = t(data.base.results))

# Filter-Split-Apply using dplyr
data %>% group_by(cyl) %>% select(one_of(column.names)) %>% summarise_each(funs(median))