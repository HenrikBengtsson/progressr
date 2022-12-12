source("incl/start.R")

options(progressr.clear = FALSE)

if (requireNamespace("cli", quietly = TRUE)) {
  options(progressr.handlers = handler_cli)
}  

message("handler_cli() ...")

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

message("handler_cli() ... done")

source("incl/end.R")
