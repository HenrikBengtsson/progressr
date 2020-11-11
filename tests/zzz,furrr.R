source("incl/start.R")

if (requireNamespace("furrr", quietly = TRUE)) {
  for (strategy in c("sequential", "multisession", "multicore")) {
    future::plan(strategy)
    print(future::plan())
    
    with_progress({
      p <- progressor(4)
      y <- furrr::future_map(3:6, function(n) {
        p()
        slow_sum(1:n, stdout=TRUE, message=TRUE)
      })
    })
  }
}

source("incl/end.R")
