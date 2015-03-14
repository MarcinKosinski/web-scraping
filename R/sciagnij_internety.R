# Sciagnij internety



source("R/Marta.R")
source("R/Marcin.R")



dictionaryX <- c("bronisław", "komorowski",
                "andrzej", "duda",
                "magdalena", "ogórek")



for( element in daj_mi_linki_TERAZ_I_JUZ( c("wiadomosci", "newsy", "swiat", "gazeta") ) ){
   
   superfunkcja(element,  dictionary = dictionaryX )
   
}
    


