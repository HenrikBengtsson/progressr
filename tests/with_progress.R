library(progressr)

options(delay = 0.01)
options(progressr.handler = NULL)
options(progressr.times = Inf)

message("with_progress() ...")

x <- 1:20
truth <- sum(x)

message("with_progress() - utils::txtProgressBar() ...")

if (requireNamespace("utils")) {
  with_progress({
    sum <- slow_sum(x)
  }, handler = txtprogressbar_handler)
  print(sum)
  stopifnot(sum == truth)
}

message("with_progress() - utils::txtProgressBar() ... done")


message("with_progress() - default ...")

if (requireNamespace("utils")) {
  with_progress({
    sum <- slow_sum(x)
  })
  print(sum)
  stopifnot(sum == truth)
}

message("with_progress() - default ... done")

message("with_progress() - tcltk::tkProgressBar() ...")

if (requireNamespace("tcltk")) {
  with_progress({
    sum <- slow_sum(x)
  }, handler = tkprogressbar_handler)
}

message("with_progress() - tcltk::tkProgressBar() ... done")


message("with_progress() - progress::progress_bar() ...")

if (requireNamespace("progress")) {
  ## Display progress using default handler
  with_progress({
    sum <- slow_sum(x)
  }, handler = progress_handler(clear = FALSE))
  print(sum)
  stopifnot(sum == truth)
}

message("with_progress() - progress::progress_bar() ... done")


message("with_progress() - alert ...")

## Mute progress updates
with_progress({
  sum <- slow_sum(x)
}, handler = ascii_alert_handler)
print(sum)
stopifnot(sum == truth)

message("with_progress() - alert ... done")


message("with_progress() - beepr::beep() ...")

## Mute progress updates
with_progress({
  sum <- slow_sum(x)
}, handler = beepr_handler)
print(sum)
stopifnot(sum == truth)

message("with_progress() - beepr::beep() ... done")


message("with_progress() - void ...")

## Mute progress updates
with_progress({
  sum <- slow_sum(x)
}, handler = NULL)
print(sum)
stopifnot(sum == truth)

message("with_progress() - void ... done")


message("with_progress() ... done")
