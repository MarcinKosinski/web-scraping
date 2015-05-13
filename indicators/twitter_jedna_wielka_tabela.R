library("dplyr")
library("data.table")

jedna_wielka_tabela() <- function(){
  tabela <- read.table("\\dane\\twitter\\twitter_wielka_tabela.txt", 
                       sep=";", header=T, row.names = NULL)
  
  jezyk <- read.table("\\dane\\twitter\\wskazniki\\jezyk.txt", 
                      sep=" ", header=F, row.names = NULL)
  
  nazwisko_indykator <- read.table("\\dane\\twitter\\wskazniki\\nazwisko_indykator.txt", 
                                   sep=" ", header=T, row.names = NULL)
  
  urzadzenie <- fread("\\dane\\twitter\\wskazniki\\urzadzenie.txt",
                      sep="\n", header=F)
  
  colnames(urzadzenie) <- "urzadzenie"
  colnames(jezyk) <- "jezyk"
  
  dane <- cbind(tabela, jezyk, nazwisko_indykator, urzadzenie)
  
  write.table(dane, "\\dane\\twitter\\twitter_ostatecznie.txt", 
              col.names = TRUE, row.names = FALSE, sep=";",
              quote = TRUE, append = FALSE)  
}


