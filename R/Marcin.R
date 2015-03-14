# load packages
library(RCurl)
library(XML)
library(dplyr)
library(stringi)

get_google_page_urls <- function(u) {
   # read in page contents
   html <- getURL(u)
   
   # parse HTML into tree structure
   doc <- htmlParse(html)
   
   # extract url nodes using XPath. Originally I had used "//a[@href][@class='l']" until the google code change.
   links <- xpathApply(doc, "//h3//a[@href]", function(x) xmlAttrs(x)[[1]])
   
   # free doc from memory
   free(doc)
   
   # ensure urls start with "http" to avoid google references to the search page
   links <- grep("http://", links, fixed = TRUE, value=TRUE)
   return(links)
}

daj_mi_linki_zebym_byl_zadowolony <- function( x ){
   sapply(x, function(y){
 paste0( "http://www.google.pl/search?aq=f&gcx=w&sourceid=chrome&ie=UTF-8&q=",y ) %>%
 get_google_page_urls() %>% grep( pattern = "/url", value = TRUE) %>% strsplit( "?q=") %>%
   lapply( function(element){ strsplit( element[2], ".pl" )[[1]][1] } ) %>%
   unlist() %>% paste0(".pl") %>% unique()
   }
   )
}


daj_mi_linki_TERAZ_I_JUZ <- function( x ){

daj_mi_linki_zebym_byl_zadowolony( x ) %>%
   unlist( ) %>% grep( pattern = "http://", fixed= TRUE, value = TRUE )
}

# daj_mi_linki_TERAZ_I_JUZ( c("wiadomosci", "newsy", "swiat", "gazeta") )



# [1] "http://wiadomosci.onet.pl"   "http://www.tvn24.pl"         "http://tvnwarszawa.tvn24.pl"
# [4] "http://wiadomosci.wp.pl"     "http://warszawa.gazeta.pl"   "http://wiadomosci.gazeta.pl"
# [7] "http://wiadomosci.tvp.pl"    "http://www.se.pl"



## http://stackoverflow.com/questions/5187685/r-search-google-for-a-string-and-return-number-of-hits/5188468#5188468


