#' @export
progression_handler <- function(name, handler, times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0)) {
  name <- as.character(name)
  stop_if_not(length(name) == 1L, !is.na(name), nzchar(name))
  stop_if_not(is.function(handler))
  formals <- formals(handler)
  stop_if_not(length(formals) == 1L)
  stop_if_not(length(times) == 1L, is.numeric(times), !is.na(name),
              times >= 0)
  stop_if_not(length(interval) == 1L, is.numeric(interval),
              !is.na(interval), interval >= 0)

  ## Disable progress updates?
  if (times == 0 || is.infinite(interval)) {
    handler <- function(p) NULL
  }

  class(handler) <- c(sprintf("%s_progression_handler", name),
                      "progression_handler", class(handler))

  handler
}
