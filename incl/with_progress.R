x <- 1:10

## Without progress updates
y <- slow_sum(x)

## With progress updates
## Progress reported via txtProgressBar (default)
if (requireNamespace("utils", quietly = TRUE)) {
  with_progress({
    y <- slow_sum(x)
  })
}

## With progress updates
## Reported via tcltk::tkProgressBar)
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

## Progress reported via beepr::beep)
if (requireNamespace("beepr", quietly = TRUE)) {
  with_progress({
    y <- slow_sum(x)
  }, beepr_handler)
}
