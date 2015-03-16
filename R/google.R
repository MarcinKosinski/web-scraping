get_google_page_urls <- function(link) {
   # read in page contents
   html <- getURL(link)
   
   # parse HTML into tree structure
   doc <- htmlParse(html)
   
   # extract url nodes using XPath
   links <- xpathApply(doc, "//h3//a[@href]", function(x) xmlAttrs(x)[[1]])
   
   # free doc from memory
   free(doc)
   
   # ensure urls start with "http" to avoid google references to the search page
   links <- grep("http://", links, fixed = TRUE, value=TRUE)
   
   return(links)
}

google_links <- function(key_words){
   sapply(key_words, function(key_word){
      paste0("http://www.google.pl/search?aq=f&gcx=w&sourceid=chrome&ie=UTF-8&q=", key_word) %>%
         get_google_page_urls() %>% 
            grep(pattern = "/url", value = TRUE) %>% 
               strsplit( "?q=") %>%
                  lapply(function(element){ 
                     strsplit( element[2], ".pl" )[[1]][1] 
                     }) %>%
                        unlist() %>% 
                           paste0(".pl") %>% 
                              unique()
   })
}

tidy_google_links <- function(key_words){   
   google_links(key_words) %>%
      unlist( ) %>% 
         grep(pattern = "http://", fixed= TRUE, value = TRUE ) %>%
            unique()
}


# example <- tidy_google_links(c("wiadomosci", "newsy", "swiat", "gazeta"))
# data.frame(example)
# 
# 1       http://wiadomosci.onet.pl
# 2             http://www.tvn24.pl
# 3     http://tvnwarszawa.tvn24.pl
# 4         http://wiadomosci.wp.pl
# 5       http://warszawa.gazeta.pl
# 6     http://wiadomosci.gazeta.pl
# 7        http://wiadomosci.tvp.pl
# 8                http://www.se.pl
# 9            http://news.money.pl
# 10                   http://o2.pl
# 11          http://www.filmweb.pl
# 12             http://www.gram.pl
# 13             http://www.fakt.pl
# 14             http://www.eska.pl
# 15          http://muzyka.onet.pl
# 16       http://swiat.newsweek.pl
# 17             http://wyborcza.pl
# 18           http://www.wprost.pl
# 19           http://www.gazeta.pl
# 20 http://www.warszawskagazeta.pl
# 21 http://www.gazetawroclawska.pl
# 22    http://www.gazetalubuska.pl
# 23     http://www.gazetaprawna.pl
