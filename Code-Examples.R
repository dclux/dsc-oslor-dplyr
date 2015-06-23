# Introduction to Split-Apply using base and dplyr
#
# movies is a data frame in ggplo2 packages with 58788 observations.

library(ggplot2)
library(dplyr)

# Data preparation
data(movies)
data = movies
data$year = factor(data$year)

# Preview the dataset
head(data)

# Global configuration
column.names = c("rating", "votes", "length")

# Filter-Split-Apply using base

    # Select only required columns
    data.base = data[ , colnames(data) %in% column.names]
    
    # Split the data on the number of cylinders
    data.base.split = split(data.base, data$year)
    
    # Apply function of interest to all columns in our dataset
    data.base.results = sapply(data.base.split, function(x) apply(x, 2, mean))
    data.base.results = t(data.base.results)
    head(data.base.results)
    
# Filter-Split-Apply using dplyr
    data %>% group_by(year) %>% select(one_of(column.names)) %>% summarise_each(funs(mean))
    
# create movies data frame
movies_df = tbl_df(movies)

# filter

    #base (and)
    movies_df[movies_df$year == 2005 & movies_df$rating > 9.5, ]

    #dplyr (and)
    filter(movies_df, year == 2005, rating > 9.5)
    
    #base (and + or)
    movies_df[movies_df$year == 2005 & movies_df$rating > 9.5 & (movies_df$Animation == 1 | movies_df$Short == 1), ]
    
    #dplyr (and + or)
    filter(movies_df, year == 2005, rating > 9.5, Animation == 1 | Short == 1)
    
# slice
    
    #base
    movies_df[1:10, ]
    
    #dplyr
    slice(movies_df, 1:10)
    
# arrange
    
    # base (asc)
    movies_df[order(movies_df$votes), ]
    
    # dplyr (asc)
    arrange(movies_df, votes)
    
    # dplyr (desc)
    arrange(movies_df, desc(votes))
    
    # base (asc + desc)
    movies_df[order(movies_df$budget, -movies_df$votes), ]
    
    # dplyr (asc + desc)
    arrange(movies_df, budget, desc(votes))
    
# select
    
    # base
    movies_df[ , colnames(movies_df) %in% c("title","length")]
    movies_df[ , c("title", "length")]
    
    # dplyr
    select(movies_df, title, year)
    
    # dplyr
    select(movies_df, one_of("title", "year"))
    
    # dplyr exclude columns from r1 to mpaa
    select(movies_df, -(r1:mpaa))
    
# mutate and transmute
    
    # base
    yearsSinceDate = 2015 - movies_df$year
    movies.new.base = cbind(yearsSinceDate, movies_df)
    
    # dplyr
    transmute(movies_df, yearsSinceDate = 2015 - year)
    mutate(movies_df, yearsSinceDate = 2015 - year)
    
    # dplyr advanced
    transmute(movies_df, title, yearsSinceDate = 2015 - year, yearsToAnniversary = 100 - yearsSinceDate)
    
# summarise
    
    # dplyr
    transmute(movies_df, yearsSinceDate = 2015 - year) %>% summarise(age.median = median(yearsSinceDate))
    
    # dplyr (budget)
    movies_df %>% summarize(budget.na.percent = sum(is.na(budget)) / length(budget) )
    
    # dplyr summarise_each
    select(movies_df, Action:Short) %>% summarise_each(funs(sum))
