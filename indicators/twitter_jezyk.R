library("textcat")

zapisz_jezyk <- function(tabela){
   for(i in 1:nrow(tabela)){
      jezyk <- textcat(tabela$text[i])
      write.table(jezyk, "dane//twitter//wskazniki//jezyk.txt", col.names = FALSE, row.names = FALSE,
                  quote = FALSE, append = TRUE)
   }   
}

tabela <- read.table("dane//twitter//twitter_wielka_tabela.txt", sep=";", header=T, row.names = NULL)
zapisz_jezyk(tabela)
