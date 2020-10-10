library(shiny)
library(leaflet)

ui <- fluidPage(
  titlePanel("Average daily shared scooter trips in Austin, Texas by census tract during the Covid-19 pandemic"),
  selectInput("trips", "Trip direction:", c("Departures" = "dep", "Arrivals" = "arr")),
  sliderInput("month", "Choose the month", value = 3, min = 3, max = 10),
  leafletOutput("map")
)

server <- function(input, output){
  library(tigris)
  
  tracts <- tracts("TX", "Travis", year="2019")
  trips <- read.csv("https://raw.githubusercontent.com/caspior/DIC1/main/trips.csv")

  output$map <- renderLeaflet({
    austin <- geo_join(tracts, trips[which(trips$month == input$month),], "GEOID", "census_geoid_start")
    leaflet(austin) %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.5,
                fillColor = ~colorQuantile("YlOrRd", dep)(dep),
                highlightOptions = highlightOptions(color = "white", weight = 2,
                                                    bringToFront = TRUE)) %>%
    addTiles()
  })
}

shinyApp(ui, server)