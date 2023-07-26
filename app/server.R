library(here)
library(shiny)
library(shinyGovstyle)
library(openai)
library(purrr)

readRenviron(here::here('.env'))

purrr::walk(
  dir(
    here::here('R'),
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
  
  # TRAINS
  
  query_cache <- eventReactive(input$call_trains, {
    
    x
    
  })
  
  # Inputs ####
  
  # Rendered from the server to reduce database calls and speed up
  
  #
  
  # Outputs ####
  
  ## Debug ####
  
  #
  
  ## Plots ####
  
  #
  
  ## Tables ####
  
  #
  
})
