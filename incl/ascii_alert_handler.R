if (requireNamespace("utils", quietly = TRUE)) local({
  oopts <- options(progressr.clear = FALSE,
                   progressr.handlers = ascii_alert_handler)
  on.exit(oopts)

  x <- 1:10
  with_progress({ y <- slow_sum(x) })
  
  print(y)
})
