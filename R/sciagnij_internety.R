# Sciagnij internety



source("R/Marta.R")
source("R/Marcin.R")



dictionary <- unique(as.character(read.table("slownik.txt",encoding = "UTF-8")[-1,]))


tytulo_linki <- list( )
linki_do_main_page <- daj_mi_linki_TERAZ_I_JUZ( c("wiadomosci", "newsy", "swiat", "gazeta") )

for( i in seq_along(linki_do_main_page)  ){
   
   tytulo_linki[[i]] <- superfunkcja( linki_do_main_page[[i]],  dictionary = dictionaryX, how_many = 1 )
   
}
  
lin <- unlist(lapply(tytulo_linki, function(element){
   if(class(element)=="data.frame"){
      as.vector(element$link)
   }
}))

tyt <- unlist(lapply(tytulo_linki, function(element){
   if(class(element)=="data.frame"){
      as.vector(element$tytul)
   }
}))


# dir.create("dane/")
# dir.create("dane/artykuly/")
dir <- "dane/artykuly/"


for( i in seq_along(tyt) ){
   
   element <- lin[i]
   file.create( file = paste0( dir, element, ".txt" ) )
   write.table(x = element, file = paste0( dir, paste0("arty",i), ".txt" ), fileEncoding = "UTF-8" )
   write.table(x = tryCatch( repair_encoding(tyt[i]), error = function(cond) tyt[i] ), file = paste0( dir, paste0("arty",i), ".txt" ), append = TRUE, fileEncoding = "UTF-8" )
   
   text <- html( element ) %>% 
      html_nodes( ".art-lead, .art-content, p, #intertext1,
           .lead,#artykul, #gazeta_article_lead", "newsContent", "hyphenate" ) %>% 
      html_text() %>% 
      repair_encoding() %>% 
      html_text 
   
   tryCatch( repair_encoding(text), error = function(cond) text ) %>%
   write.table( file = paste0( dir, paste0("arty",i), ".txt" ), append = TRUE, fileEncoding = "UTF-8" ) 
} 


