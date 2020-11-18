source("incl/start.R")

if (requireNamespace("doFuture", quietly = TRUE)) {
  library("doFuture", character.only = TRUE)
  registerDoFuture()
  
  for (strategy in c("sequential", "multisession", "multicore")) {
    future::plan(strategy)
    print(future::plan())
    
    message("* with_progress()")
    
    with_progress({
      p <- progressor(4)
      y <- foreach(n = 3:6) %dopar% {
        p()
        slow_sum(1:n, stdout=TRUE, message=TRUE)
      }
    })


    message("* global progression handler")

    register_global_progression_handler("add")
    
    local({
      p <- progressor(4)
      y <- foreach(n = 3:6) %dopar% {
        p()
        slow_sum(1:n, stdout=TRUE, message=TRUE)
      }
    })
    
    register_global_progression_handler("remove")
  }
}

source("incl/end.R")
