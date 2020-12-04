source("incl/start.R")

if (requireNamespace("purrr", quietly = TRUE)) {
  message("* with_progress()")

  with_progress({
    p <- progressor(4)
    y <- purrr::map(3:6, function(n) {
      p()
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    })
  })


  message("* global progression handler")

  handlers(global = TRUE)
   
  local({
    p <- progressor(4)
    y <- purrr::map(3:6, function(n) {
      p()
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    })
  })
    
  handlers(global = FALSE)
}

source("incl/end.R")
