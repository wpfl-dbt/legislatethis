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
  
  # Inputs ####
  
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
  
  # Reactive outputs ####
  
  rv <- reactiveValues(
    hansard_filtered = hansard_df,
    prompt = '',
    response = ''
  )

  observeEvent(input$search_and_summarise, ignoreInit = TRUE, {
    rv$hansard_filtered <- hansard_df |>
      filter(speakername == input$mp_selecter) |>
      # Semantic search will go here
      filter(
        str_detect(
          paragraph_text,
          regex(input$search, ignore_case = T),
          negate = FALSE
        )
      )
    
    # cat(file=stderr(), paste0(nrow(rv$hansard_filtered)))
    
    # output$hansard <- renderTable({
    #   rv$hansard_filtered
    # })
    
  })

  observeEvent(rv$hansard_filtered, ignoreInit = TRUE, {
    rv$prompt <- build_claude_prompt(
      speakername = input$mp_selecter,
      user_topic_input = input$search,
      speeches = isolate(rv$hansard_filtered$paragraph_text)
    )
    
    cat(file=stderr(), paste0(rv$prompt))
    
    # output$prompt <- renderText({
    #   rv$prompt
    # })
    
  })
  
  observeEvent(rv$prompt, ignoreInit = TRUE, {
    rv$response <- create_completion_anthropic(
      prompt = rv$prompt,
      history = NULL,
      model = "claude-2"
    )
    
    cat(file=stderr(), paste0(rv$response))
    
    output$response <- renderUI({
      HTML(rv$response)
    })
    
  })
  
  ## Debug ####
  
  # output$debug_text <- renderText({
  #   colnames(bills_df)
  # })
  # output$debug_table <- renderTable({
  #   bills_df
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
