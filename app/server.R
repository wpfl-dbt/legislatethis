library(here)
library(shiny)
library(shinyGovstyle)
library(openai)
library(purrr)
library(readr)
library(dplyr)
library(lubridate)

readRenviron(here::here('.env'))

purrr::walk(
  dir(
    here::here('R', 'app'),
    full.names = TRUE
  ),
  source
)

################################################################################
# DATA                                                                         #
################################################################################

# Cache to store responses
cache <- list() 

# API key and model to use
api_key <- "YOUR_API_KEY" 
model <- "text-davinci-003"

bills_df <- read_rds(here::here('data', 'bills.Rds')) |> 
  select(where(~ !is.list(.x))) |> 
  mutate(
    lastUpdate = lubridate::date(lubridate::ymd_hms(lastUpdate))
  )

################################################################################
# SERVER                                                                       #
################################################################################

create_chat_completion(
  model = "gpt-3.5-turbo",
  messages = list(
    list(
      "role" = "system",
      "content" = "You are a helpful assistant."
    ),
    list(
      "role" = "user",
      "content" = "Who won the world series in 2020?"
    ),
    list(
      "role" = "assistant",
      "content" = "The Los Angeles Dodgers won the World Series in 2020."
    ),
    list(
      "role" = "user",
      "content" = "Where was it played?"
    )
  ),
  openai_api_key = Sys.getenv("OPENAI_API_KEY"),
  openai_organization = Sys.getenv("OPENAI_ORG_ID")
)

shinyServer(function(input, output, session) {
  
  # Data ####
  
  # Query
  
  query_cache <- eventReactive(input$call_trains, {
    
    x
    
  })
  
  # Bills display
  
  # Inputs ####
  
  # Rendered from the server to reduce database calls and speed up
  
  output$sorter_ui <- renderUI({
    shinyGovstyle::select_Input(
      inputId = "sorter", 
      label = "Sort by",
      select_text = colnames(bills_df),
      select_value = colnames(bills_df)
    )
  })
  
  output$col_selecter_ui <- renderUI({
    selectizeInput(
      inputId = 'selecter',
      label = 'Choose columns to display',
      choices = colnames(bills_df),
      selected = c(
        'shortTitle',
        'currentHouse',
        'member.name',
        'member.party',
        'lastUpdate'
      ),
      multiple = TRUE
    )
  })
  
  # Outputs ####
  
  #
  
  ## Debug ####
  
  output$debug_text <- renderText({
    colnames(bills_df)
  })
  # output$debug_table <- renderTable({
  #   bills_df
  # })
  
  ## Plots ####
  
  #
  
  ## Tables ####
  
  output$bills <- renderTable({
    bills_df |> 
      select(input$selecter) |> 
      arrange(input$sorter, descending = TRUE)
  })
  
})
