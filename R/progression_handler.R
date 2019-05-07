#' Creates a Progression Handler
#'
#' @param name (character) Name of progression handler.
#'
#' @param reporter (environment) A reporter environment.
#'
#' @param handler (function) Function take a `progression` condition
#'   as the first argument.
#'
#' @param times (integer) The maximum number of times this handler
#'   should report progression updates.
#'
#' @param interval (numeric) The minimum time (in seconds) between
#'   successive progression updates from this handler.
#'
#' @return A function of class `progression_handler`.
#'
#' @export
progression_handler <- function(name, reporter = environment(), handler = NULL, times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0)) {
  name <- as.character(name)
  stop_if_not(length(name) == 1L, !is.na(name), nzchar(name))
#  stop_if_not(is.function(handler))
#  formals <- formals(handler)
#  stop_if_not(length(formals) == 1L)
  stop_if_not(is.environment(reporter))
  stop_if_not(length(times) == 1L, is.numeric(times), !is.na(name),
              times >= 0)
  stop_if_not(length(interval) == 1L, is.numeric(interval),
              !is.na(interval), interval >= 0)

  ## Disable progress updates?
  if (times == 0 || is.infinite(interval)) {
    handler <- function(p) NULL
  }

  ## Reporter
  for (name in setdiff(c("setup", "update", "done"), names(reporter))) {
    reporter[[name]] <- function(...) NULL
  }

  ## Progress state
  max_steps <- NULL
  step <- 0L
  milestones <- NULL
  prev_milestone <- 0L
  prev_milestone_time <- Sys.time()

  if (is.null(handler)) {
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      type <- p$type
      if (type == "setup") {
        max_steps <<- p$steps
        reporter$max_steps <- max_steps
        times <- min(times, max_steps)
        milestones <<- seq(from = 1L, to = max_steps, length.out = times)
        step <<- 0L
        reporter$step <- 0L
        reporter$setup()
        prev_milestone <<- step
        milestones <<- milestones[-1]
        prev_milestone_time <<- Sys.time()
      } else if (type == "done") {
        reporter$done(max_steps - prev_milestone)
        prev_milestone <<- max_steps
        prev_milestone_time <<- Sys.time()
      } else if (type == "update") {
        step <<- step + p$amount
        reporter$step <- step
        if (length(milestones) > 0L && step >= milestones[1]) {
          skip <- FALSE
          if (interval > 0) {
  	  dt <- difftime(Sys.time(), prev_milestone_time, units = "secs")
            skip <- (dt < interval)
          }
  	if (!skip) {
            reporter$update(step - prev_milestone)
            milestones <<- milestones[-1]
            prev_milestone <<- step
            prev_milestone_time <<- Sys.time()
  	}
        }
      } else {
        warning("Unknown 'progression' type: ", sQuote(type))
      }      
    }
  }

  class(handler) <- c(sprintf("%s_progression_handler", name),
                      "progression_handler", class(handler))

  handler
}
