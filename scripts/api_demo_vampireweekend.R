# spotifyr Spotify api demo
# Noah Giebink
# 2020/5/26


# packages
# devtools::install_github('charlie86/spotifyr')
library(spotifyr)
library(tidyverse)
library(corrplot)

# Spotify API credentials ----
client_id <- read.table('client_id')
client_sec <- read.table('client_secret')
Sys.setenv(SPOTIFY_CLIENT_ID = client_id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = client_sec)
token <- get_spotify_access_token()

# get an artist's discography: Vampire Weekend
vw <- spotifyr::get_artist_audio_features('Vampire Weekend')

# what are Vampire Weekend's albums?
unique(vw$album_name)

# what kind of other things can we explore?
glimpse(vw)


# let's compare vw's albums

# let's compare only using sonic qualities

vw_music <- vw %>% select(album_name, danceability, energy, loudness, 
              speechiness, acousticness, instrumentalness,
              liveness, valence)

#' can we eliminate any correlated variables?
#' Dimensionality reduction is an important first step in data mining
#' to improve and simplify models.
#' We'll cluster albums 
vw_num <- vw_music %>% select_if(is.numeric)
vw_cor <- cor(vw_num)
corrplot(vw_cor)

#' loudness is highly correlated with energy and behaves almost
#' exactly the same way with other variables. Redundant!


# eliminate loudness
vw_music <- vw_music %>% select(album_name, danceability, energy, 
                          speechiness, acousticness, instrumentalness,
                          liveness, valence)

# visualize each of these variables across albums

music_cols <- vw_music %>% select(-album_name)
music_cols <- colnames(music_cols)

vw_long <- vw_music %>% pivot_longer(cols = music_cols,
  names_to = 'variable', values_to = 'level')

ggplot(vw_long, aes(album_name, level))+
  geom_boxplot(aes(fill = album_name))+
  facet_wrap(~variable)+
  theme(axis.text.x = element_text(angle = 90))


