library(purrr)
library(here)
library(shiny)
library(shinyGovstyle)

purrr::walk(
  dir(
    here::here('R'),
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
    'Legislate this', 
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
            br()
          )
        )
      )
    )
  ),
  shinyGovstyle::footer(TRUE)
)
