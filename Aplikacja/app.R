## app.R ##
library(shinydashboard)
library(shiny)
library(dygraphs)
library(rCharts)
library(dplyr)
library(reshape2)
library(shinyGlobe)
ui <- dashboardPage(
   dashboardHeader(title = "Wybory w internecie",
                   dropdownMenu(type = "messages",
                                messageItem(
                                   from = "Marcin Kosiński",
                                   message = "https://github.com/MarcinKosinski"
                                ),
                                messageItem(
                                   from = "Marta Sommer",
                                   message = "mmartasommer@gmail.com",
                                   icon = icon("question"),
                                ),
                                messageItem(
                                   from = "Dane",
                                   message = "Były zbierane od do 2015-03-13.",
                                   icon = icon("life-ring"),
                                   time = "2015-03-13"
                                )
                   )
 
                   ),
   dashboardSidebar(
      sidebarMenu(
         menuItem("Facebook i Artykuły", tabName = "dashboard", icon = icon("dashboard")),
         menuItem("Kula Tweetów", tabName = "twit", icon = icon("dashboard")),
         menuItem("Twitter", tabName = "twit2", icon = icon("dashboard")),
         menuItem("Opis", tabName = "opis", icon = icon("th")),
         menuItem("Kody źródłowe", icon = icon("file-code-o"),
                  href = "https://github.com/MarcinKosinski/web-scraping"
         )
      )
   ),
   dashboardBody(
      tabItems(
               # First tab content
          tabItem(tabName = "dashboard",
                  # Boxes need to be put in a row (or column)
                  fluidRow(
#                      box(plotOutput("plot1", height = 250)),
#                      
#                      box(
#                         title = "Controls",
#                         sliderInput("slider", "Number of observations:", 1, 100, 50)
#                      ),
#                      hr(),
                     box(title = "Analiza sentymentu", collapsible = TRUE, 
                          width = 4, solidHeader = TRUE, status = "warning",
                        dygraphOutput("dajgraf", height = 400),
                        textOutput("legendDivID")
                     ),

                      box(title = "Kto o kim pisał?", collapsible = TRUE, 
                          width = 8, solidHeader = TRUE, status = "warning",
                         showOutput("myChart", "nvd3"),
                         selectInput(inputId = "type",
                                     label = "Kierunek osi wykresu paskowego",
                                     choices = c("multiBarChart", "multiBarHorizontalChart"),
                                     selected = "multiBarChart")
                      ),
#                      box(title = "Legenda", textOutput("legendDivID"), collapsible = TRUE,
#                          #collapsed = TRUE,
#                          width = 4, solidHeader = TRUE, status = "warning",height = 90),
#                      box(title = "Kierunek osi", collapsible = TRUE, 
#                          #collapsed = TRUE,
#                          width = 8, solidHeader = TRUE, status = "warning",height = 90,
#                          selectInput(inputId = "type",
#                                      label = "Kierunek osi wykresu paskowego",
#                                      choices = c("multiBarChart", "multiBarHorizontalChart"),
#                                      selected = "multiBarChart")
#                      ),
                     box(title = "Kto ile dziennie miał like'ów pod postami na fanpage?", collapsible = TRUE, 
                         width = 12, solidHeader = TRUE, status = "warning",
                         showOutput("myChart2", "morris"),
                         
                         selectInput(inputId = "fanpejdz",
                                     label = "Które fanpage uwzględnić?",
                                     choices = c("janusz.korwin.mikke",
                                                 "KomorowskiBronislaw",
                                                 "2MagdalenaOgorek",
                                                 "andrzejduda"),
                                     multiple = TRUE,
                                     selected = c("janusz.korwin.mikke",
                                                  "KomorowskiBronislaw",
                                                  "2MagdalenaOgorek",
                                                  "andrzejduda"))
                         
                     )
                     
                  )
         ),
         tabItem(tabName = "twit",
                 fluidRow(
                 box( title = "Gdzie tweetowano o kandydatach (użytkownicy z włączoną lokalizacją)?", collapsible = TRUE, 
                      width = 12, solidHeader = TRUE, status = "warning", globeOutput("globe")
                 )
                 )
                      
         ),
         tabItem( tabName = "twit2",
                  fluidRow(
                  box(title = "O kim ile dziennie tweetowano?", collapsible = TRUE, 
                      width = 12, solidHeader = TRUE, status = "warning",
                      showOutput("myChart3", "morris"),
                      
                      selectInput(inputId = "tweeet",
                                  label = "Którego kandydata fanpage uwzględnić?",
                                  choices = c("duda",
                                              "komorowski",
                                              "ogorek",
                                              "kukiz"),
                                  multiple = TRUE,
                                  selected = c("duda",
                                               "komorowski",
                                               "ogorek",
                                               "kukiz"))
                      
                  )
                  )
         ),
         tabItem(tabName = "opis",
                 h2("Autorzy: Marcina Kosinskiego, Marta Sommer."),
                 h5("Opis aplikacji i kodów źródłowych można znaleźć tutaj, na dole storny https://github.com/MarcinKosinski/web-scraping")
               )
         )
   )
)

# load("Analizy/Sentyment/doNarysowaniaDygraph.rda")
# load("Analizy/Ilosciowo/barchart.rda")
# load("Analizy/Dzienna_ilosc_like_w_postach/ileLajkow.rda")
# population <- readRDS("Aplikacja/kula.Rds")
# load("Aplikacja/tabela2.rda")
load("doNarysowaniaDygraph.rda")
load("barchart.rda")
load("ileLajkow.rda")
load("tabela2.rda")
population <- readRDS("kula.Rds")


server <- function(input, output) {
#    set.seed(122)
#    histdata <- rnorm(500)
#    
#    output$plot1 <- renderPlot({
#       data <- histdata[seq_len(input$slider)]
#       hist(data)
#    })
#    
   
   output$dajgraf <- renderDygraph({
      dygraph( doNarysowaniaDygraph ) %>%
         dyAxis("y", label = "Emocje" ) %>% 
         dyRangeSelector() %>%
         dyLegend(labelsDiv = "legendDivID") %>%
         dyOptions(colors = c('brown', 'blue', '#594c26', 'green') )
   })
   
   output$myChart <- renderChart({
      
      n1 <- nPlot( count ~ domena, group = "kto", data = WhoAndWhere2Viz,
                   type = input$type)
      n1$addParams(dom = "myChart")
      n1$chart(color = c('brown', '#594c26', 'blue',  'green'))
      return(n1)
      
   })
   
   
   output$myChart3 <- renderChart({
      
      m3 <- mPlot( y="ile_tweetow", x="dzien", group = "kto", type = "Line",
                   data = tabela2 %>%
                      filter( kto %in% input$tweeet))
      m3$addParams(dom = "myChart3")
      m3$set(lineColors=c(   'blue','#594c26','green','brown'))
      return(m3)
      
   })
   

   output$myChart2 <- renderChart({
   
   m1 <- mPlot(x = "daty", y = c("ileLajkowPodWpisami"),
               group = "kandydat", type = "Line", data = ileLajkow %>%
                  filter(kandydat %in% input$fanpejdz))
   m1$set(pointSize = 0, lineWidth = 1)
   m1$addParams(dom = "myChart2")
    m1$set(lineColors=c(   'blue','#594c26','green','brown'))
    #m1$set(ymax=160000) #<- to rujnuje wykresy

   return(m1)
   
   
})
   
   
   
   output$globe <- renderGlobe({
      population
   })
   
   
}

shinyApp(ui, server)
