source("incl/start.R")

if (requireNamespace("plyr", quietly = TRUE)) {
  message("* with_progress()")

  with_progress({
    y <- plyr::llply(3:6, function(n, ...) {
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    }, .progress = "progressr")
  })



  message("* global progression handler")

  register_global_progression_handler("add")
    
  local({
    y <- plyr::llply(3:6, function(n, ...) {
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    }, .progress = "progressr")
  })
    
  register_global_progression_handler("remove")
}

source("incl/end.R")
