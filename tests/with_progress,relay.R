source("incl/start.R")

options(progressr.clear = TRUE)

delay <- getOption("progressr.demo.delay", 0.1)
message("- delay: ", delay, " seconds")

handlers("txtprogressbar")

handlers <- supported_progress_handlers()


message("with_progress() - standard output, messages, warnings ...")

n <- 5L
for (kk in seq_along(handlers)) {
  handler <- handlers[[kk]]
  name <- names(handlers)[kk]
  message(sprintf("* Handler %d ('%s') of %d ...", kk, name, length(handlers)))

  for (type in c("message", "warning")) {
    message(sprintf("  - stdout + %ss", type))
    for (delta in c(0L, +1L, -1L)) {
      message(sprintf("    - delta = %+d", delta))
      truth <- c()
      relay <- record_relay({
        with_progress({
          p <- progressor(n)
          for (ii in seq_len(n + delta)) {
            ## Zero-amount progress with empty message
            p(amount = 0)
            msg <- sprintf("ii = %d", ii)
            ## Zero-amount progress with non-empty message
            p(message = msg, amount = 0)
            truth <<- c(truth, msg)
            cat(msg, "\n", sep = "")
            ## Signal condition
            do.call(type, args = list(msg))
            Sys.sleep(delay)
            ## One-step progress with non-empty message
            p(message = sprintf("(%s)", paste(letters[1:ii], collapse=",")))
          }
        })
      }, classes = type)
      stopifnot(
        identical(relay$stdout, truth),
        identical(gsub("\n$", "", relay$msgs), truth)
      )
    } ## for (delta ...)
  } ## for (signal ...)

  message(sprintf("* Handler %d ('%s') of %d ... done", kk, name, length(handlers)))
}


message("with_progress() - standard output, messages, warnings ... done")

source("incl/end.R")
