library(Rfacebook)
library(dplyr)


# save(authenticateFACEBOOK, file = "R/authenticateFACEBOOK.rda")

load("R/authenticateFACEBOOK.rda")

# pages to follow
pagesToDDl <- list("janusz.korwin.mikke",
                   "KomorowskiBronislaw",
                   "2MagdalenaOgorek",
                   "andrzejduda")


daty <- seq(from = as.Date("2015/03/01"), to = as.Date("2015/05/12"), by = "day")

# download posts from pages
information <- lapply(pagesToDDl, function( page ){
   
   sapply( 1:(length(daty)-1), function( element ){
   tryCatch({getPage( token = authenticateFACEBOOK,
            page = page,
            n = 100,
            since=daty[element], until=daty[element+1]
   ) %>%
      .$likes_count %>%
      sum},
   error = function( cond ) {return(0)} )
      
   })
})

as.data.frame(information) -> ileLajkow
names(ileLajkow) <- unlist(pagesToDDl)
ileLajkow$daty <- as.POSIXct(daty[-73], 
                             tz = "UTC", origin = "1970-01-01")  %>% substr( start=1, stop= 10)



require(reshape2)
melt(ileLajkow) ->ileLajkow
names(ileLajkow)[2:3] <- c("kandydat", "ileLajkowPodWpisami")

save( ileLajkow, file = "Analizy/Dzienna_ilosc_like_w_postach/ileLajkow.rda")

# x1 <- xPlot(ileLajkowPodWpisami ~ daty, group = "kandydat", data = ileLajkow, 
#             type = "line-dotted")
# x1$print("chart4")
