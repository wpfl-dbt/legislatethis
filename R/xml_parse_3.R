library(xml2)
library(tidyverse)
library(purrr)
library(tibble)
library(stringr)

# Directory with XML files
xml_dir <- "~/legislatethis2/xml_test"

# Get a list of all XML files in the directory
xml_files <- list.files(xml_dir, pattern = "*.xml", full.names = TRUE)

# Process each file
all_data <- map_df(xml_files, function(xml_content) {
  
  # Parse the XML content
  xml_parsed <- read_xml(xml_content)
  
  # Extract all elements
  all_nodes <- xml_find_all(xml_parsed, "//*")
  
  # Initialize empty variables to store the current major and minor heading
  major_heading <- NA
  minor_heading <- NA
  
  # Process each node
  map_df(all_nodes, function(node) {
    
    # Check the node name
    node_name <- xml_name(node)
    
    # If the node is a major heading, store its text content
    if (node_name == "major-heading") {
      major_heading <<- xml_text(node)
      return(tibble())
      
      # If the node is a minor heading, store its text content
    } else if (node_name == "minor-heading") {
      minor_heading <<- xml_text(node)
      return(tibble())
      
      # If the node is a speech, extract its attributes and return a tibble
    } else if (node_name == "speech") {
      tibble(
        major_heading = major_heading,
        minor_heading = minor_heading,
        speakername = xml_attr(node, "speakername"),
        type = xml_attr(node, "type"),
        person_id = xml_attr(node, "person_id"),
        colnum = xml_attr(node, "colnum"),
        time = xml_attr(node, "time"),
        url = xml_attr(node, "url"),
        paragraph_id = 1:length(xml_find_all(node, ".//p")),
        paragraph_text = xml_find_all(node, ".//p") %>% xml_text() %>% as.character()
      )
    } else {
      return(tibble())
    }
  })
})

# Use str_extract to extract numbers after the last "/"
all_data$person_id_number <- sub(".*/", "", all_data$person_id)
