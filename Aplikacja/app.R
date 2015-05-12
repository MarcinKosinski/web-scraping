## app.R ##
library(shinydashboard)
library(shiny)
library(dygraphs)
library(rCharts)
library(dplyr)
ui <- dashboardPage(
   dashboardHeader(title = "Wybory w internecie"),
   dashboardSidebar(
      sidebarMenu(
         menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
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
                        dygraphOutput("dajgraf", height = 400)
                     ),

                      box(title = "Kto o kim pisał?", collapsible = TRUE, 
                          width = 8, solidHeader = TRUE, status = "warning",
                         showOutput("myChart", "nvd3")
                      ),
                     box(title = "Legenda", textOutput("legendDivID"), collapsible = TRUE,
                         collapsed = TRUE,
                         width = 4, solidHeader = TRUE, status = "warning", height = 20),
                     box(title = "Kierunek osi", collapsible = TRUE, 
                         collapsed = TRUE,
                         width = 8, solidHeader = TRUE, status = "warning",  height = 20,
                         selectInput(inputId = "type",
                                     label = "Kierunek osi wykresu paskowego",
                                     choices = c("multiBarChart", "multiBarHorizontalChart"),
                                     selected = "multiBarChart")
                     )
                     
                  )
         ),
         
         tabItem(tabName = "opis",
                 h2("To aplikacja Marty Sommer i Marcina Kosinskiego"),
                 h5("Proba pisania heheszki")
               )
         )
   )
)

load("Analizy/Sentyment/doNarysowaniaDygraph.rda")
load("Analizy/Ilosciowo/barchart.rda")

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
   
   
}

shinyApp(ui, server)
