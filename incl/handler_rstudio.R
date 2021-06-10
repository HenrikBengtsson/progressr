if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {

  handlers("rstudio")
  with_progress({ y <- slow_sum(1:10) })
  print(y)
  
}
