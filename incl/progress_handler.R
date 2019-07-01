if (requireNamespace("progress", quietly = TRUE)) {
  handlers(progress_handler(format = ":spin [:bar] :percent :message"))
  with_progress({ y <- slow_sum(1:10) })
  print(y)
}
