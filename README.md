# web-scraping


> Web scraping (web harvesting or web data extraction) is a computer software technique of extracting information from websites.


Projekt dotyczący analizy treści w internecie przed wyborami prezydenckimi w maju 2015.

Autorzy

- Marcin Kosiński m.p.kosinski@gmail.com
- Marta Sommer mmartasommer@gmail.com


# 3 faza projektu

## Automatyzacja

W folderze `batch` są pliki `batch`owe, które dbały o automatyzację całego procesu. Ścieżki w projekcie nie są uniwersalne, gdyż nie wiedzieliśmy jak skrypt `batch`owe odwołują się do obecnej lokalizacji pliku wykonywalnego. 

Pliki 

- `scrapping.bat` automatycznie co 2 godziny uruchamia skrypty z katalogu `R`, które pobierają dane z portali internetowych. Pobierane są dane z portali, które wyskoczyły na pierwszej stronie popularnej wyszukiwarki internetowej google.com, w wyniku wyszukiwania jednego z 4 słów: `wiadomosci`, `newsy`, `swiat`, `gazeta`. Dla każdego portalu sprawdzano, w kodzie źródłowym strony, nazwy linków na danym portalu i jeżeli pojawiało się w nazwie artykułu choć jedno słowo ze słów zawartych w pliku `slownik.txt` to automatycznie przechodzono do strony do danego artykułu (do którego odnosil dany link) oraz pobierano treść artykułu i niekiedy komentarze. Początkowo proces pobierał tak informacje z internetu co 30 min, jednak zauważono, że artykuły nie zmieniają się tak często na portalach. Możliwa jest luka w ściąganiu danych w krótkim czasie w kwietniu, z racji na reorganizację kodu, która była przyczyną niedomkniętego nawiasu w kodzie, co poskutkowało nie zapisywaniem artykułów na dysku.

- `rfacebook.bat` automatycznie co 2 godziny pobierał wszystkie wpisy oraz posty i komentarze z 4 popularnych fanpage'y kandydatów na prezydenta. Te fanpage to: `janusz.korwin.mikke`, `KomorowskiBronislaw`, `2MagdalenaOgorek`, `andrzejduda`. Wykorzystano do tego pakiet `Rfacebook`, który łączy R z API graph, aplikacją udostępnianą przez facebooka do pobierania danych, po uprzednim skonfigurowaniu i utworzeniu własnej aplikacji (dzięki czemu pobieranie danych jest autoryzowane i kontrolowane jest kto co ściąga).

- `aplikacja.bat` to skrypt wywołujący się raz dziennie. Jest to skrypt, który wywołuje skrypty z katalogu `Analizy`, które to, ze zgromadzonych danych, przygotowują wskaźniki w okrojonej i mniejszej pamięciowo formie, która jest możliwa do zamieszczenia w aplikacji `shinydashboard`. Po wykonaniu analiz, które za każdym razem odbywają się na powiększonych i zaktualizowanych danych, dzięki skryptom `rfacebook.bat` oraz `scrapping.bat`, skrypt `aplikacja.bat` aktualizuje aplikację `shinydashboard` na serwerze `shinyapp.io` - a dokładnie pod adresem: [https://marcinkosinski.shinyapps.io/wp2015/](https://marcinkosinski.shinyapps.io/wp2015/)


## Ilość i źródła zbieranych danych

Dane ściągane były z

- co najmniej 25 portali internetowych
- 4 fanpage'y kandydatów na prezydenta, którymi najbardziej byli zainteresowani autorzy
- popularnego portalu twitter : co tydzień pobierano wszystkie tweety zawierające chociaż jedno słowo z pliku `slownik.txt` | tutaj automatyzacja była trudniejsza, gdyż API twittera wymaga ręcznej autoryzacji przy każdej próbie pobrania danych

Ostatecznie 13.05.2015 zebranych danych było:

- 111 MB danych zawierających artykuły z portali oraz komentarze pod artykułami
- 25,5 MB danych dotyczących aktywności autorów i fanów na 4 wymienoinych wyżej fanpage'ach
- 235 MB danych o tweetach z twittera


## Wskaźniki, ich autonomiczność i automatyczna aktualizacja

- Dane dotyczące aktywności kandydatów w sieci pobierają się co 2 godziny. 
- Aplikacja zawierająca wskaźniki aktywności kandydatów odświeża się sama co 1 dzień. 
- Aplikacja jest autonomiczna na darmowym serwerze: [https://marcinkosinski.shinyapps.io/wp2015/](https://marcinkosinski.shinyapps.io/wp2015/)


### Wskaźniki

Dla zebranych artykułów i komentarzy pod nimi przeprowadzono analizę sentymentu treści artykułów i komentarzy z podziałem na kandydatów, gdzie artykuł był przypisany do kandydata, jeżeli jego nazwisko bądź fraza z nazwiska występowała w tytule artykułu. Taki sentyment był mierzony na przedziale czasowym. Ten wskaźnik aktywności jest zawarty na **interaktywnym** wykresie podpisanym: `Analiza sentymentu`

Dla zebranych artykułów, sprawdzono również 5 portali, które najczęściej publikowały artykuł zawierający nazwiska owych 4 kandydatów. **Interaktywny** wykres z podziałem na kandydatów oraz na portale jest dostępny w boxie z podpisem `Kto o kim pisał`.

Dla zebranych informacji z facebooku, sprawdzono ile, na przeciągu kolejnych dni, konkretni kandydaci zbierali `like`ów pod swoimi postami. **Interaktywny** wykres z podziałem na kandydatów jest dostępny w boxie z podpisem: `Kto ile dziennie miał like'ów pod postami na fanpage?`

Dla zebranych informacji o tweetach przygotowano genialną wizualizację przestrzenną, w której widać z jakich lokalizacji ludzie tweetowali. Wykres (**interaktywny**) można podziwiać w zakładce `Kula Tweetów`.

Dla zebranych informacji o tweetach przygotowano również wizualizację obrazującą o kim
ile w danym dniu było tweetów. Pokazuje to pierwszy **interaktywny** wykres w zakładce `Twitter`.