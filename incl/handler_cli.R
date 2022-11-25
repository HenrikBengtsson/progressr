if (requireNamespace("cli", quietly = TRUE)) local({
  ## Currently, the "cli" progress handler doesn't work
  ## with with_progress() - only with the global handler
  if (!handlers(global = NA) && getRversion() >= "4.0.0") {
    handlers(global = TRUE)
    on.exit(handlers(global = FALSE))
  }

  handlers(handler_cli())
  y <- slow_sum(1:10, message = FALSE)
  print(y)
})
