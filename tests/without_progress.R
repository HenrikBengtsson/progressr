source("incl/start.R")

message("without_progress() ...")

x <- 1:10
y0 <- slow_sum(x)

with_progress(y <- slow_sum(x))

without_progress(y <- slow_sum(x))

with_progress(without_progress(y <- slow_sum(x)))

message("without_progress() ... done")

source("incl/end.R")
