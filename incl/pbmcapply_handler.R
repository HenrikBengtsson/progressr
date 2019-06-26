if (requireNamespace("pbmcapply", quietly = TRUE)) {
  handlers("pbmcapply")
  with_progress({ y <- slow_sum(1:10) })
  print(y)
}
