library(progressr)
options(progressr.interval = 0.0, delay = 0.01)

if (requireNamespace("plyr", quietly = TRUE)) {
  with_progress({
    y <- plyr::l_ply(3:6, function(n, ...) {
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    }, .progress = "progressr")
  })
}
