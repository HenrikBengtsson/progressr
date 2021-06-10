source("incl/start.R")

options(progressr.clear = FALSE)

message("txtprogressbar ...")

for (style in 1:3) {
  message(sprintf("- style = %d ...", style))
  handlers(handler_txtprogressbar(style = style))
  
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
  
  message(sprintf("- style = %d ... done", style))
}

message("txtprogressbar ... done")

source("incl/end.R")
