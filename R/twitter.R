library(streamR)
library(RCurl)
library(ROAuth)
library(stringi)

our_dictionary <- unique(as.character(read.table("slownik.txt",encoding = "UTF-8")[-1,]))

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "3ZNPRjfM0xzB38bdvmqzgFNYU"
consumerSecret <- "t6u74oLeLcRPImYGcXX5Y3EIXpEsr9bryrvO8WjQIjOwoHsJnr"

my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret, requestURL=requestURL,
                             accessURL=accessURL, authURL=authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

filterStream(file="dane\\twitter\\dzien1.json",
             track="prezydent, wybory, głosowanie, bronisław komorowski, andrzej duda, magdalena ogórek, sondaż, przedwyborczy, sondaże", 
             timeout=3*60*60, oauth=my_oauth) 
             #locations=c(-49,-14.07,-54.50,-24.09))

dane <- parseTweets(stri_paste("dane\\twitter\\", strftime(Sys.time(),"%s") ,".json",collapse=""), 
                    simplify=FALSE, verbose=TRUE)
dane$text

