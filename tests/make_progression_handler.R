source("incl/start.R")

options(progressr.debug = TRUE)

message("make_progression_handler() ...")

my_handler <- function(symbol = "*", file = stderr(), target = "terminal", ...) {
  reporter <- local({
    list(
      update = function(config, state, progression, ...) {
        if (state$enabled && progression$amount != 0) cat(file = file, symbol)
      }
    )
  })

  make_progression_handler("my_handler", reporter, ...)
}

h1 <- my_handler()
print(h1)

h2 <- my_handler(enable = FALSE)
print(h2)

message("make_progression_handler() ... done")

source("incl/end.R")
