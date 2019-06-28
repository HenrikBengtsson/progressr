library(progressr)

options(progressr.delay = 0.01)
options(progressr.times = +Inf)
options(progressr.interval = 0.2)
options(progressr.clear = FALSE)
delay <- getOption("progressr.delay", 0.5)

if (requireNamespace("progress", quietly = TRUE)) {
  options(progressr.handlers = progress_handler)
}  

x <- 1:10

message("progress_handler() ...")

with_progress({
  progress <- progressor(length(x))
  for (ii in x) {
    Sys.sleep(delay)
    progress(message = sprintf("(%s)", paste(letters[1:ii], collapse="")))
  }
})

message("progress_handler() ... done")
