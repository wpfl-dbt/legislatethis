library(here)
library(shiny)
library(shinyGovstyle)
library(openai)
library(purrr)
library(readr)
library(dplyr)
library(lubridate)
library(stringr)
library(gptstudio)

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

bills_df <- read_rds(here::here('data', 'bills.Rds')) |> 
  select(where(~ !is.list(.x))) |> 
  mutate(
    lastUpdate = lubridate::date(lubridate::ymd_hms(lastUpdate))
  )

hansard_df <- read_rds(here::here('data', 'hansard_data.Rds'))
hansard_mps <- hansard_df |> 
  select(speakername) |> 
  unique() |> 
  pull()

################################################################################
# SERVER                                                                       #
################################################################################

hansard_df |> 
  filter(speakername == 'Michelle Donelan') |> 
  # Semantic search will go here
  filter(
    str_detect(
      paragraph_text, 
      regex("friend", ignore_case = T), 
      negate = FALSE
    )
  )

shinyServer(function(input, output, session) {
  
  # Data ####
  
  # Query
  
  get_hansard_and_summarise <- eventReactive(input$search_and_summarise, {
    
    hansard_df |> 
      filter(speakername == input$mp_selecter) |> 
      # Semantic search will go here
      filter(
        str_detect(
          paragraph_text, 
          regex(input$search, ignore_case = T), 
          negate = FALSE
        )
      )
    
  })
  
  # Bills display
  
  # Inputs ####
  
  # Rendered from the server to reduce database calls and speed up
  
  output$search_ui <- renderUI({
    shinyGovstyle::text_Input(
      inputId = "search", 
      label = "Theme"
    )
  })
  
  output$mp_selecter_ui <- renderUI({
    selectizeInput(
      inputId = 'mp_selecter',
      label = 'Choose MP',
      choices = hansard_mps,
      selected = 'Michelle Donelan',
      multiple = F
    )
  })
  
  # output$sorter_ui <- renderUI({
  #   shinyGovstyle::select_Input(
  #     inputId = "sorter", 
  #     label = "Sort by",
  #     select_text = colnames(bills_df),
  #     select_value = colnames(bills_df)
  #   )
  # })
  # 
  # output$col_selecter_ui <- renderUI({
  #   selectizeInput(
  #     inputId = 'selecter',
  #     label = 'Choose columns to display',
  #     choices = colnames(bills_df),
  #     selected = c(
  #       'shortTitle',
  #       'currentHouse',
  #       'member.name',
  #       'member.party',
  #       'lastUpdate'
  #     ),
  #     multiple = TRUE
  #   )
  # })
  
  # Outputs ####
  
  #
  
  ## Debug ####
  
  # output$debug_text <- renderText({
  #   colnames(bills_df)
  # })
  # output$debug_table <- renderTable({
  #   bills_df
  # })
  
  ## Plots ####
  
  #
  
  ## Tables ####
  
  # output$hansard <- renderTable({
  #   get_hansard_data()
  # })
  
})

################################################################################
# SCRATCH (here be dragons)                                                    #
################################################################################

# create_chat_completion(
#   model = "gpt-3.5-turbo",
#   messages = list(
#     list(
#       "role" = "system",
#       "content" = "You are a helpful assistant."
#     ),
#     list(
#       "role" = "user",
#       "content" = "Who won the world series in 2020?"
#     ),
#     list(
#       "role" = "assistant",
#       "content" = "The Los Angeles Dodgers won the World Series in 2020."
#     ),
#     list(
#       "role" = "user",
#       "content" = "Where was it played?"
#     )
#   ),
#   openai_api_key = Sys.getenv("OPENAI_API_KEY"),
#   openai_organization = Sys.getenv("OPENAI_ORG_ID")
# )
