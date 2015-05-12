## app.R ##
library(shinydashboard)
library(shiny)
library(dygraphs)
ui <- dashboardPage(
   dashboardHeader(title = "Wybory w internecie"),
   dashboardSidebar(
      sidebarMenu(
         menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
         menuItem("Opis", tabName = "opis", icon = icon("th"))
      )
   ),
   dashboardBody(
      tabItems(
         # First tab content
         tabItem(tabName = "dashboard",
      # Boxes need to be put in a row (or column)
      fluidRow(
         box(plotOutput("plot1", height = 250)),
         
         box(
            title = "Controls",
            sliderInput("slider", "Number of observations:", 1, 100, 50)
         ),   
         box(
            dygraphOutput("dajgraf", height = 400)
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

server <- function(input, output) {
   set.seed(122)
   histdata <- rnorm(500)
   
   output$plot1 <- renderPlot({
      data <- histdata[seq_len(input$slider)]
      hist(data)
   })
   
   
   output$dajgraf <- renderDygraph({
      dygraph( doNarysowaniaDygraph, main = "Analiza sentymentu" ) %>%
         dyAxis("y", label = "Emocje" )
   })
   
}

shinyApp(ui, server)