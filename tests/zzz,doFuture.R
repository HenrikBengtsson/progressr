source("incl/start.R")

if (requireNamespace("doFuture", quietly = TRUE)) {
  library("doFuture", character.only = TRUE)
  registerDoFuture()
  
  for (strategy in future_strategies) {
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

    handlers(global = TRUE)
    
    local({
      p <- progressor(4)
      y <- foreach(n = 3:6) %dopar% {
        p()
        slow_sum(1:n, stdout=TRUE, message=TRUE)
      }
    })
    
    handlers(global = FALSE)
    
    ## Explicitly close any PSOCK clusters to avoid 'R CMD check' NOTE
    ## on "detritus in the temp directory" on MS Windows
    future::plan("sequential")
  } ## for (strategy ...)
}

source("incl/end.R")
