source("incl/start.R")

options(progressr.clear = FALSE)

if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  options(progressr.handlers = handler_rstudio)
}  

message("handler_rstudio() ...")

for (x in list(1:10, 1L, integer(0))) {
  message("length(x): ", length(x))
  with_progress({
    progress <- progressor(along = x)
    for (ii in x) {
      Sys.sleep(getOption("progressr.demo.delay", 0.1))
      progress(message = sprintf("(%s)", paste(letters[1:ii], collapse="")))
    }
  })
}

message("handler_rstudio() ... done")

source("incl/end.R")
