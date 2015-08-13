dni <- seq(from=as.Date("2015/02/01"), to=as.Date("2015/05/24"), by="day")
dni %>% as.character %>% stri_replace_all_fixed( "-","/") -> dni

pagesToDDl <- c("kukizpawel",
							"2MagdalenaOgorek",
							"janusz.korwin.mikke",
							"KomorowskiBronislaw",
							"andrzejduda",
							"JanuszPalikotJP",
							"Kowalski.Marian")
library(Rfacebook)
library(dplyr)


pb <- txtProgressBar(min = 0, max = (length(dni)-1, style = 3)
# download posts from pages
for( i in 1:(length(dni)-1)){
	lapply(pagesToDDl, function( page ){
		getPage( token = authenticateFACEBOOK,
						 page = page,
						 n = 1000,
						 since = dni[i],
						 until = dni[i+1],
						 feed = TRUE
		)   -> information

		do.call(cbind,information) -> inf_df
		names(inf_df) <- rownames(information)
		write.table(inf_df, file = paste0(page,"/",dni[i], ".txt"),
								col.names  = TRUE,
								row.names = FALSE,
								quote = FALSE
								)
	})
	setTxtProgressBar(pb, i)
}
close(pb)
