# Legislate This!

A quick hackathon app to surface how MPs amend bills by theme.

## Use

Create a `.env` as below to add Open AI credentials.

### Windows and locked-down machines

* Look in the `Makefile` and install the required packages listed with `install.packages()`
* Run the app with `shiny::runApp()`

### Anyone with `make`

* `make requirements` installs packages
* `make app` runs the app

## Idea

* Get documents
  * Bills
  * Hansard statements
* [Embed and cache](https://platform.openai.com/docs/guides/embeddings/use-cases)
* Search them for member and theme

This will enable us to answer:

* What have people said about themes in Hansard?
  * Return the highest-matching docs, ask LLM to summarise
* What happens to that theme in bills? For one theme:
  * What's the bill pass rate, and with how many amendments?
  * Which members amend this theme?
  * What clusters of members amend together?
  * Which members are most associated with a bill passing, or failing?

Stuff to think about:

* Will the summarisation work? Need a spike on prompt tuning -- potentially a standard set of questions? An example output template?
* Will searching a bill document for a member return them? Do it bluntly first. If not, need to attach member info to bills
* Will searching a bill document or Hansard statement for a theme work? Do it bluntly first -- critical this works
* The bill passing stuff needs a basic BI-style database. Should we knock up a quick ERD?

## Development

* Make a `.env` file and set the following variables:
  * OPENAI_ORG_ID as the org ID found on the [Open AI Platform Settings](https://platform.openai.com/account/org-settings)
  * OPENAI_API_KEY as an API key generated on the [Open AI Platform AI keys page](https://platform.openai.com/account/api-keys)