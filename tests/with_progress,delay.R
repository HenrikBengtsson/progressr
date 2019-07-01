library(progressr)

options(progressr.tests.fake_handlers = c("beepr_handler", "notifier_handler", "pbmcapply_handler", "tkprogressbar_handler", "winprogressbar_handler"))
options(progressr.enable = TRUE)

options(progressr.delay = 0.001)
options(progressr.times = +Inf)
options(progressr.interval = 0)
options(progressr.clear = FALSE)

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

x <- 1:5

## Record truth
output_truth <- record_output({
 y_truth <- slow_sum(x, stdout=TRUE, message=TRUE)
})

for (delay in c(FALSE, TRUE)) {
  message(sprintf("- with_progress() - delay = %s ...", delay))
  output <- record_output({
    with_progress({
     y <- slow_sum(x, stdout=TRUE, message=TRUE)
    }, delay_stdout = delay,
       delay_conditions = if (delay) "condition" else character(0L))
  })
  stopifnot(identical(output$stdout, output_truth$stdout))
  stopifnot(identical(output$conditions, output_truth$conditions))
  stopifnot(identical(y, y_truth))
  message(sprintf("- with_progress() - delay = %s ... DONE", delay))
}

message("*** with_progress() - delaying output ... DONE")
