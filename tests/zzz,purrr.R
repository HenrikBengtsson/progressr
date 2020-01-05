source("incl/start.R")

if (requireNamespace("purrr", quietly = TRUE)) {
  future::plan("multiprocess")
  with_progress({
    p <- progressor(4)
    y <- purrr::map(3:6, function(n) {
      p()
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    })
  })
}

source("incl/end.R")
