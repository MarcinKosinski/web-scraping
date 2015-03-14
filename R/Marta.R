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
   #g <- guess_encoding(t)$confidence[1]
   #if(g>0.5) repair_encoding(t)
   l <- unlist(links[which(unlist(lista)==1)])
   #gg <- guess_encoding(l)$confidence[1]
   #if(gg>0.5) repair_encoding(l)
   ll <- unlist(stri_extract_all_regex(l, "[h][t][t][p].+"))
   if(length(ll)==0){
      "kicha"
   } else {
      ll <- na.omit(ll)
      tt <- t[l %in% ll]
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



































