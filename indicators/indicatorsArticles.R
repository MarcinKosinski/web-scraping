library(dplyr)


paths2articles <- paste0( "dane/artykuly/", 
                          grep( ".txt", list.files("dane/artykuly/"), value = TRUE))

paths2articles %>% 
   sapply( function( element ){
      readLines( element, n = 4 ) -> x
      x[grep("http", x)[1]]
   }) %>% 
   unique() -> result
      
      
#      length(result)



data.frame(
Komorowski = length(grep("komorows", result)),
Ogorek = length(grep("ogorek", result)),
Duda = length(grep("dud", result)),
Mikke = length(grep("mikke|korwin", result))
) -> howManyArticles

library(reshape2)
howManyArticles <- melt(howManyArticles)
names(howManyArticles) <- c("kandydat", "ileArtykulow")

library(ggplot2)
library(ggthemes)

motyw <- theme_bw(base_family = "serif", base_size = 28) +
   theme(legend.background = element_blank(),
         legend.key = element_blank(),
         panel.background = element_blank(),
         panel.border = element_blank(),
         strip.background = element_blank(),
         plot.background = element_blank(),
         axis.line = element_blank(),
         panel.grid = element_blank(),
         legend.position = "top",
         axis.title.x = element_text(vjust=-0.4),
         axis.title.y = element_text(vjust=+1)
   )

ggplot(howManyArticles, aes( y = ileArtykulow, x = kandydat))+
   geom_bar(stat="identity") + motyw +
   ylab("ile artykułów") + ggtitle("Ile się pisze ostatnio \n o kandydatch w wyborach?")



##### domens
PROTOCOL_REGEX <- "^(?:(?:[[:alpha:]+.-]+)://)?"
PREFIX_REGEX <- "(?:www\\.)?"
HOSTNAME_REGEX <- "([^/]+)"
REST_REGEX <- ".*$"
URL_REGEX <- paste0(PROTOCOL_REGEX, PREFIX_REGEX, HOSTNAME_REGEX, REST_REGEX)
domain.name <- function(urls) gsub(URL_REGEX, "\\1", urls)
domain.name(result)


library(stringi)

result2 <- grepl("http", result)

lapply( strsplit( result, split = "http"), function(element){
   grep( x = element, pattern = "//", value = TRUE )
}
) %>% unlist -> linki

sapply( linki, function(element){
   paste0( "http", element ) %>% domain.name
}
) -> domens
   
   


helpMe <- character( length(result) )

helpMe[grepl("komorows", result)] <- "Komorowski"
helpMe[grepl("ogorek", result)] <- "Ogorek"
helpMe[grepl("dud", result)] <- "Duda"
helpMe[grepl("mikke|korwin", result)] <- "Mikke"
        

data.frame( kto = helpMe, domena =unlist(domens)) -> WhoAndWhere

WhoAndWhere %>% filter( kto != "") -> WhoAndWhere


WhoAndWhere
WhoAndWhere[, 2] <- as.character(WhoAndWhere[, 2])

powyzej3 <- table(WhoAndWhere[, 2])[ table(WhoAndWhere[, 2]) > 3] %>% names()

WhoAndWhere %>%
   filter( domena %in% powyzej3 ) %>%   
   group_by( kto, domena) %>% 
   summarise( count = n()) -> WhoAndWhere2Viz

WhoAndWhere2Viz

ggplot(WhoAndWhere2Viz, aes( y = count, x = domena))+
   geom_bar(stat="identity") + motyw +
   ylab("ile artykułów") + ggtitle("Które 10 najczęściej piszących \n o wyborach portali piszę \n o jakich kandydatch w wyborach?")+
   facet_grid(kto~.) + theme_bw(base_family = "serif", base_size = 18) +
   theme(legend.background = element_blank(),
         legend.key = element_blank(),
         panel.background = element_blank(),
         panel.border = element_blank(),
         strip.background = element_blank(),
         plot.background = element_blank(),
         axis.line = element_blank(),
         panel.grid = element_blank(),
         legend.position = "top",
         axis.title.x = element_text(vjust=-0.4),
         axis.title.y = element_text(vjust=+1),
         axis.text.x = element_text(vjust=0.2,angle = 45)
   )


