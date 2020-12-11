source("incl/start.R")

options(progressr.demo.delay = 0.001)
options(progressr.interval = 0.0)
options(progressr.clear = FALSE)

message("with_progress() ...")

x <- 1:100
truth <- sum(x)

message("with_progress() - default ...")

if (requireNamespace("utils")) {
  with_progress({
    sum <- slow_sum(x)
  })
  print(sum)
  stopifnot(sum == truth)

  with_progress({
    cat("This stdout output will be delayed")
    message("This message will be delayed")
    warning("This warning will be delayed")
    signalCondition(simpleCondition("This simpleCondition will be delayed"))
    sum <- slow_sum(x)
  }, interval = 0.1, enable = TRUE, delay_conditions = "condition")
  print(sum)
  stopifnot(sum == truth)
}

message("with_progress() - default ... done")

message("with_progress() - filesize ...")

with_progress({
  sum <- slow_sum(x)
}, handlers = handler_filesize())
print(sum)
stopifnot(sum == truth)

message("with_progress() - filesize ... done")


message("with_progress() - utils::txtProgressBar() ...")

if (requireNamespace("utils")) {
  with_progress({
    sum <- slow_sum(x)
  }, handlers = handler_txtprogressbar(style = 2L))
  print(sum)
  stopifnot(sum == truth)
}

message("with_progress() - utils::txtProgressBar() ... done")


message("with_progress() - tcltk::tkProgressBar() ...")

with_progress({
  sum <- slow_sum(x)
}, handlers = handler_tkprogressbar)

message("with_progress() - tcltk::tkProgressBar() ... done")


message("with_progress() - utils::winProgressBar() ...")

with_progress({
  sum <- slow_sum(x)
}, handlers = handler_winprogressbar)

message("with_progress() - utils::winProgressBar() ... done")


message("with_progress() - progress::progress_bar() ...")

if (requireNamespace("progress")) {
  ## Display progress using default handler
  with_progress({
    sum <- slow_sum(x)
  }, handlers = handler_progress(clear = FALSE))
  print(sum)
  stopifnot(sum == truth)
}

message("with_progress() - progress::progress_bar() ... done")


message("with_progress() - pbmcapply::progressBar() ...")

with_progress({
  sum <- slow_sum(x)
}, handlers = handler_pbmcapply)

message("with_progress() - pbmcapply::progressBar() ... done")


message("with_progress() - ascii_alert ...")

with_progress({
  sum <- slow_sum(x)
}, handlers = handler_ascii_alert())
print(sum)
stopifnot(sum == truth)

message("with_progress() - ascii_alert ... done")


message("with_progress() - beepr::beep() ...")

with_progress({
  sum <- slow_sum(x)
}, handlers = handler_beepr)
print(sum)
stopifnot(sum == truth)

message("with_progress() - beepr::beep() ... done")


message("with_progress() - notifier::notify() ...")

with_progress({
  sum <- slow_sum(x)
}, handlers = handler_notifier)
print(sum)
stopifnot(sum == truth)

message("with_progress() - notifier::notify() ... done")


message("with_progress() - void ...")

## Mute progress updates
with_progress({
  sum <- slow_sum(x)
}, handlers = NULL)
print(sum)
stopifnot(sum == truth)

message(" - via option")

## NOTE: Set it to NULL, will use the default utils::txtProgressBar()
options(progressr.handlers = list())
with_progress({
  sum <- slow_sum(x)
})
print(sum)
stopifnot(sum == truth)

message("with_progress() - void ... done")


message("with_progress() - multiple handlers ...")

if (requireNamespace("utils", quietly = TRUE)) {
  handlers <- list(handler_txtprogressbar, handler_newline, handler_debug)
  options(progressr.handlers = handlers)
  
  with_progress({
    sum <- slow_sum(x)
  })
  print(sum)
  stopifnot(sum == truth)
}

message("with_progress() - multiple handlers ... done")


message("with_progress() - return value and visibility ...")

res <- with_progress(x)
stopifnot(identical(x, res))

res <- withVisible(with_progress(x))
stopifnot(identical(res$visible, TRUE))

res <- withVisible(with_progress(y <- x))
stopifnot(identical(res$visible, FALSE))

message("with_progress() - return value and visibility ... done")


message("with_progress() ... done")

source("incl/end.R")
