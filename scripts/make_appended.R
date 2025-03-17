#'

library(tidyverse)
library(magick)
library(imager)
source(here::here("metadata.R"))
set.seed(42)

get_filenames(paste0(folder_data, "colony_scans/original"), ".tiff") %>% attach()
length(filenames)

# Downsize
list_images <- list()
for (i in 1:length(filenames)) {
    cat("\n", i)
    filename_resized <- paste0(folder_data, "colony_scans/resized/", filenames_extracted[i], ".jpg")
    cat(filename_resized)
    if (file.exists(filename_resized)) {next; cat("\n", filenames_extracted[i], " exists")}
    image_read(paste0(folder_data, "colony_scans/original/", filenames[i])) %>% 
        magick2cimg() %>% 
        imresize(scale = .1) %>% 
        save.image(filename_resized)
}

# Append
list_images <- lapply(paste0(folder_data, "colony_scans/resized/", filenames_extracted, ".jpg"), load.image)
length(list_images)

make_row_imgs <- function(list_objs) {
    #' This should be 10 objects long
    imlist_objs <- as.imlist(list_objs)
    img <- imappend(imlist_objs, axis = "x")
    return(img)
}
append_rows <- function (list_rows) {
    imlist_rows <- as.imlist(list_rows)
    img <- imappend(imlist_rows, axis = "y")
    return(img)
}
make_appended_image <- function (list_objs, width = 10, height = 10) {
    #' Take the list of cropped object images and append them according to the width and length
    #stopifnot(length(list_objs) == width * height)
    list_rows <- list()
    for (j in 1:height) list_rows[[j]] <- make_row_imgs(list_objs[((j-1)*width+1):(j*width)])
    img <- append_rows(list_rows)
    return(img)
}

img <- make_appended_image(list_images[1:700], width = 35, height = 20)
save.image(img, paste0(folder_data, "colony_scans/appended.jpg"))

 
# folder_example <- paste0(folder_data, "root_scans/example/")
# if (!file.exists(folder_example)) dir.create(folder_example, recursive = T)
# 
# 
# 
# filename_extracted <- filenames_extracted[i]
# img_raw <- image_read(paste0(folder_data, "root_scans/nematode_free/downsized/", filename_extracted, ".tiff"))
# img_raw <- image_resize(img_raw, geometry = 1000)
# img_seg1 <- image_read(paste0(folder_data, "root_scans/nematode_free/segmentation/", filename_extracted, ".tiff"))
# img_seg2 <- image_read(paste0(folder_data, "root_scans/nematode_free/postseg/", filename_extracted, "/01-seg.jpg"))
# img_bin <- image_read(paste0(folder_data, "root_scans/nematode_free/postseg/", filename_extracted, "/02-bin.jpg"))
# img_dilated <- image_read(paste0(folder_data, "root_scans/nematode_free/postseg/", filename_extracted, "/03-dilated.jpg"))
# img_cleaned <- image_read(paste0(folder_data, "root_scans/nematode_free/postseg/", filename_extracted, "/04-cleaned.jpg"))
# 
# imgs <- image_scale(c(img_raw, img_seg1, img_seg2, img_bin, img_dilated, img_cleaned), geometry = 1000)
# img_gif <- image_animate(imgs, fps = 1, dispose = "previous")
# 
# image_write_gif(img_gif, paste0(folder_example, filename_extracted, ".gif"), delay = 1)
# image_write(img_raw, paste0(folder_example, filename_extracted, "_ra.png"))
# image_write(img_cleaned, paste0(folder_example, filename_extracted, "_cleaned.png"))
