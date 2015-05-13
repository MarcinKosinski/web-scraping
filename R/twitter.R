library(streamR)
library(RCurl)
library(ROAuth)
library(stringi)
library(twitteR)
library(dplyr)

################ autoryzacja: ###########################

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "3ZNPRjfM0xzB38bdvmqzgFNYU"
consumerSecret <- "t6u74oLeLcRPImYGcXX5Y3EIXpEsr9bryrvO8WjQIjOwoHsJnr"
access_token = "3091082482-kE4nw7fehbN7sL9N19KFs97kAThJjjrdAag6D0m"
access_secret = "xJaUa5AmfkNyBY77EM40TWoCzLZ790DmQlaaEasK2qfVs"

my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, requestURL = requestURL, 
    accessURL = accessURL, authURL = authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

setup_twitter_oauth(consumerKey, consumerSecret, access_token, access_secret)

################## funkcje pomocnicze: ####################

zapisz_tabele <- function(sciezka_do_folderu, nazwa, tabelka_do_zapisania) {
    
    if (!file.exists(sciezka_do_folderu)) {
        dir.create(sciezka_do_folderu)
    }
    
    write.table(tabelka_do_zapisania, stri_paste(sciezka_do_folderu, "//", nazwa, ".txt"), quote = TRUE, col.names = TRUE, 
        row.names = FALSE)
}

przeszukaj_twitter <- function(od_kiedy, do_kiedy, slowo_klucz, ile_maksymalnie_twittow = 3000) {
    tweets <- suppressWarnings(searchTwitter(slowo_klucz, n = ile_maksymalnie_twittow, since = as.character(od_kiedy), 
        until = as.character(do_kiedy)))
    if (length(tweets) == 0) 
        tabelka <- NA else tabelka <- twListToDF(tweets)
    
    nazwa <- stri_paste(as.character(od_kiedy), "----", as.character(do_kiedy))
    zapisz_tabele(stri_paste("dane//twitter//slownik//", nazwa), slowo_klucz, tabelka)
}

scal_twitty_slownikowe <- function(nazwa_folderu) {
    
    setwd(stri_paste("C:\\Users\\Marta\\Desktop\\Marta\\GitHub\\web-scraping\\dane\\twitter\\slownik\\", nazwa_folderu))
    pliki <- dir()
    
    k <- 0
    for (i in seq_along(pliki)) {
        
        wczytaj <- readLines(pliki[i])
        popraw <- stri_replace_all_fixed(wczytaj, "\\\"", "'")
        writeLines(popraw[-1], "pomocniczy.txt")
        blad <- "naraziejestok"
        tryCatch({
            dane <- read.table("pomocniczy.txt", row.names = NULL, header = FALSE, sep = " ")
        }, error = function(e) {
            blad <- "alekicha"
        }, warning = function(w) {
            blad <- "alekicha"
        })
        if (blad != "alekicha" & ncol(dane) != 17) {
            if (i == length(pliki)) 
                file.remove("pomocniczy.txt")
            next
        }
        if (blad == "alekicha") {
            if (i == length(pliki)) 
                file.remove("pomocniczy.txt")
            next
        } else {
            if (k == 0) {
                colnames(dane) <- c("text", "favorited", "favoriteCount", "replyToSN", "created_day", "created_hour", 
                  "truncated", "replyToSID", "id", "replyToUID", "statusSource", "screenName", "retweetCount", 
                  "isRetweet", "retweeted", "longitude", "latitude")
                write.table(dane, stri_paste("../../tabela/", nazwa_folderu, ".txt"), sep = ";", quote = TRUE, 
                  row.names = FALSE, col.names = TRUE, append = TRUE)
                k <- 1
            } else {
                write.table(dane, stri_paste("../../tabela/", nazwa_folderu, ".txt"), sep = ";", quote = TRUE, 
                  row.names = FALSE, col.names = FALSE, append = TRUE)
            }
        }
        if (i == length(pliki)) 
            file.remove("pomocniczy.txt") 
    }   
}

jedna_tabela_twitter <- function() {
    setwd("C:\\Users\\Marta\\Desktop\\Marta\\GitHub\\web-scraping\\dane\\twitter\\tabela")
    pliki <- dir()
    for (i in seq_along(pliki)) {
        a <- read.table(pliki[i], sep = ";", header = T, row.names = NULL)
        if (i == 1) {
            write.table(a, stri_paste("../twitter_wielka_tabela.txt"), sep = ";", quote = TRUE, row.names = FALSE, 
                col.names = TRUE, append = TRUE)
        } else {
            write.table(a, stri_paste("../twitter_wielka_tabela.txt"), sep = ";", quote = TRUE, row.names = FALSE, 
                col.names = FALSE, append = TRUE)
        }
    }   
}

twitter_sciagnij_dane <- function() {
    # szukam ostatnio szukanej daty:
    
    foldery <- dir("dane//twitter//slownik")
    foldery2 <- foldery %>% stri_match_all_regex("----(.*)") %>% unlist() %>% na.omit()
    ostatnia_data <- max(foldery2[!stri_detect_fixed(foldery2, "----")])
    
    # ustalam od_kiedy i do_kiedy
    
    od_kiedy <- as.Date(ostatnia_data)
    do_kiedy <- Sys.Date()
    
    # slownik:
    
    our_dictionary <- unique(as.character(read.table("slownik.txt", encoding = "UTF-8")[-1, ]))
    
    # przeszukiwanie:
    
    for (i in 1:length(our_dictionary)) {
        przeszukaj_twitter(od_kiedy, do_kiedy, our_dictionary[i])
        cat(our_dictionary[i], "\n")
    }
    
    scal_twitty_slownikowe(stri_paste(as.character(od_kiedy), "----", as.character(do_kiedy)))
    
    jedna_tabela_twitter()
}


################ sciaganie danych: ########################

twitter_sciagnij_dane() 
