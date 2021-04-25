source("incl/start.R")

if (requireNamespace("pbmcapply", quietly = TRUE)) {
  handlers("pbmcapply")
  for (x in list(1:10, 1L, integer(0))) {
    message("length(x): ", length(x))
    with_progress({ y <- slow_sum(x) })
    print(y)
  }
}

source("incl/end.R")
