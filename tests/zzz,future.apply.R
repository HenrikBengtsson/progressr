library(progressr)
options(progressr.interval = 0.0, delay = 0.1)
options(progressr.enable = TRUE)

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
