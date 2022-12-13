if (requireNamespace("cli", quietly = TRUE)) {
  handlers(handler_cli(format = "{cli::pb_spin} {cli::pb_bar} {cli::pb_percent} {cli::pb_status}"))
  with_progress({ y <- slow_sum(1:10) })
  print(y)
}
