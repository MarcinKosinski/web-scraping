# ponow analizy na nowych danych

source("D:/web-scraping/Analizy/Dzienna_ilosc_like_w_postach/dzienna_ilosc_like_w_postach.R")
source("D:/web-scraping/Analizy/Ilosciowo/ile_pisano_na_ktorym_portalu.R")
source("D:/web-scraping/Analizy/Sentyment/sentyment.R")
source("D:/web-scraping/Analizy/Tweety_kto_ile_ktorego_dnia/Tweety_kto_ile_ktorego_dnia.R")

# zaktualizuj aplikacje
library(shinyapps)
deployApp("D:/web-scraping/Aplikacja", appName ="wp2015")
