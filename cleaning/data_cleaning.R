# Setting-up --------------------------------------------------------------

packages = c("devtools",
             "usethis",
             "readr",
             "here",
             "readxl",
             "tidyverse",
             "tidylog",
             "lubridate",
             "ggplot2",
             "ggplotgui",
             "ggthemes",
             "arsenal")
package.check <- lapply(packages, FUN = function(x){
  if (!require(x, character.only = TRUE)){
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

getwd()
rm(list=ls())

# Import datasets ---------------------------------------------------------

# original data
df <- read_csv(here("input/analysis_data.csv"))

# additional data
addA <- read_csv(here("input/20230118AkiAtopicAsthmaRequest_A.csv"))
addB <- read_csv(here("input/20230118AkiAtopicAsthmaRequest_B.csv"))

# Data merge --------------------------------------------------------------

addA <- addA %>% 
  dplyr::select(cfsubjid, xyenomeas3, xysppfvcc, eyenomeas3, xysppfvcc, lon, lat)

addB <- addB %>% 
  arrange(bfsubjid, rfonsetdate) %>% 
  distinct(bfsubjid) %>% 
  rename(cfsubjid = bfsubjid)

# Export ------------------------------------------------------------------

df <- left_join(df, addA, by = "cfsubjid")
df <- left_join(df, addB, by = "cfsubjid")
df %>% write_csv(here("output/analysis_data_gis.csv"))
