library(progressr)
options(progressr.interval = 0.0, progressr.delay = 0.01)

if (requireNamespace("doFuture", quietly = TRUE)) {
  library("doFuture", character.only = TRUE)
  registerDoFuture()
  future::plan("multiprocess")
  with_progress({
    p <- progressor(4)
    y <- foreach(n = 3:6) %dopar% {
      p()
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    }
  })
}
