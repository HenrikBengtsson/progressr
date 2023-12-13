library(progressr)

message("progress_aggregator() ...")

with_progress({
  progress <- progressor(steps = 8L)
  relay_progress <- progress_aggregator(progress)
  progress()
  relay_progress(slow_sum(1:2))
  relay_progress(slow_sum(1:4))
  progress()
})

message("progress_aggregator() ... done")
