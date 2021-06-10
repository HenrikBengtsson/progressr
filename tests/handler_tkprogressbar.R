source("incl/start.R")

options(progressr.clear = FALSE)

if (capabilities("tcltk") && requireNamespace("tcltk", quietly = TRUE)) {
  options(progressr.handlers = handler_tkprogressbar)
}  


message("handler_progress() ...")

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

message("handler_progress() ... done")

source("incl/end.R")
