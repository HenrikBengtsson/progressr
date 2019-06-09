library(progressr)
options(progressr.interval = 0.0, progressr.delay = 0.01)

if (requireNamespace("furrr", quietly = TRUE)) {
  with_progress({
    p <- progressor(10)
    y <- furrr::future_map(1:10, function(x) {
      p()
      slow_sum(x, stdout=TRUE, message=TRUE)
    })
  })
}
