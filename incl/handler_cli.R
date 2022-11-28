if (requireNamespace("cli", quietly = TRUE)) local({
  ## with_progress() on a "cli" handler gives an error if a
  ## global progressing handler is set.
  if (getRversion() >= "4.0.0" && handlers(global = NA)) {
    handlers(global = FALSE)
    on.exit(handlers(global = TRUE))
  }
  
  handlers(handler_cli())
  with_progress({ y <- slow_sum(1:10) })
  print(y)
})
