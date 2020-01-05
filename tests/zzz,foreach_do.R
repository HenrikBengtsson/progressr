source("incl/start.R")

if (requireNamespace("foreach", quietly = TRUE)) {
  library("doFuture", character.only = TRUE)
  with_progress({
    p <- progressor(4)
    y <- foreach(n = 3:6) %do% {
      p()
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    }
  })
}

source("incl/end.R")
