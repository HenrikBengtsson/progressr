if (requireNamespace("tcltk", quietly = TRUE)) local({
  oopts <- options(progressr.clear = FALSE,
                   progressr.handlers = tkprogressbar_handler)
  on.exit(oopts)

  x <- 1:10
  with_progress({ y <- slow_sum(x) })
  
  print(y)
})
