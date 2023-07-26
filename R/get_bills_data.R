library(httr)
library(dplyr)
library(tidyr)
library(purrr)
library(jsonlite)
library(here)

# Get all bills and cache

get_detailed_bill_info <- function(bill_id) {
  bill_url <- paste0(
    "https://bills-api.parliament.uk/api/v1/Bills/",
    bill_id
  )
  
  response <- GET(bill_url)
  
  parsed <- response %>%
    httr::content(as = "text", encoding = "UTF-8") |> 
    jsonlite::fromJSON(flatten = TRUE)
  
  extra_info <- parsed$sponsors |> 
    as_tibble() |> 
    select(
      member.memberId,
      member.name,
      member.party
    ) |> 
    bind_cols(
      longTitle = parsed$longTitle
    )
  
  Sys.sleep(.1)
  
  return(extra_info)
  
}

url <- "https://bills-api.parliament.uk/api/v1/Bills"

page <- 1

while(TRUE) {
  
  new_url <- paste0(url, "?page=", page)
  
  response <- GET(url)
  
  parsed <- response %>%
    httr::content(as = "text", encoding = "UTF-8") |> 
    jsonlite::fromJSON(flatten = TRUE)
  
  new_bills <- parsed$items |> 
    as_tibble()
  
  if(nrow(new_bills) == 0) {
    break 
  }
  
  new_bills_enhanced <- new_bills |> 
    mutate(
      extra_info = map(
        billId,
        get_detailed_bill_info
      )
    ) |> 
    unnest(extra_info)
  
  if (page == 1) {
    bills <- new_bills_enhanced
  } else {
    bills <- bills |> 
      bind_rows(new_bills_enhanced)
  }
  
  page <- page + 1
  
  # Added rate limiting
  Sys.sleep(.5) 
  
}

saveRDS(bills, file = here::here('data', 'bills.Rds'))

# Get all bill publication URLs and type, cache

get_bill_publications <- function(bill_id) {
  bill_url <- paste0(
    "https://bills-api.parliament.uk/api/v1/Bills/",
    bill_id,
    "/Publications"
  )
  
  response <- GET(bill_url)
  
  parsed <- response %>%
    httr::content(as = "text", encoding = "UTF-8") |> 
    jsonlite::fromJSON(flatten = TRUE)
  
  publications <- parsed$publications |> 
    as_tibble() |> 
    rename(pub_id = id, pub_title = title) |> 
    unnest(links, names_repair = 'unique') |> 
    rename(doc_id = id, doc_title = title)
  
  Sys.sleep(.1)
  
  return(publications)
  
}

publications <- bills |> 
  select(billId) |> 
  mutate(
    publications = map(
      billId,
      get_bill_publications
    )
  ) |> 
  unnest(publications)

saveRDS(bills, file = here::here('data', 'publications.Rds'))

# Get all bill amendments and the members involved

# TODO: Adapt above to implement the below

# BUT -- does the API have this? Couldn't find a good example bill

# Take list of bills
# Get all amendments
# Get all members on amendments
