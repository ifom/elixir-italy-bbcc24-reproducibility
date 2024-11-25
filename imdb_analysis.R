# libraries needed
library(readr)
library(dplyr)
library(ggplot2)

# READING FILES
# please change reading path accordingly

# read the main title table (reduced and cleaned)
title_basics <- read_csv("data/small_title_basics.csv")
# read the ratings table
title_ratings <- read_tsv("data/title.ratings.tsv")
# read the principals table (containing data about actors, reduced and cleaned version)
title_principals <- read_csv("data/small_title_principals.csv")

# let's have a look at the data tables
head(title_basics)
head(title_ratings)
head(title_principals)

# PROCESSING OBJECTS

# add ratings to title_basics (join the tables)
title_basics_ratings <- left_join(title_basics, title_ratings, by = "tconst")
head(title_basics_ratings)

# keep only shorter movies with at least 10 votes
df_movies <- filter(title_basics_ratings, runtimeMinutes < 180, numVotes >= 10)
dim(df_movies)
head(df_movies)

# PLOTTING FILES

# Let's see the ratings vs number of votes distribution
ggplot(df_movies, aes(x = numVotes, y = averageRating)) +
  geom_point()

# it's better to look at it with a heatmap on log10 scale
ggplot(df_movies, aes(x = numVotes, y = averageRating)) +
  geom_bin2d() +
  scale_x_log10() +
  scale_y_continuous(breaks = 1:10) +
  scale_fill_viridis_c()

# what about the rating as a function of lenght of the movie?
ggplot(df_movies, aes(x = runtimeMinutes, y = averageRating)) +
  geom_bin2d() +
  scale_x_continuous(breaks = seq(0, 180, 60), labels = 0:3) +
  scale_y_continuous(breaks = 0:10) +
  scale_fill_viridis_c(option = "inferno") +
  theme_minimal() +
  labs(title = "Relationship between Movie Runtime and Average Movie Rating",
       subtitle = "Data from IMDb",
       x = "Runtime (Hours)",
       y = "Average User Rating",
       fill = "# Movies")
