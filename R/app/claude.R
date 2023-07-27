library(here)
library(gptstudio)

readRenviron(here::here('.env'))

build_claude_prompt <- function(speakername, user_topic_input, speeches) {
  speech_blob <- paste(speeches, collapse = "\n ")
  prompt <- paste0(
    "These are the speeches from ", 
    speakername, 
    ": \n\n'", 
    speech_blob,
    "\n\n",
    "What are ", 
    speakername, 
    "'s thoughts on ", 
    user_topic_input, 
    "? \n\n Please summarise the findings in this format; \n ",
    "5 bullet points, \n ",
    "each bullet point to be referenced, \n ",
    "the findings to be provided in unbiased language, \n ",
    "do not use loaded terminology. \n\n ",
    "Begin the response with \'Here are ",
    speakername, 
    "'s views on ", 
    user_topic_input, 
    " based on debates in the House of Commons over the past 3 years.\'"
  )
}

# res <- build_claude_prompt(
#   speakername = 'Will', 
#   user_topic_input = 'clowns', 
#   speeches = c('I like clowns', 'More clowns please', 'My constituents <3 clowns too')
# )
# 
# res

# create_completion_anthropic(
#   prompt = "Hello Claude!",
#   history = NULL,
#   model = "claude-1"
# )
