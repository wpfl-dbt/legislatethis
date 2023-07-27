library(purrr)
library(here)
library(shiny)
library(shinyGovstyle)

purrr::walk(
  dir(
    here::here('R', 'app'),
    full.names = TRUE
  ),
  source
)

################################################################################
# UI                                                                           #
################################################################################

fluidPage(
  shinyGovstyle::header(
    'EH',
    'Legislate this!', 
    logo = 'crown'
  ),
  shinyGovstyle::banner(
    'banner',
    'alpha',
    'This is a new service – your <a class="govuk-link" href="https://data.trade.gov.uk/support-and-feedback/">feedback</a> will help us to improve it.'
  ),
  shinyGovstyle::gov_layout(
    size = 'full',
    fluidRow(
      column(
        12,
        tabsetPanel(
          tabPanel(
            title = 'Search',
            br(),
            uiOutput('search_ui'),
            uiOutput('mp_selecter_ui'),
            shinyGovstyle::button_Input(
              inputId = "search_and_summarise", 
              label = "Search and summarise", 
              type = "start"
            ),
            tableOutput(outputId = 'hansard')
          ),
          tabPanel(
            title = 'Debug',
            br(),
            # selectInput(
            #   inputId = 'sorter_id',
            #   label = 'Country (test)',
            #   choices = iso_lookup,
            #   selected = 'GBR'
            # ),
            textOutput(outputId = 'debug_text'),
            tableOutput(outputId = 'debug_table'),
          )
        )
      )
    )
  ),
  shinyGovstyle::footer(TRUE)
)
