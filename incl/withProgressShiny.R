library(shiny)
library(progressr)

app <- shinyApp(
  ui = fluidPage(
    plotOutput("plot")
  ),

  server = function(input, output) {
    output$plot <- renderPlot({
      X <- 1:15
      withProgressShiny(message = "Calculation in progress",
                        detail = "This may take a while ...", value = 0, {
        p <- progressor(along = X)
        y <- lapply(X, FUN=function(x) {
          p()
          Sys.sleep(0.25)
        })
      })
      
      plot(cars)

      ## Terminate the Shiny app
      Sys.sleep(1.0)
      stopApp(returnValue = invisible())
    })
  }
)

local({
  oopts <- options(device.ask.default = FALSE)
  on.exit(options(oopts))
  if (interactive()) print(app)
})
