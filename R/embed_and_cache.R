library(openai)
library(here)
library(dplyr)
library(tidyr)
library(purrr)
library(readr)

readRenviron(here::here('.env'))

purrr::walk(
  dir(
    here::here('R', 'app'),
    full.names = TRUE
  ),
  source
)

# Dummy data for now

generate_speech <- function() {
  paste(sample(
    c(
      "Mister Speaker,",
      "Thank you,",
      "In my view,",
      "The opposition claims,"
    ),
    1
  ),
  sample(
    c(
      "this policy will help our economy.",
      "the minister is misleading the public.",
      "we must protect the environment.",
      "more funding is required for education."
    ),
    1
  ))
}
# Create 10 MPs
mps <- paste0("MP_", 1:10)
# Generate 5 speeches per MP
speeches <- lapply(mps, function(mp) {
  replicate(5, generate_speech())
})
# Flatten speeches
speeches <- unlist(speeches)
# Create sequence of dates
dates <- lapply(mps, function(mp) {
  seq(as.Date('2020-01-01'),
      by = "week",
      length.out = 5)
}) %>% unlist()
# Create dataframe
speeches_df <- data.frame(
  mp = rep(mps, each = 5),
  speech = speeches,
  date = dates,
  stringsAsFactors = FALSE
) |> 
  as_tibble()

# Usage

speeches_df <- speeches_df |> 
  as_tibble() |> 
  mutate(
    embeddings = embedding_matrix(speech)
  )

# Real data!

speeches_df <- read_rds(here::here('data', 'hansard_data.Rds'))

speeches_embed <- speeches_df |> 
  as_tibble() |> 
  mutate(
    embeddings = embedding_matrix(paragraph_text, rate_limit = T)
  ) |> 
  select(
    speakername,
    paragraph_text,
    embeddings
  )

saveRDS(speeches_embed, file = here::here('data', 'speech_embeddings.Rds'))
