make_calling_handler <- function(handlers) {
  if (length(handlers) > 1L) {
    calling_handler <- function(p) {
      finished <- FALSE
      for (kk in seq_along(handlers)) {
        handler <- handlers[[kk]]
        if (handler(p)) finished <- TRUE
      }
      finished
    }
  } else {
    calling_handler <- handlers[[1]]
  }
  calling_handler
}
