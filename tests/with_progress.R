library(progressr)

message("with_progress() ...")

## Function that takes time to run
my_sum <- function(x = 1:10) {
  res <- 0
  progress(type = "setup", steps = length(x))
  
  for (kk in seq_along(x)) {
    Sys.sleep(0.1)
    res <- res + x[kk]
    progress()
  }
  
  progress(type = "done")
  
  res
}


message("with_progress() - void ...")

## Mute progress updates
with_progress({
  sum <- my_sum(1:10)
}, renderer = NULL)
print(sum)
stopifnot(sum == 55L)

message("with_progress() - void ... done")


message("with_progress() - utils::txtProgressBar() ...")

if (requireNamespace("utils")) {
  ## Display progress using default renderer
  with_progress({
    sum <- my_sum(1:10)
  })
  print(sum)
  
  ## Display progress using default renderer
  with_progress({
    sum <- my_sum(1:10)
  }, renderer = renderer_txtprogressbar)
  print(sum)
}

message("with_progress() - utils::txtProgressBar() ... done")

  
message("with_progress() - progress::progress_bar() ...")

if (requireNamespace("progress")) {
  ## Display progress using default renderer
  with_progress({
    sum <- my_sum(1:10)
  }, renderer = renderer_progress(clear = FALSE))
  print(sum)
}

message("with_progress() - progress::progress_bar() ... done")


message("with_progress() ... done")
