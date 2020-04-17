source("incl/start.R")

options(progressr.clear = FALSE)

message("Multiple handlers ...")

delay <- getOption("progressr.demo.delay", 0.1)
message("- delay: ", delay, " seconds")

handlers(handler_txtprogressbar(clear = FALSE))

x <- 1:5
stdout <- c()
bfr <- utils::capture.output({
  with_progress({
    p <- progressor(along = x)
    for (ii in x) {
      msg <- sprintf("ii = %d\n", ii)
      stdout <- c(stdout, msg)
      cat(msg)
      Sys.sleep(delay)
      p(message = sprintf("(%s)", paste(letters[1:ii], collapse=",")))
    }
  })
})
cat(bfr, sep="\n")

## Validate stdout
bfr <- paste(c(bfr, ""), collapse="\n")
stdout <- paste(stdout, collapse="")
stopifnot(bfr == stdout)

message("Multiple handlers ... done")

source("incl/end.R")
