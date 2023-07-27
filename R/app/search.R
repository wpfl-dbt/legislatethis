library(openai)
library(here)

readRenviron(here::here('.env'))

# See semantic search from text search using embeddings section
# https://platform.openai.com/docs/guides/embeddings/use-cases

search_corpus <- function(df, term, n = 20) {
  embedding <- create_embedding(
    model = 'text-embedding-ada-002',
    input = term,
    openai_api_key = Sys.getenv("OPENAI_API_KEY"),
    openai_organization = Sys.getenv("OPENAI_ORG_ID")
  )
  # df['similarities'] = df.ada_embedding.apply(lambda x: cosine_similarity(x, embedding))
  # res = df.sort_values('similarities', ascending=False).head(n)
  # return res
}