source("incl/start.R")

if (requireNamespace("pbmcapply", quietly = TRUE)) {
  handlers("pbmcapply")
  with_progress({ y <- slow_sum(1:10) })
  print(y)
}

source("incl/end.R")
