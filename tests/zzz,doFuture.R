source("incl/start.R")

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

source("incl/end.R")
