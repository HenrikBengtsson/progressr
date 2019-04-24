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

  with_progress({
    y <- slow_sum(x)
  }, list(txtprogressbar_handler(style = 1L), beepr_handler))
}
