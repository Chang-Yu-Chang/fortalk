# This script stores the metadata shared by all scripts

library(tidyverse)

# This main folder depends on your home directory and user name
folder_data <- "~/Dropbox/lab/fortalk/data/" # Enter the directory of data

#
get_filenames <- function (folder, file_pattern = "\\d+.tiff") {
    filenames <- list.files(path = folder, pattern = file_pattern)
    filenames_extracted <- str_remove(filenames, ".tiff")
    return(list(filenames = filenames, filenames_extracted = filenames_extracted))
}
#get_filenames(folder_seg, "\\d+.tiff") %>% attach()
