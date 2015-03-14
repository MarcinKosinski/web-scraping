# Sciagnij internety



source("R/Marta.R")
source("R/Marcin.R")



dictionaryX <- c("bronisław", "komorowski",
                "andrzej", "duda",
                "magdalena", "ogórek")


tytulo_linki <- list( )
linki_do_main_page <- daj_mi_linki_TERAZ_I_JUZ( c("wiadomosci", "newsy", "swiat", "gazeta") )

for( i in seq_along(linki_do_main_page)  ){
   
   tytulo_linki[[i]] <- superfunkcja( linki_do_main_page[[i]],  dictionary = dictionaryX, how_many = 1 )
   
}
    


tytulo_linki
