library("stringi")
library("dplyr")

z_jakiego_urzadzenia <- function(tabela){
  
  for(i in 1:nrow(tabela)){
    
    skad <- as.character(tabela$statusSource[i]) %>%
      stri_match_all_regex(">(.*?)</a>$") %>%
      unlist() %>%
      "["(2)
    
    write.table(skad, "dane//twitter//wskazniki//urzadzenie.txt", 
                col.names = FALSE, row.names = FALSE,
                quote = FALSE, append = TRUE)
    
    cat(i," / ", nrow(tabela), "\n")
    
  }
  
}

tabela <- read.table("C:\\Users\\Marta\\Desktop\\Marta\\GitHub\\web-scraping\\dane\\twitter\\twitter_wielka_tabela.txt", 
                     sep=";", header=T, row.names = NULL)
z_jakiego_urzadzenia(tabela)

