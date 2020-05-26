# data mining challenge
# Noah Giebink
# 2020-5-26

# Packages
library(tidyverse)
library(caret)
library(rpart)
library(rpart.plot)
library(DMwR2)
library(randomForest)

# data
spot <- read.csv(url('https://raw.githubusercontent.com/nwgiebink/spotify-workshop/master/markdowns/spot_clean.csv'))



# compare global music listening tastes
spot_music <- spot %>% select(track.popularity, track.explicit, danceability, 
                              key, loudness, mode, speechiness, acousticness, 
                              instrumentalness, liveness, valence, tempo, country)


# model function: decision_tree
# train/test split & build decision tree

decision_tree = function(labels, df, p = 0.8){
  # splitting the data
  split_index <- createDataPartition(labels, p=p, list = F)
  train <- df[split_index,]
  test <- df[-split_index, !(colnames(df) %in% c("country"))]
  target <- df[-split_index, "country"]
  # build the tree
  tree <- rpartXse(country ~ ., train, se=0.5)
  # plot the tree
  plot <- prp(tree, type = 1, extra = 103, roundint = FALSE)
  # prediction using the trees
  pred <- predict(tree, test, type = "class")
  # confusion matrix 
  cm <- table(pred, target)
  # error rate
  error <- (1-sum(diag(cm))/sum(cm))
  error <- cat("error rate (categorical features): ",error)
  # have a look at the variable.importance
  variable_importance = tree$variable.importance
  output = list(plot, variable_importance, error)
  return(output)
}

decision_tree(spot_music$country, spot_music)
  # result: tree is difficult to interpret...


# Step 1: build a decision tree to classify countries using social variables. 
# Step 2: use most important variable from Stage 1 to cluster countries 
# (the tree in Step 3 performed better with fewer classes this way).
# Step 3: build a decision tree to classify clustered countries by 
# music variables (dimensions of music taste).



# Step 1 ----
spot_socio <- spot %>% select(happiness, median_age,
                                    percent_urban, percent_internet_users, density_sqkm, 
                                    freedom, gdp, country)


# build decision tree using social variables
decision_tree(spot_socio$country, spot_socio)


# Step 2 cluster countries by happiness ----

set.seed(42)
hap <- spot_music_socio %>% group_by(country) %>%
  summarise(happiness = mean(happiness))

# k-means for clustering
# silhouette plots can be used to estimate best number of clusters

h <- kmeans(hap$happiness, 2)
h$cluster


hap_clust <- cbind(hap, h$cluster)
hap_clust <- rename(hap_clust, cluster = 'h$cluster')
arrange(hap_clust, cluster)

happy <- filter(hap_clust, cluster == 2) %>%
  select(country)
unhappy <- filter(hap_clust, cluster == 1) %>%
  select(country)

hap_music <- spot_music %>% mutate(cluster = 
                                     ifelse(country %in% happy$country,
                                            'happy', 'unhappy'))

# remove country
hap_music <- hap_music %>% select(-country)



# step 3 ----

# train/test split

index <- sample(1:nrow(hap_music), 0.8*nrow(hap_music))
train_hap <- hap_music[index,]
test_hap <- hap_music[-index,]

# build tree
set.seed(42)
tree <- rpartXse(cluster ~ ., train_hap, control = list(maxdepth = 3))




tree$variable.importance

prp(tree, type = 1, extra = 103, roundint = F)


pred <- predict(tree, test, type = "class")
# confusion matrix 
cm <- table(pred, target)
# error rate
error <- (1-sum(diag(cm))/sum(cm))
error <- cat("error rate (categorical features): ",error)


#' NOTE: discretizing the social and music variables will 
#' further simplify and improve decision tree interpretability. 
