.PHONY: app requirements

#################################################################################
# GLOBALS                                                                       #
#################################################################################

NOW:=$(shell date +"%m-%d-%y_%H-%M-%S")

#################################################################################
# COMMANDS                                                                      #
#################################################################################

app:
	R -e "shiny::runApp('app', port = 9000)"

define R_REQUIREMENTS
options(warn = 2);
install.packages(c(
    "shiny",
    "shinyGovstyle",
    "stringr",
    "dplyr",
    "tidyr",
    "here",
    "purrr",
    "openai",
    "readr",
    "lubridate",
    "gptstudio",
    "proxyC"
  ),
  clean=TRUE
);
endef
export R_REQUIREMENTS

requirements:
	Rscript -e "$$R_REQUIREMENTS"
