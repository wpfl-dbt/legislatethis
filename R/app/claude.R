library(here)
library(gptstudio)

readRenviron(here::here('.env'))

build_claude_prompt <- function(speakername, user_topic_input, speeches) {
  speech_blob <- paste(speeches, collapse = "\n ")
  prompt <- paste0(
    "Human: We want you to summarise ", 
    speakername, 
    "'s thoughts on ",
    user_topic_input,
    ".\n\n",
    "Please summarise your findings in 5 bullet points, referencing each bullet point to the source data, presenting your findings in unbiased language, and do not use loaded terminology. Begin the response with \"",
    speakername,
    "'s views on ",
    user_topic_input,
    " based on debates in the House of Commons over the past 3 years.\" \n\n",
    "Here is the text you should process: \n",
    speech_blob,
    ".\n\n",
    "Assistant:"
  )
}
