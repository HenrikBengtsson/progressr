library(progressr)

options(progressr.debug = TRUE)
options(progressr.enable = TRUE)
options(progressr.times = +Inf)
options(progressr.interval = 0.1)
options(delay = 0.0)

message("with_progress() - progressr.debug = TRUE ...")

with_progress({
  y <- slow_sum(1:10)
})

with_progress({
  progress <- progressor(steps = 1 + 2 + 1)
  relay_progress <- progress_aggregator(progress)
  p <- progress()
  progressr::progress(p) ## duplicated - will be ignored
  relay_progress(slow_sum(1:2))
  progress(type = "finish")
  progress() ## one too many - will be ignored
})

message("with_progress() - progressr.debug = TRUE ... done")
