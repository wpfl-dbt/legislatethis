# Load the required libraries
library(rvest)
library(xml2)
library(dplyr)

# URL of the webpage containing XML file links
url <- "https://www.theyworkforyou.com/pwdata/scrapedxml/debates/"

# Fetch the webpage content
webpage <- read_html(url)

# Find all hyperlinks on the webpage
hyperlinks <- html_nodes(webpage, "a")

# Extract and store the URLs of all hyperlinks
all_urls <- html_attr(hyperlinks, "href")

xml_urls <- character()
for (link in hyperlinks) {
  file_url <- html_attr(link, "href")
  if (grepl("debates(\\d{4}-\\d{2}-\\d{2}[a-z]?).xml", file_url)) {
    # Extract the date from the XML file name
    date_str <- gsub("debates(\\d{4}-\\d{2}-\\d{2}[a-z]?).xml", "\\1", file_url)
    
    # Convert the date string to a Date object
    file_date <- as.Date(date_str, format = "%Y-%m-%d")
    
    # Check if the file date is from 2020 onwards
    if (!is.na(file_date) && file_date >= as.Date("2020-01-01")) {
      xml_urls <- c(xml_urls, file_url)
    }
  }
}


# Add the base URL to each URL extension
xml_urls_complete <- paste0(url, xml_urls)

# Create a directory to save the downloaded XML files
if (!dir.exists("xml_files")) {
  dir.create("xml_files")
}

# Function to download a file from a given URL
download_xml_file <- function(url, save_path) {
  download.file(url, destfile = save_path, mode = "wb")
}

# Download all XML files from 2020 onwards and store their info in a data frame
downloaded_files <- data.frame()
for (file_url in xml_urls_complete) {
  file_name <- basename(file_url)
  save_path <- file.path("xml_files", file_name)
  
  # Add a row to the data frame with file information
  file_info <- data.frame(File_Name = file_name, URL = file_url, Save_Path = save_path)
  downloaded_files <- rbind(downloaded_files, file_info)
  
  # Download the XML file
  download_xml_file(file_url, save_path)
  cat("Downloaded:", file_name, "\n")
}

