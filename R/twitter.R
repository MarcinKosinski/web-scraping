library(streamR)
library(RCurl)
library(ROAuth)
library(stringi)

our_dictionary <- unique(as.character(read.table("slownik.txt",encoding = "UTF-8")[-1,]))

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "xxx"
consumerSecret <- "xxx"

my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret, requestURL=requestURL,
                             accessURL=accessURL, authURL=authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

filterStream(file="C:\\Users\\Marta\\Desktop\\Marta\\GitHub\\web-scraping\\dane\\twitter\\dzien3.json",
             track="prezydent, wybory, głosowanie, bronisław komorowski, andrzej duda, magdalena ogórek, sondaż, przedwyborczy, sondaże", 
             timeout=11*60*60, oauth=my_oauth) 
             #locations=c(-49,-14.07,-54.50,-24.09))

dane <- parseTweets("C:\\Users\\Marta\\Desktop\\Marta\\GitHub\\web-scraping\\dane\\twitter\\dzien3.json", 
                    simplify=FALSE, verbose=TRUE)
dane$text

