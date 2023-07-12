source("incl/start.R")

options(progressr.tests.fake_handlers = c("handler_beepr", "handler_notifier", "handler_pbmcapply", "handler_tkprogressbar", "handler_winprogressbar"))
options(progressr.clear = FALSE)
options(progressr.enable_after = NULL)
options(progressr.debug = FALSE)
options(progressr.times = NULL)

record_output <- function(expr, envir = parent.frame()) {
  conditions <- list()
  stdout <- utils::capture.output({
    withCallingHandlers(
      expr,
      condition = function(c) {
        if (inherits(c, c("progression", "error"))) return()
        conditions[[length(conditions) + 1L]] <<- c
      }
    )
  }, split = TRUE)
  list(stdout = stdout, conditions = conditions)
}


message("*** with_progress() - delaying output ...")

x <- 1:10

## Record truth
output_truth <- record_output({
  y_truth <- slow_sum(x, stdout = TRUE, message = TRUE, sticky = TRUE)
})

for (delay in c(FALSE, TRUE)) {
  message(sprintf("- with_progress() - delay = %s ...", delay))
  output <- record_output({
    with_progress({
      y <- slow_sum(x, stdout = TRUE, message = TRUE, sticky = TRUE)
    }, delay_stdout = delay,
      delay_conditions = if (delay) "condition" else character(0L))
  })
  stopifnot(identical(output$stdout, output_truth$stdout))
  stopifnot(identical(output$conditions, output_truth$conditions))
  stopifnot(identical(y, y_truth))
  message(sprintf("- with_progress() - delay = %s ... DONE", delay))
}

message("*** with_progress() - delaying output ... DONE")

source("incl/end.R")
