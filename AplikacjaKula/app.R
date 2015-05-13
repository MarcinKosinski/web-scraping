library(shinydashboard)
library(shinyGlobe)
library(shiny)


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
         menuItem("Kula Tweetów", tabName = "twit", icon = icon("dashboard")),
         menuItem("Wróć", icon = icon("file-code-o"),
                  href = "https://marcinkosinski.shinyapps.io/wp2015/"
         )
      )
   ),
   dashboardBody(
      tabItems(
                  tabItem(tabName = "twit",
                          fluidRow(
                          box( title = "Gdzie tweetowano o kandydatach (użytkownicy z włączoną lokalizacją)?", collapsible = TRUE, 
                               width = 12, solidHeader = TRUE, status = "warning", 
                               tagList(
                                  globeOutput("globe"),
                                  div(id="info", tagList(
                                     HTML(
                                        'Dane dostępne <a href="https://github.com/MarcinKosinski/web-scraping"> tutaj  </a>'
                                     )
                                   
                                  ))
                               )
                          )
                          )
                               
                  )
      )
   )
)
#population <- readRDS("Aplikacja/kula.Rds")
population <- readRDS("kula.Rds")

server <- function(input, output) {
   output$globe <- renderGlobe({
      population
   })
   
}
shinyApp(ui, server)
