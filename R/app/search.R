library(openai)
library(here)
library(proxyC)
library(readr)

readRenviron(here::here('.env'))

# Embed the df

embedding_matrix <- function(text_vec) {
  embedding <- create_embedding(
    model = 'text-embedding-ada-002',
    input = text_vec,
    openai_api_key = Sys.getenv("OPENAI_API_KEY"),
    openai_organization = Sys.getenv("OPENAI_ORG_ID")
  )
  
  mat <- do.call(rbind, embedding$data$embedding) |> 
    as.matrix()
  
  rownames(mat) <- text_vec 
  
  return(mat)
}

# Search an embedded df cached using the above

search_embeddings <- function(cache, search_term) {
  if (length(search_term) != 1) {
    print('Can only search one term at a time')
    break
  }
  
  embedding = embedding_matrix(search_term)
  rownames(embedding) <- 'sim'
  
  raw_sim <- proxyC::simil(
    cache$embeddings,
    embedding,
    method = 'cosine'
  )
  
  res <- as.matrix(raw_sim) |> 
    as_tibble() |> 
    mutate(speech = rownames(raw_sim)) |> 
    arrange(desc(sim))
  
  return(res)
  
}

# Test

cache <- read_rds(here::here('data', 'speech_embeddings.Rds'))

search_embeddings(cache, search_term = "school")
