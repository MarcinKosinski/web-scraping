library(Rfacebook)
library(dplyr)


# save(authenticateFACEBOOK, file = "R/authenticateFACEBOOK.rda")

load("D:/web-scraping/R/authenticateFACEBOOK.rda")

# pages to follow
pagesToDDl <- list("janusz.korwin.mikke",
                   "KomorowskiBronislaw",
                   "2MagdalenaOgorek",
                   "andrzejduda")

# download posts from pages
information <- lapply(pagesToDDl, function( page ){
   getPage( token = authenticateFACEBOOK,
            page = page,
            n = 100,
            feed = TRUE
   )   
})
# directory to write
#dir <- "D:/web-scraping/dane/facebook/"

#write posts
for(i in seq_along(information)){
   
   dir <- paste0("D:/web-scraping/dane/facebook/", pagesToDDl[[i]], "/")
   
   file_name <- strftime(Sys.time(),"%s") 
   file.create(file = paste0(dir, file_name, ".txt"))
   
   information[[i]] %>%
   write.table(file = paste0(dir, file_name, ".txt"), 
               append = TRUE, col.names = FALSE, row.names = FALSE,
               quote = FALSE)

}