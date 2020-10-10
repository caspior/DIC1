library(shiny)
library(leaflet)

ui <- fluidPage(
  titlePanel("Difference in average daily shared scooter trips in Austin, Texas by census tract during the Covid-19 pandemic"),
  selectInput("trips", "Trip direction:", c("Departures" = "dep", "Arrivals" = "arr")),
  sliderInput("month_b", 'Choose the "before" month', value = 3, min = 3, max = 10),
  sliderInput("month_a", 'Choose the "after" month', value = 4, min = 3, max = 10),
  leafletOutput("map")
)

server <- function(input, output){
  library(tigris)
  
  tracts <- tracts("TX", "Travis", year="2019")
  trips <- read.csv("https://raw.githubusercontent.com/caspior/DIC1/main/trips.csv")
  
  output$map <- renderLeaflet({
    diff <- trips[which(trips$month == input$month_b),]
    diff <- merge(diff, trips[which(trips$month == input$month_a),], by="census_geoid_start", all=T)
    diff[is.na(diff)] <- 0
    diff$dep <- diff$dep.y - diff$dep.x
    diff$arr <- diff$arr.y - diff$arr.x
    austin <- geo_join(tracts, diff, "GEOID", "census_geoid_start")
    
    map <- leaflet(austin) %>% addTiles()
    bins <- c(-Inf, -100, -10, -1, 0, 1, 10, 100, Inf)
    
    if (input$trips == "dep") {
      pal <- colorBin("YlOrRd", domain=austin$dep, bins=bins)
        map %>%
          setView(-97.741, 30.27, 11) %>%
          addPolygons(
            fillColor = ~pal(dep),
            weight = 2,
            opacity = 1,
            color = "white",
            dashArray = "3",
            fillOpacity = 0.7,
            highlight = highlightOptions(
              weight = 5,
              color = "#666",
              dashArray = "",
              fillOpacity = 0.7,
              bringToFront = TRUE),
          label = austin$dep,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto")) %>%
          addLegend(pal = pal, values = ~dep, opacity = 0.7, title = NULL,
                    position = "bottomright")
    }
    else {
      pal <- colorBin("YlOrRd", domain=austin$arr, bins=bins)
      map %>%
        setView(-97.741, 30.27, 11) %>%
        addPolygons(
          fillColor = ~pal(arr),
          weight = 2,
          opacity = 1,
          color = "white",
          dashArray = "3",
          fillOpacity = 0.7,
          highlight = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE),
          label = austin$arr,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            direction = "auto")) %>%
        addLegend(pal = pal, values = ~arr, opacity = 0.7, title = NULL,
                  position = "bottomright")
    }
  })
}

shinyApp(ui, server)