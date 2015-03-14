library("stringi")
library("rvest")

superfunkcja <- function(main_page_link, dictionary, how_many){
   
   main_page_link <- html(main_page_link)
   link_and_title <- html_nodes(main_page_link, "a")
   links <- html_attr(link_and_title, name="href")
   titles <- html_text(link_and_title)
   
   lista <- lapply(lapply(stri_extract_all_words(titles), stri_trans_tolower), function(x){
      sum((x %in% dictionary) >= how_many)
   })
   
   t <- titles[which(unlist(lista)==1)]
   l <- unlist(links[which(unlist(lista)==1)])
   ll <- na.omit(unlist(stri_extract_all_regex(l, "[h][t][t][p].+")))
   tt <- t[l %in% ll]
   if(length(ll)==0){
      NA
   } else {
      data.frame(tytul=tt, link=ll)
   }
}

# dictionary <- c("bronisław", "komorowski",
#                 "andrzej", "duda",
#                 "magdalena", "ogórek")
# 
# main_page_link <- "http://www.onet.pl/"
# #main_page_link <- "http://www.tvn24.pl/"
# 
# how_many <- 1
# 
# tab <- superfunkcja(main_page_link, dictionary,1)



































