source("incl/start.R")

message("without_progress() ...")

x <- 1:10
y0 <- slow_sum(x)

with_progress(y <- slow_sum(x))

without_progress(y <- slow_sum(x))

with_progress(without_progress(y <- slow_sum(x)))

message("without_progress() ... done")


message("without_progress() - return value and visibility ...")

res <- without_progress(x)
stopifnot(identical(x, res))

res <- withVisible(without_progress(x))
stopifnot(identical(res$visible, TRUE))

res <- withVisible(without_progress(y <- x))
stopifnot(identical(res$visible, FALSE))

message("without_progress() - return value and visibility ... done")


source("incl/end.R")
