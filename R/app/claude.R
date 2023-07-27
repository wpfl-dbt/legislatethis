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
    "Please follow this guidance in your response: \n1. Summarise your findings in 5 bullet points. \nReference each bullet point to the source data and include your references at the bottom of your response. \n3.Present your findings in unbiased language. \n4. Do not use loaded terminology. \n5 Only answer if you know the answer or you can make a well-informed guess; otherwise tell me you don't know it. \n6. Begin the response with \"",
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
