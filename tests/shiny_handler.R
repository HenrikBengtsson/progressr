source("incl/start.R")

options(progressr.clear = FALSE)

message("shiny_handler ...")

h <- shiny_handler()
print(h)

message("shiny_handler ... done")

source("incl/end.R")
