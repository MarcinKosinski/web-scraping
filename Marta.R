library("stringi")
library("rvest")

superfunkcja <- function(onet, dictionary){
  
  onet <- html(onet)
  wszystko <- html_nodes(onet, "a")
  linki <- html_attrs(wszystko)
  tytuly <- html_text(wszystko)
  
  lista <- lapply(lapply(stri_extract_all_words(tytuly), stri_trans_tolower), function(x){
    sum((x %in% dictionary) >= 1)
  })
  
  t <- unique(tytuly[which(unlist(lista)==1)])
  l <- unlist(linki[which(unlist(lista)==1)])
  ll <- na.omit(unlist(stri_extract_all_regex(l, "[h][t][t][p].+")))
  
  data.frame(tytul=t, link=ll)
}

dictionary <- c("bronisław", "komorowski",
                "andrzej", "duda",
                "magdalena", "ogórek")

onet <- "http://www.onet.pl/"
onet <- "http://www.tvn24.pl/"

tab <- superfunkcja(onet, dictionary)



































