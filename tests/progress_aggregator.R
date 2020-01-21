source("incl/start.R")

message("progress_aggregator() ...")

with_progress({
  progress <- progressor(steps = 1 + 3 + 10 + 1)
  relay_progress <- progress_aggregator(progress)
  progress()
  relay_progress(slow_sum(1:3))
  relay_progress(slow_sum(1:10))
  progress()
})



message("- Stray progressions from unknown sources")

slow_prod <- function(x, delay = getOption("progressr.demo.delay", 0.05)) {
  progress <- progressor(2*length(x))
  res <- 0
  for (kk in seq_along(x)) {
    progress(message = sprintf("Multiplying %g", kk))
    Sys.sleep(0.8*delay)
    res <- res * x[kk]
    progress(message = "...")
    Sys.sleep(0.2*delay)
  }
  res
}

## This will only show progress for the *first* of the three
## functions that report progress. Any progression updates from
## the second and third will be ignored, because they are from
## a different source
with_progress({
  x <- 1:10
  a <- slow_sum(x)
  b <- slow_prod(x)
  c <- slow_sum(-x)
})


## To get progression from all of them, we need to know how many
## steps they report on and then use a gather-and-relay handler
with_progress({
  x <- 1:10
  progress <- progressor(3*length(x))
  relay_progress <- progress_aggregator(progress)
  relay_progress({
    a <- slow_sum(x)
    b <- slow_prod(x)
    c <- slow_sum(-x)
  })
})


message("progress_aggregator() ... done")

source("incl/end.R")
