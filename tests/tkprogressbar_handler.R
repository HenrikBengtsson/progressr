source("incl/start.R")

options(progressr.clear = FALSE)

if (capabilities("tcltk") && requireNamespace("tcltk", quietly = TRUE)) {
  options(progressr.handlers = tkprogressbar_handler)
}  

x <- 1:10

message("progress_handler() ...")
with_progress({
  progress <- progressor(along = x)
  for (ii in x) {
    Sys.sleep(getOption("progressr.demo.delay", 0.1))
    progress(message = sprintf("(%s)", paste(letters[1:ii], collapse="")))
  }
})
message("progress_handler() ... done")

source("incl/end.R")
