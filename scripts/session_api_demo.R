# packages

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

# get discography
vw <- spotifyr::get_artist_audio_features('Vampire Weekend')

# what are Vampire Weekend's albums?
unique(vw$album_name)

# get a sense of the data
glimpse(vw)

# select some relevant variables
vw_music <- vw %>% select(album_name, danceability, energy, loudness,
                          speechiness, acousticness, instrumentalness,
                          liveness, valence)


# dimension reduction (find variables we can safely remove)
vw_num <- vw_music %>% select_if(is.numeric)
vw_cor <- cor(vw_num)
corrplot(vw_cor) # shows correlation between each variable


# eliminate loudness: redundant with energy
vw_music <- vw_music %>% select(album_name, danceability, energy,
                                speechiness, acousticness, instrumentalness,
                                liveness, valence)

#' facet ggplot: differences between Vampire Weekend albums
#' across each of Spotify's music variables
music_cols <- vw_music %>% select(-album_name)
music_cols <- colnames(music_cols)

# ggplot's facet_wrap feature is much easier with long data
vw_long <- vw_music %>% pivot_longer(cols = music_cols, names_to = 'variable', 
                                     values_to = 'level')


ggplot(vw_long, aes(x = album_name, level)) +
  geom_boxplot(aes(fill = album_name)) +
  facet_wrap(~variable)


