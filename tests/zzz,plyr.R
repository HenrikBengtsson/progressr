source("incl/start.R")

if (requireNamespace("plyr", quietly = TRUE)) {
  with_progress({
    y <- plyr::llply(3:6, function(n, ...) {
      slow_sum(1:n, stdout=TRUE, message=TRUE)
    }, .progress = "progressr")
  })
}

source("incl/end.R")
