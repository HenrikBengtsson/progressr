source("incl/start.R")

if (requireNamespace("future.apply", quietly = TRUE)) {
  future::plan("multiprocess")
  with_progress({
    p <- progressor(4)
    y <- future.apply::future_lapply(3:6, function(n) {
      p()
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    })
  })
}

source("incl/end.R")
