library(progressr)
options(progressr.interval = 0.0, delay = 0.1)

if (requireNamespace("furrr", quietly = TRUE)) {
  future::plan("multiprocess")
  with_progress({
    p <- progressor(4)
    y <- furrr::future_map(3:6, function(n) {
      p()
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    })
  })
}
