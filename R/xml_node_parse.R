library(xml2)
library(tidyverse)

# Create a function to get all unique node names from a list of XML files
get_node_names <- function(file_list) {
  all_nodes <- c()
  for(file in file_list) {
    xml_parsed <- read_xml(file)
    nodes <- xml_name(xml_find_all(xml_parsed, "//*"))
    all_nodes <- c(all_nodes, nodes)
  }
  unique(all_nodes)
}

# Specify your XML files directory and the pattern of your XML files
xml_files_dir <- "~/legislatethis2/xml_test" # Replace with your directory
pattern <- "*.xml" # If your xml files have a specific pattern, replace this

# Create a list of all XML files in the specified directory
xml_files_list <- list.files(path = xml_files_dir, pattern = pattern, full.names = TRUE)

# Use get_node_names function to get all unique node names from the XML files
all_node_names <- get_node_names(xml_files_list)


