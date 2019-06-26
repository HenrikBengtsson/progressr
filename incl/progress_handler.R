if (requireNamespace("progress", quietly = TRUE)) {
  handlers("progress")
  with_progress({ y <- slow_sum(1:10) })
  print(y)
}
