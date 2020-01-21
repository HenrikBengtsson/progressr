source("incl/start.R")

options(progressr.clear = FALSE)

message("handler_shiny ...")

h <- handler_shiny()
print(h)

message("handler_shiny ... done")

source("incl/end.R")
