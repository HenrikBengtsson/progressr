library(progressr)
options(progressr.interval = 0.0, progressr.delay = 0.01)

if (requireNamespace("doFuture", quietly = TRUE)) {
  library("doFuture", character.only = TRUE)
  registerDoFuture()
  with_progress({
    y <- foreach(x = 1:10) %dopar% {
      slow_sum(x, stdout=TRUE, message=TRUE)
    }
  })
}
