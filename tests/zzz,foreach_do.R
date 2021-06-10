source("incl/start.R")

if (require("foreach", quietly = TRUE)) {
  message("* with_progress()")
    
  with_progress({
    p <- progressor(4)
    y <- foreach(n = 3:6) %do% {
      p()
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    }
  })

  message("* global progression handler")

  handlers(global = TRUE)
    
  local({
    p <- progressor(4)
    y <- foreach(n = 3:6) %do% {
      p()
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    }
  })
    
  handlers(global = FALSE)
}

source("incl/end.R")
