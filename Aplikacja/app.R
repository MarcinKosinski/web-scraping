## app.R ##
library(shinydashboard)
library(shiny)
library(dygraphs)
library(rCharts)
library(dplyr)
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
                         #collapsed = TRUE,
                         width = 4, solidHeader = TRUE, status = "warning"),
                     box(title = "Kierunek osi", collapsible = TRUE, 
                         #collapsed = TRUE,
                         width = 8, solidHeader = TRUE, status = "warning",
                         selectInput(inputId = "type",
                                     label = "Kierunek osi wykresu paskowego",
                                     choices = c("multiBarChart", "multiBarHorizontalChart"),
                                     selected = "multiBarChart")
                     ),
                     box(title = "Kto ile dziennie miał like'ów?", collapsible = TRUE, 
                         width = 12, solidHeader = TRUE, status = "warning",
                         showOutput("myChart2", "morris")
                        
                         
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
load("Analizy/Dzienna_ilosc_like_w_postach/ileLajkow.rda")


ePlot <- function(x, y, data, group, type, colors, ...){
   require(rCharts); require(plyr)
   if (!missing(group)){
      series = setNames(dlply(data, group, function(d){
         list(
            name = d[[group]][1],
            type = type,
            data = d[[y]],
            ...
         )
      }), NULL) 
   }
   xAxis = list(
      type = 'category',
      data = unique(data[[x]])
   )
   legend = list(
      data = unique(data[[group]])
   )
   if (!missing(colors)){
      series = lapply(seq_along(series), function(i){
         series[[i]]$itemStyle = list(normal = list(color = colors[i]))
         return(series[[i]])
      })
   }
   r1 <- rCharts$new()
   r1$setLib('echarts')
   r1$set(series = series, xAxis = xAxis, legend = legend)
   r1
}



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

   output$myChart2 <- renderChart({
   
   m1 <- mPlot(x = "daty", y = c("ileLajkowPodWpisami"),
               group = "kandydat", type = "Line", data = ileLajkow)
   m1$set(pointSize = 0, lineWidth = 1)
   m1$addParams(dom = "myChart2")
#   m1$chart(color = c('brown', '#594c26', 'blue',  'green'))
   return(m1)
   
   
})
   
   
}

shinyApp(ui, server)
