source("incl/start.R")

if (requireNamespace("future.apply", quietly = TRUE)) {
  for (strategy in c("sequential", "multisession", "multicore")) {
    future::plan(strategy)
    print(future::plan())
    
    with_progress({
      p <- progressor(4)
      y <- future.apply::future_lapply(3:6, function(n) {
        p()
        slow_sum(1:n, stdout=TRUE, message=TRUE)
      })
    })
  }
}

source("incl/end.R")
