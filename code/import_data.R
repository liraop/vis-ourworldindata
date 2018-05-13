library(tidyverse)
library(here)

options(scipen = 999)

geography = read_csv(here("data/Data Geographies - v1 - by Gapminder - List of countries.csv"))

diets_raw = read_csv(here("data/daily-caloric-supply-derived-from-carbohydrates-protein-and-fat.csv")) %>% 
    rename(country = Entity, 
           code = Code, 
           year = Year)

diets =  diets_raw %>%
    mutate(
        kcal_per_day = `Animal protein (kilocalories per person per day)` + 
            `Plant protein (kilocalories per person per day)` + 
            `Fat (kilocalories per person per day)` + 
            `Carbohydrates (kilocalories per person per day)`,
        `Animal protein share` = `Animal protein (kilocalories per person per day)` /kcal_per_day,
        `Plant share` = `Plant protein (kilocalories per person per day)` / kcal_per_day,
        `Fat share` = `Fat (kilocalories per person per day)` / kcal_per_day,
        `Carbo share` = `Carbohydrates (kilocalories per person per day)` / kcal_per_day
    ) %>%
    filter(year >= 1990) %>% 
    mutate(code = tolower(code)) %>% 
    left_join(geography, by = c("code" = "geo"))


diets %>% 
    write_csv(here("data/diet_components-wide.csv"))

diets_long = diets %>% 
    select(-contains("kilocalories per person")) %>% 
    gather(key = "component", value = "share", contains("share"))

diets_long %>% 
    write_csv(here("data/diet_components-long.csv"))
