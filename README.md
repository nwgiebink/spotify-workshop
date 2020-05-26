# spotify-workshop

**ResBaz 2020 workshop**

## Post-workshop Notes
'session_api_demo.R' and 'session_decision_trees.R' contain live-coded content from the workshop. 


## Original workshop description

Using data from Spotify, we'll encounter a data mining challenge and solve it using tricks from our machine learning toolkit. 

We'll learn about the [Spotify API](https://developer.spotify.com/documentation/web-api/) and its R wrapper, [spotifyr](https://www.rcharlie.com/spotifyr/), and explore data which are great for teaching, learning, and fun!

Topics: API, data preparation, model interpretability, feature engineering, clustering, dimensionality reduction, multiclass classification, supervised learning

### Getting Started
1. This workshop expects some working knowledge of R, RStudio, and basic machine learning intuition (previous sessions on ML in R are sufficient)
2. Installations:
    * To follow this workshop you'll need [R](https://cran.r-project.org/mirrors.html) and [Rstudio](https://rstudio.com/products/rstudio/download/) installed on your computer.
    * Open RStudio and install the tidyverse libraries by typing `install.packages("tidyverse")` in the console.
    * Install spotifyr:
        * `install.packages("devtools")`
        * `devtools::install_github('charlie86/spotifyr')`
        * Note: it might not be necessary to install spotifyr from source (alternative: `install.packages(spotifyr)`, but this is what worked best for me.
    * Other packages:
        * caret (train/test split for modeling)
        * rpart (decision trees)
        * DMwR2 (decision trees)
        * rpart.plot (plotting decision trees)
        * randomForest 
        * corrplot (find correlated variables in preprocessing)
        * lubridate (dealing with dates/time; not required but handy)
3. Follow along and/or reproduce this lesson using [the Github repo](https://github.com/nwgiebink/spotify-workshop)
    * Warning: api will NOT work unless you create a Spotify Developer account and obtain a `client_id` and `client_secret` (available in your account dashboard)
4. We'll read in the data from [this link](https://raw.githubusercontent.com/nwgiebink/spotify-workshop/master/markdowns/spot_clean.csv) 




### Resources

1. Check back on [this repo](https://github.com/nwgiebink/spotify-workshop) for more updates and improvements! :)
2. This lesson was partly inspired by [this awesome spotifyr tutorial](https://msmith7161.github.io/what-is-speechiness/). I Highly recommend it for practice acquiring your own data with the Spotify API.
3. [Spotify Charts](https://spotifycharts.com/regional) is another awesome source for Spotify data that is much easier to use and allows you to specify both location and date for popular tracks (e.g top 200 in UK on 06/03/2017)
4. [General spotify developer site](https://developer.spotify.com/)
5. [Gapminder](https://www.gapminder.org/data/) is a fantastic, reputable source for global sociopolitical data.