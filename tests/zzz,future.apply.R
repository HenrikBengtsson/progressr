library(progressr)
options(progressr.interval = 0.0, progressr.delay = 0.01)

if (requireNamespace("future.apply", quietly = TRUE)) {
  with_progress({
    y <- future.apply::future_lapply(1:10, function(x) {
      slow_sum(x, stdout=TRUE, message=TRUE)
    })
  })
}
