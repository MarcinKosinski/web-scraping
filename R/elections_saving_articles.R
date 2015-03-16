# libraries:

library("RCurl")
library("XML")
library("dplyr")
library("stringi")
library("rvest")

# loading our functions:

source("R/google.R")
source("R/extract_title_and_link.R")

# loading dictionary:

our_dictionary <- unique(as.character(read.table("slownik.txt",encoding = "UTF-8")[-1,]))

# extracting links and titles of articles:

links_from_google <- tidy_google_links(c("wiadomosci", "newsy", "swiat", "gazeta"))

list_of_titles_and_links <- list()
for(i in seq_along(linki_do_main_page)){
   list_of_titles_and_links[[i]] <- extract_title_and_link(links_from_google[[i]],  
                                                           our_dictionary, 2)  
}

seperate_links <- unlist(lapply(list_of_titles_and_links, function(element){
   if(class(element)=="data.frame"){
      as.vector(element$LINK)
   }
}))

seperate_titles <- unlist(lapply(list_of_titles_and_links, function(element){
   if(class(element)=="data.frame"){
      as.vector(element$TITLE)
   }
}))

# saving articles:

# dir.create("dane/")
# dir.create("dane/artykuly/")

dir <- "dane/artykuly/"

for(i in seq_along(seperate_titles)){
   
   file_name <- strftime(Sys.time(),"%s") 
   file.create(file = paste0(dir, file_name, ".txt"))
   
   element <- seperate_links[i]
   
   # saving link:
   
   write.table(x = element, file = paste0(dir, file_name, ".txt" ))
   
   # saving title:
   
   write.table(x = tryCatch(repair_encoding(seperate_titles[i]), 
                            error = function(condition) seperate_titles[i]), 
               file = paste0(dir, file_name, ".txt" ), 
               append = TRUE, colnames <- FALSE)
   
   text <- html(element) %>% 
      html_nodes(".art-lead, .art-content, p, #intertext1, .lead, #artykul, #gazeta_article_lead, newsContent, hyphenate") %>% 
         html_text()  
   
   tryCatch(repair_encoding(text), error=function(condition) text) %>%
      write.table(file = paste0(dir, file_name, ".txt"), 
                  append = TRUE, colnames <- FALSE) 
} 

