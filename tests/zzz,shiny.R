source("incl/start.R")

if (requireNamespace("shiny", quietly = TRUE)) {
  ## This will generate:
  ## Error in shiny::withProgress(expr, ..., env = env, quoted = TRUE) : 
  ## 'session' is not a ShinySession object.
  res <- tryCatch({
    withProgressShiny({
      p <- progressor(3L)
      y <- lapply(1:3, function(n) {
        p()
        slow_sum(1:n, stdout=TRUE, message=TRUE)
      })
      y
    })
  }, error = identity)
  print(res)
}

source("incl/end.R")
