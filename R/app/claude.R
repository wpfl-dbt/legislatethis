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
    "Please follow this guidance in your response: \n",
    "1. Summarise your findings in up to 5 bullet points. \n",
    "2. Present your findings in unbiased language. \n",
    "3. Do not use loaded terminology. \n",
    "4. Only answer if you can create an accurate summary; otherwise respond with one bullet point the start of your response stating that you're unable to summarise ",
    speakername,
    "'s views on the subject accurately. \n",
    "6. At the bottom of your response, include a references section titled \"<h2>References<h2>\". \n",
    "7. The references section of your response should include a reference for each bullet point. The reference should be a quote from the source material. Do not edit these quotes or provide a date. \n",
    "8. Format your total response using HTML, using <ol> for bullets, and <ol> for references. \n",
    "9. Begin the response with: <h2>",
    speakername,
    "'s views on ",
    user_topic_input,
    " based on debates in the House of Commons over the past 3 years.</h2> \n\n",
    "The text you should process is inside <text></text> XML tags. \n\n",
    "<text> \n",
    speech_blob,
    " \n</text> \n\n",
    "Assistant:"
  )
}

test <- build_claude_prompt("Michelle Donelan", "schools", "hahahahahahahah")
cat(test)
