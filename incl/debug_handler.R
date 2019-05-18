local({
  oopts <- options(progressr.clear = FALSE,
                   progressr.handlers = debug_handler)
  on.exit(oopts)

  x <- 1:10
  with_progress({ y <- slow_sum(x) })
  
  print(y)
})
