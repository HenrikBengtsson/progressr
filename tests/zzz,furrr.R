source("incl/start.R")

if (requireNamespace("furrr", quietly = TRUE)) {
  for (strategy in future_strategies) {
    future::plan(strategy)
    print(future::plan())

    message("* with_progress()")

    with_progress({
      p <- progressor(4)
      y <- furrr::future_map(3:6, function(n) {
        p()
        slow_sum(1:n, stdout=TRUE, message=TRUE)
      })
    })


    message("* global progression handler")

    handlers(global = TRUE)
    
    local({
      p <- progressor(4)
      y <- furrr::future_map(3:6, function(n) {
        p()
        slow_sum(1:n, stdout=TRUE, message=TRUE)
      })
    })
    
    handlers(global = FALSE)
    
    ## Explicitly close any PSOCK clusters to avoid 'R CMD check' NOTE
    ## on "detritus in the temp directory" on MS Windows
    future::plan("sequential")
  } ## for (strategy ...)
}

source("incl/end.R")
