library(streamR)
library(RCurl)
library(ROAuth)
library(stringi)
library(twitteR)

# autoryzacja:

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "3ZNPRjfM0xzB38bdvmqzgFNYU"
consumerSecret <- "t6u74oLeLcRPImYGcXX5Y3EIXpEsr9bryrvO8WjQIjOwoHsJnr"

my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret, requestURL=requestURL,
                             accessURL=accessURL, authURL=authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

# filterStream:

filterStream(file="C:\\Users\\Marta\\Desktop\\Marta\\GitHub\\web-scraping\\dane\\twitter\\dzien3.json",
             track="prezydent, wybory, głosowanie, bronisław komorowski, andrzej duda, magdalena ogórek, sondaż, przedwyborczy, sondaże", 
             timeout=11*60*60, oauth=my_oauth) 
             #locations=c(-49,-14.07,-54.50,-24.09))

dane <- parseTweets("C:\\Users\\Marta\\Desktop\\Marta\\GitHub\\web-scraping\\dane\\twitter\\dzien3.json", 
                    simplify=FALSE, verbose=TRUE)
dane$text

# searchTwitts:

access_token="3091082482-kE4nw7fehbN7sL9N19KFs97kAThJjjrdAag6D0m"
access_secret="xJaUa5AmfkNyBY77EM40TWoCzLZ790DmQlaaEasK2qfVs"
setup_twitter_oauth(consumerKey, consumerSecret, access_token, access_secret)

our_dictionary <- unique(as.character(read.table("slownik.txt",encoding = "UTF-8")[-1,]))

for(i in 1:length(our_dictionary)){
   tweets <- searchTwitter(our_dictionary[i], n=2000, since="2015-03-01", until="2015-04-03")
   if(length(tweets)==0) next
   dftweets <- twListToDF(tweets)
   write.table(dftweets, 
              stri_paste("C:\\Users\\Marta\\Desktop\\Marta\\GitHub\\web-scraping\\dane\\twitter\\",
                         our_dictionary[i], "_tabela_", strftime(Sys.time(),"%F"), ".txt"),
              sep="*")
}









