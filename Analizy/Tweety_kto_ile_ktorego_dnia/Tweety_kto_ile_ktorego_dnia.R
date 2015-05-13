library("data.table")
library("stringi")
library("dplyr")
library("ggplot2")

b <- fread("D:/web-scraping/dane/twitter/twitter_ostatecznie.txt",
           sep=";", header=T)

bb <- b %>% filter(jezyk=="polish")

bb %>%
   group_by(created_day) %>%
   summarise(komorowski = sum(komorowski_indykator),
             duda = sum(duda_indykatror),
             ogorek = sum(ogorek_indykator),
             kukiz = sum(kukiz_indykator))%>%
                arrange(created_day) -> tabela
             
             # tabela
             # which(tabela$ile_duda>15000)
             
#              ggplot(tabela[-c(3,4),], aes(x=created_day))+
#                 geom_line(aes(y=ile_komorowski, group=1), color="blue")+
#                 geom_line(aes(y=ile_duda, group=1), color="red")+
#                 geom_line(aes(y=ile_ogorek, group=1), color="black")+
#                 geom_line(aes(y=ile_kukiz, group=1), color="green")+
#                 theme_bw()


library(reshape2)

melt( tabela ) -> tabela2

names(tabela2) <- c("dzien", "kto", "ile_tweetow")
save(tabela2, file = "D:/web-scraping/Aplikacja/tabela2.rda")
