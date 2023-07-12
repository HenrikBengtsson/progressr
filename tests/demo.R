source("incl/start.R")

library(future)

supportedStrategies <- function(cores = NA_integer_, excl = "cluster", ...) {
  strategies <- future:::supportedStrategies(...)
  strategies <- setdiff(strategies, excl)
  if (!is.na(cores)) {
    if (cores == 1L) {
      strategies <- setdiff(strategies, c("multicore", "multisession"))
    } else if (cores > 1L) {
      strategies <- setdiff(strategies, "sequential")
    }
  }
  
  strategies
}

isWin32 <- FALSE
availCores <- 2L

message("*** Demos ...")

message("*** Mandelbrot demo ...")

if (!isWin32) {
  options(future.demo.mandelbrot.nrow = 2L)
  options(future.demo.mandelbrot.resolution = 50L)
  options(future.demo.mandelbrot.delay = FALSE)
  
  for (cores in 1:availCores) {
    message(sprintf("Testing with %d cores ...", cores))
    options(mc.cores = cores)
  
    for (strategy in supportedStrategies(cores)) {
      message(sprintf("- plan('%s') ...", strategy))
      plan(strategy)
      demo("mandelbrot", package = "progressr", ask = FALSE)
      
      ## Explicitly close any PSOCK clusters to avoid 'R CMD check' NOTE
      ## on "detritus in the temp directory" on MS Windows
      plan(sequential)
      
      message(sprintf("- plan('%s') ... DONE", strategy))
    }
  
    message(sprintf("Testing with %d cores ... DONE", cores))
  } ## for (cores ...)
} else {
  message(" - This demo requires R (>= 3.2.0). Skipping test. (Skipping also on Win32 i386 for speed)")
}

message("*** Mandelbrot demo ... DONE")

message("*** Demos ... DONE")

source("incl/end.R")
