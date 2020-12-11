if (getRversion() >= "4.0.0") {

source("incl/start.R")

nsinks0 <- sink.number(type = "output")

options(progressr.clear = FALSE)

delay <- getOption("progressr.demo.delay", 0.1)
message("- delay: ", delay, " seconds")

handlers("txtprogressbar")

handlers <- supported_progress_handlers()

handlers(global = FALSE)
stopifnot(sink.number(type = "output") == nsinks0)

handlers(global = TRUE)
stopifnot(sink.number(type = "output") == nsinks0)

message("global progress handlers - standard output, messages, warnings ...")

n <- 5L
for (kk in seq_along(handlers)) {
  handler <- handlers[[kk]]
  name <- names(handlers)[kk]
  message(sprintf("* Handler %d ('%s') of %d ...", kk, name, length(handlers)))

  for (type in c("message", "warning")) {
    message(sprintf("  - stdout + %ss", type))
    for (delta in c(0L, +1L, -1L)) {
      message(sprintf("    - delta = %+d", delta))

      handlers(global = FALSE)
      stopifnot(sink.number(type = "output") == nsinks0)
      handlers(global = TRUE)
      stopifnot(sink.number(type = "output") == nsinks0)

      status <- progressr:::register_global_progression_handler("status")
      stopifnot(
        is.null(status$current_progressor_uuid),
        is.null(status$delays),
        is.null(status$stdout_file),
         length(status$conditions) == 0L,
         is.na(status$capture_conditions)
      )

      nsinks <- sink.number(type = "output")
      stopifnot(nsinks == nsinks0)
      
      truth <- c()
      relay <- record_relay(local({
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
      }), classes = type)
      stopifnot(
        identical(relay$stdout, truth),
        identical(gsub("\n$", "", relay$msgs), truth)
      )
      
      ## Assert sinks are balanced
      stopifnot(sink.number(type = "output") == nsinks)
      
      cat(paste(c(relay$stdout, ""), collapse = "\n"))
      message(relay$message, append = FALSE)
      status <- progressr:::register_global_progression_handler("status")
      console_msg(capture.output(utils::str(status)))
      if (delta == 0L) {
        withCallingHandlers({
          stopifnot(
            is.null(status$current_progressor_uuid),
            is.null(status$delays),
            is.null(status$stdout_file),
            length(status$conditions) == 0L,
            is.na(status$capture_conditions)
          )
        }, error = function(ex) {
          console_msg(paste("An error occurred:", conditionMessage(ex)))
          console_msg(capture.output(utils::str(status)))
        })
      }

    } ## for (delta ...)
  } ## for (signal ...)

  message(sprintf("* Handler %d ('%s') of %d ... done", kk, name, length(handlers)))
}


message("global progress handlers - standard output, messages, warnings ... done")

handlers(global = FALSE)

source("incl/end.R")

} ## if (getRversion() >= "4.0.0")
