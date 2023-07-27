library(here)

# This is based on the theyworkforyou XML from Westminster Hall
# https://www.theyworkforyou.com/pwdata/scrapedxml/westminhall/westminster2023-07-18a.xml
# I asked Claude to knock up an extract function
# We'd need to download these, cache, embed, exactly like with the bills

extract_speech_info <- function(speeches) {
  
  speaker_names <- vector()
  speech_types <- vector() 
  person_ids <- vector()
  contents <- vector()
  
  for(speech in speeches){
    
    speaker_name <- sub('.*speakername="(.*)".*', '\\1', speech)
    speaker_names <- c(speaker_names, speaker_name)
    
    speech_type <- sub('.*type="(.*)".*', '\\1', speech) 
    speech_types <- c(speech_types, speech_type)
    
    person_id <- sub('.*person_id="(.*)".*', '\\1', speech)
    person_ids <- c(person_ids, person_id)
    
    content <- sub('.*>(.*)</speech>', '\\1', speech)
    contents <- c(contents, content)
    
  }
  
  df <- data.frame(speaker_name, speech_type, person_id, content)
  return(df)
  
}

speeches <- c(speech1, speech2, speech3, speech4) 
df <- extract_speech_info(speeches)
