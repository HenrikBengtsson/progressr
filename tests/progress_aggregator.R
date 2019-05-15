library(progressr)

options(delay = 0.0)

message("progress_aggregator() ...")

with_progress({
  progress <- progressor(steps = 4L)
  relay_progress <- progress_aggregator(progress)
  progress()
  relay_progress(slow_sum(1:3))
  relay_progress(slow_sum(1:10))
  progress()
})

message("progress_aggregator() ... done")
