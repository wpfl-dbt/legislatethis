library(openai)
library(here)
library(proxyC)
library(readr)

readRenviron(here::here('.env'))

# Embed the df

embedding_matrix <- function(text_vec, rate_limit = F) {
  if (rate_limit) {
    chunks <- split(text_vec, ceiling(seq_along(text_vec)/100000))
    embedded_list <- list()
    
    for (i in 1:length(chunks)) {
      embedding <- create_embedding(
        model = 'text-embedding-ada-002',
        input = chunks[[i]],
        openai_api_key = Sys.getenv("OPENAI_API_KEY"),
        openai_organization = Sys.getenv("OPENAI_ORG_ID")
      )
      
      mat <- do.call(rbind, embedding$data$embedding) |> 
        as.matrix()
      
      rownames(mat) <- chunks[[i]] 
      
      embedded_list[[i]] <- mat
      
      Sys.sleep(70)
    }
    
    res <- do.call(rbind, embedded_list)
    
  } else {
    embedding <- create_embedding(
      model = 'text-embedding-ada-002',
      input = text_vec,
      openai_api_key = Sys.getenv("OPENAI_API_KEY"),
      openai_organization = Sys.getenv("OPENAI_ORG_ID")
    )
    
    res <- do.call(rbind, embedding$data$embedding) |> 
      as.matrix()
    
    rownames(res) <- text_vec  
  }
  
  return(res)
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

# Scratch
# 
# text_vec <- c('x', 'y', 'x')
# 
# text_vec[1:100]
# 
# embedded_list <- list()
# 
# chunks <- split(text_vec, ceiling(seq_along(text_vec)/2))
# chunks[[1]]
# 
# embedding <- create_embedding(
#   model = 'text-embedding-ada-002',
#   input = chunks[[1]],
#   openai_api_key = Sys.getenv("OPENAI_API_KEY"),
#   openai_organization = Sys.getenv("OPENAI_ORG_ID")
# )
# 
# mat <- do.call(rbind, embedding$data$embedding) |> 
#   as.matrix()
# 
# rownames(mat) <- text_vec 
# 
# for (i in 1:length(chunks)) {
#   embedding <- create_embedding(
#     model = 'text-embedding-ada-002',
#     input = chunks[[i]],
#     openai_api_key = Sys.getenv("OPENAI_API_KEY"),
#     openai_organization = Sys.getenv("OPENAI_ORG_ID")
#   )
#   
#   mat <- do.call(rbind, embedding$data$embedding) |> 
#     as.matrix()
#   
#   rownames(mat) <- chunks[[i]] 
#   
#   embedded_list[[i]] <- mat
# }
# 
# str(embedded_list[[1]])
# 
# res <- do.call(rbind, embedded_list)
# 
# str(res)
