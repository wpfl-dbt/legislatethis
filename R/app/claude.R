library(here)
library(gptstudio)

readRenviron(here::here('.env'))

model <- "claude-1"

create_completion_anthropic(
  prompt = "Hello Claude!",
  history = NULL,
  model = model
)
