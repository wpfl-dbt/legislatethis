# Legislate This!

A quick hackathon app to summarise what MPs say about an issue on Hansard.

## Use

Make a `.env` file and set the following variables:

  * `OPENAI_ORG_ID` as the org ID found on the [Open AI Platform Settings](https://platform.openai.com/account/org-settings)
  * `OPENAI_API_KEY` as an API key generated on the [Open AI Platform AI keys page](https://platform.openai.com/account/api-keys)
  * `ANTHROPIC_API_KEY` as an API key generated on [Anthropic's keygen page](https://console.anthropic.com/account/keys)
  
Run the app in one of two ways:

### Windows and locked-down machines

* Look in the `Makefile` and install the required packages listed with `install.packages()`
* Run the app with `shiny::runApp('app', port = 9000')`

### Anyone with `make`

* `make requirements` installs required packages
* `make app` runs the app

Access the running app on [http://127.0.0.1:9000](http://127.0.0.1:9000)

## The approach

We collect MP's statements from [Hansard](https://hansard.parliament.uk) based on [XML scrapes hosted by TheyWorkForYou](https://www.theyworkforyou.com/pwdata/scrapedxml/debates/).

We allow the user to search these statements by theme and MP in a Shiny app, then pass them to Claude 2 to summarise.

## Next steps

This library isn't currently under active development, but if we had more time:

* Add semantic search
  * See `R/app/search.R` for embedding and cosine similarity functions that didn't quite make the cut
* Embed bills and social media data to allow them to be searched and summarised too
  * See `R/embed_and_cache.R` for existing work on this using OpenAI
* Search and calculate an MP's success record on amending bills or forcing a u-turn, by theme
* Allow user to specify a bill, and return all MPs who care about its theme, their voting record, and a summary of their statements
* Use topic modelling to draw out themes a human might not see
* Use graph approaches to connect these ideas together
* Show inconsistencies between MP's statements and amendment behaviour

## Team

* Nicky Agius
* Will Vaughan
* Ibraaheem Bahadur
* Jack Higgins
* Holly Brooks
* Will Langdale
