library("stringi")

nazwisko_indykator <- function(tabela){
  
  for(i in 1:nrow(tabela)){
    
    tabela$text[i] %>%
      stri_trans_tolower() %>%
      stri_detect_fixed("komorows") -> komorowski
    
    tabela$text[i] %>%
      stri_trans_tolower() %>%
      stri_detect_regex("ogórek|ogorek") -> ogorek
    
    tabela$text[i] %>%
      stri_trans_tolower() %>%
      stri_detect_fixed("dud") -> duda
    
    tabela$text[i] %>%
      stri_trans_tolower() %>%
      stri_detect_fixed("kukiz") -> kukiz
    
    tabela$text[i] %>%
      stri_trans_tolower() %>%
      stri_detect_fixed("mikke|korwin") -> korwin
    
    data.frame(komorowski_indykator = komorowski, duda_indykatror = duda, ogorek_indykator = ogorek, 
               korwin_indykator = korwin, kukiz_indykator = kukiz) -> tabelka
    
    if(i==1){
      write.table(tabelka, "dane//twitter//wskazniki//indykator_nazwiska.txt", 
                  col.names = TRUE, row.names = FALSE,
                  quote = FALSE, append = TRUE)  
    } else{
      write.table(tabelka, "dane//twitter//wskazniki//indykator_nazwiska.txt", 
                  col.names = FALSE, row.names = FALSE,
                  quote = FALSE, append = TRUE)
    } 
    
    cat(i," / ", nrow(tabela), "\n")
    
  }
  
}

# setwd("C:\\Users\\Marta\\Desktop\\Marta\\GitHub\\web-scraping")

tabela <- read.table("C:\\Users\\Marta\\Desktop\\Marta\\GitHub\\web-scraping\\dane\\twitter\\twitter_wielka_tabela.txt", 
                     sep=";", header=T, row.names = NULL)

nazwisko_indykator(tabela)
