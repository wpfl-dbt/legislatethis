library(here)
library(gptstudio)

readRenviron(here::here('.env'))

model <- "claude-1"

create_completion_anthropic(
  prompt = "Hello Claude!",
  history = NULL,
  model = model
)

build_claude_prompt <- function(speeches, ) {
  paste(speeches, collapse = " ")
  prompt <- paste0(
    "What are ", 
    speakername, 
    "'s thoughts on ", 
    user_topic_input, 
    " below? Please summarise the findings in this format; 5 bullet points, each bullet point to be referenced, the findings to be provided in unbiased language, do not use loaded terminology. Begin the response with \'Here are ",
    speakername, 
    "'s views on ", 
    user_topic_input, 
    " based on debates in the House of Commons over the past 3 years.\'"
  )
}