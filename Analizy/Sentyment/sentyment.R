# analiza sentymentu

library(dplyr)
library(stringi)
library(rvest)
library(xts)
library(dygraphs)

gdzie_artykuly <- "dane/artykuly/"
pozytywne <- "Analizy/Sentyment/pozytywne.txt"
negatywne <- "Analizy/Sentyment/negatywne.txt"

Funckja Marty Sommer
uprosc_tekst <- function(wektor_tekstow){
   
   wektor_tekstow %>%
      stri_replace_all_fixed("\u0105", "a") %>%
      stri_replace_all_fixed("\u0107", "c") %>%
      stri_replace_all_fixed("\u0119", "e") %>%
      stri_replace_all_fixed("\u0142", "l") %>%
      stri_replace_all_fixed("\u0144", "n") %>%
      stri_replace_all_fixed("\u00F3", "o") %>%
      stri_replace_all_fixed("\u015B", "s") %>%
      stri_replace_all_fixed("\u017A", "z") %>%
      stri_replace_all_fixed("\u017C", "z") %>%
      stri_replace_all_fixed("\u00FC", "u") %>%
      stri_replace_all_fixed("\u00E7", "c") %>%
      stri_trans_tolower() %>%
      stri_extract_all_words() %>%
      unlist() %>%
      na.omit()
   
}

policz_sentyment <- function(kandydat){
   sapply(
      oKimArtykuly$artykul[kandydat],
      function( element ){
         tresc <- readLines( element )
         
         # napraw kodowanie
         tresc <- tryCatch({
            repair_encoding(tresc)
         }, error = function(cond){ return(tresc) } )
         
         
         uprosc_tekst( tresc ) -> slowa
         stri_extract_all_words(tresc) %>% unlist -> slowa
         sum( slowa %in% pozytywne[,1] ) -
            sum( slowa %in% negatywne[,1] )
      }
   )
}



sentyment_dla_kandydatow <- function( pozytywne, negatywne, gdzie_artykuly  ){
   
   pozytywne <- read.table(pozytywne, quote="\"")
   negatywne <- read.table(negatywne, quote="\"")
   
   
   paths2articles <- paste0( gdzie_artykuly, 
                             grep( ".txt", list.files(gdzie_artykuly), value = TRUE))
   
   paths2articles %>% 
      sapply( function( element ){
         readLines( element, n = 4 ) -> x
         x[grep("http", x)[1]]
      }) -> linkS
   
   Komorowski = grepl("komorows", linkS)
   Ogorek = grepl("ogorek", linkS)
   Duda = grepl("dud", linkS)
   Mikke = grepl("mikke|korwin", linkS)
   
   data.frame( artykul = paths2articles,
               linki = linkS, # do junika
               czy_Komorowski = Komorowski,
               czy_Ogorek = Ogorek,
               czy_Duda = Duda,
               czy_Mikke = Mikke,
               stringsAsFactors = FALSE ) -> oKimArtykuly
   
   
   
   
   
   policz_sentyment(Komorowski) -> sentymentKomorowski
   policz_sentyment(Duda) -> sentymentDuda
   policz_sentyment(Ogorek) -> sentymentOgorek
   policz_sentyment(Mikke) -> sentymentMikke
   
   
   
   oKimArtykuly$czy_Ogorek[oKimArtykuly$czy_Ogorek] <- sentymentOgorek
   oKimArtykuly$czy_Komorowski[oKimArtykuly$czy_Komorowski] <- sentymentKomorowski
   oKimArtykuly$czy_Duda[oKimArtykuly$czy_Duda] <- sentymentDuda
   oKimArtykuly$czy_Mikke[oKimArtykuly$czy_Mikke] <- sentymentMikke
   
   
   oKimArtykuly <- oKimArtykuly[!duplicated(oKimArtykuly[,2]),]
   
   czasy <- sapply(
      oKimArtykuly$artykul,
      function( element ){
         file.info(element)$mtime
      }
   )
   czasy <- as.POSIXct(czasy, tz = "UTC", origin = "1970-01-01")  %>% substr( start=1, stop= 10)
   oKimArtykuly$czasy <- czasy
   
   
   oKimArtykuly %>% 
      group_by( czasy ) %>%
      summarise( sentymentDuda = sum(czy_Duda),
                 sentymentMikke = sum(czy_Mikke),
                 sentymentKomorowski = sum(czy_Komorowski),
                 sentymentOgorek = sum(czy_Ogorek)) %>% 
      as.data.frame() -> doNarysowania
   
   
   
   row.names(doNarysowania) <- doNarysowania$czasy
   doNarysowania <- doNarysowania[, -1]
   
   doNarysowania$sentymentDuda <- cumsum(doNarysowania$sentymentDuda)
   doNarysowania$sentymentMikke <- cumsum(doNarysowania$sentymentMikke)
   doNarysowania$sentymentOgorek <- cumsum(doNarysowania$sentymentOgorek)
   doNarysowania$sentymentKomorowski <- cumsum(doNarysowania$sentymentKomorowski)
   as.xts(doNarysowania) -> doNarysowaniaDygraph
   save(doNarysowaniaDygraph, file = "Analizy/Sentyment/doNarysowaniaDygraph.rda")
      
}



#