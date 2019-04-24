x <- 1:10

## Without progress updates
y <- slow_sum(x)


## Progress reported via txtProgressBar (default)
if (requireNamespace("utils", quietly = TRUE)) {
  with_progress({
    y <- slow_sum(x)
  })
}

## Progress reported via tcltk::tkProgressBar
if (requireNamespace("tcltk", quietly = TRUE)) {
  with_progress({
    y <- slow_sum(x)
  }, tkprogressbar_handler)
}

## Progress reported via progress::progress_bar)
if (requireNamespace("progress", quietly = TRUE)) {
  with_progress({
    y <- slow_sum(x)
  }, progress_handler)
}

## Progress reported via txtProgressBar + beepr::beep
if (requireNamespace("utils", quietly = TRUE) && requireNamespace("beepr", quietly = TRUE)) {
  with_progress({
    with_progress({
      y <- slow_sum(x)
    }, txtprogressbar_handler(style = 3L))
  }, beepr_handler)
}

## Progress reported via txtProgressBar, beepr::beep, notifier::notify,
## if available.
handlers <- list()
if (requireNamespace("utils", quietly = TRUE)) {
  handlers <- c(handlers, list(txtprogressbar_handler()))
}
if (requireNamespace("beepr", quietly = TRUE)) {
  handlers <- c(handlers, list(beepr_handler()))
}
if (requireNamespace("notifier", quietly = TRUE)) {
  handlers <- c(handlers, list(notifier_handler(times = 3L, interval = 0.1)))
}
oopts <- options(progressr.handlers = handlers)

with_progress({
  y <- slow_sum(1:50)
})

options(oopts)
