if (requireNamespace("progress", quietly = TRUE)) {
  handlers(handler_progress(format = ":spin [:bar] :percent :message"))
  with_progress({ y <- slow_sum(1:10) })
  print(y)
}
