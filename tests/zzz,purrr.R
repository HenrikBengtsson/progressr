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

  register_global_progression_handler("add")
   
  local({
    p <- progressor(4)
    y <- purrr::map(3:6, function(n) {
#      p()
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    })
  })
    
  register_global_progression_handler("remove")
}

source("incl/end.R")
