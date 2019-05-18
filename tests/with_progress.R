library(progressr)

options(progressr.tests.fake_handlers = c("beepr_handler", "notifier_handler", "tkprogressbar_handler", "winprogressbar_handler"))
options(progressr.enable = TRUE)

options(delay = 0.001)

options(progressr.times = +Inf)
options(progressr.interval = 0)
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
}

message("with_progress() - default ... done")

message("with_progress() - utils::txtProgressBar() ...")

if (requireNamespace("utils")) {
  with_progress({
    sum <- slow_sum(x)
  }, txtprogressbar_handler)
  print(sum)
  stopifnot(sum == truth)
}

message("with_progress() - utils::txtProgressBar() ... done")


message("with_progress() - tcltk::tkProgressBar() ...")

with_progress({
  sum <- slow_sum(x)
}, tkprogressbar_handler)

message("with_progress() - tcltk::tkProgressBar() ... done")


message("with_progress() - utils::winProgressBar() ...")

with_progress({
  sum <- slow_sum(x)
}, winprogressbar_handler)

message("with_progress() - utils::winProgressBar() ... done")


message("with_progress() - progress::progress_bar() ...")

if (requireNamespace("progress")) {
  ## Display progress using default handler
  with_progress({
    sum <- slow_sum(x)
  }, progress_handler(clear = FALSE))
  print(sum)
  stopifnot(sum == truth)
}

message("with_progress() - progress::progress_bar() ... done")


message("with_progress() - alert ...")

with_progress({
  sum <- slow_sum(x)
}, ascii_alert_handler())
print(sum)
stopifnot(sum == truth)

message("with_progress() - alert ... done")


message("with_progress() - beepr::beep() ...")

with_progress({
  sum <- slow_sum(x)
}, beepr_handler)
print(sum)
stopifnot(sum == truth)

message("with_progress() - beepr::beep() ... done")


message("with_progress() - notifier::notify() ...")

with_progress({
  sum <- slow_sum(x)
}, notifier_handler)
print(sum)
stopifnot(sum == truth)

message("with_progress() - notifier::notify() ... done")


message("with_progress() - void ...")

## Mute progress updates
with_progress({
  sum <- slow_sum(x)
}, NULL)
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
  handlers <- list(txtprogressbar_handler, newline_handler, debug_handler)
  options(progressr.handlers = handlers)
  
  with_progress({
    sum <- slow_sum(x)
  })
  print(sum)
  stopifnot(sum == truth)
}

message("with_progress() - multiple handlers ... done")


message("with_progress() ... done")
