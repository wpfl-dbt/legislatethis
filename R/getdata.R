library(httr)

url <- "https://bills-api.parliament.uk/api/v1/Bills"

response <- GET(url)

bills_data <- content(response)

bill_url <- "https://bills-api.parliament.uk/api/v1/Bills/12345678"
response <- GET(bill_url)
single_bill <- content(response)

url <- "https://bills-api.parliament.uk/api/v1/Bills?page=2&pagesize=50"
