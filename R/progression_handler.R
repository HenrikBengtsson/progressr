#' Creates a Progression Handler
#'
#' @param name (character) Name of progression handler.
#'
#' @param reporter (environment) A reporter environment.
#'
#' @param handler (function) Function take a `progression` condition
#'   as the first argument.
#'
#' @param intrusiveness (numeric) A positive scalar on how intrusive
#'   (disruptive) the reporter to the user.
#'
#' @param enable (logical) If FALSE, then progress is not reported.
#'
#' @param times (integer) The maximum number of times this handler
#'   should report progression updates.
#'   If zero, then progress is not reported.
#'
#' @param interval (numeric) The minimum time (in seconds) between
#'   successive progression updates from this handler.
#'
#' @param clear (logical) If TRUE, any output, typically visual, produced
#'   by a reporter will be cleared/removed upon completion, if possible.
#'
#' @return A function of class `progression_handler`.
#'
#' @export
progression_handler <- function(name, reporter = list(), handler = NULL, enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0), intrusiveness = 1.0, clear = TRUE) {
  if (!enable) times <- 0L
  name <- as.character(name)
  stop_if_not(length(name) == 1L, !is.na(name), nzchar(name))
#  stop_if_not(is.function(handler))
#  formals <- formals(handler)
#  stop_if_not(length(formals) == 1L)
  stop_if_not(is.list(reporter))
  stop_if_not(length(times) == 1L, is.numeric(times), !is.na(name),
              times >= 0)
  stop_if_not(length(interval) == 1L, is.numeric(interval),
              !is.na(interval), interval >= 0)

  ## Disable progress updates?
  if (times == 0 || is.infinite(interval) || is.infinite(intrusiveness)) {
    handler <- function(p) NULL
  }

  ## Reporter
  for (name in setdiff(c("initiate", "update", "finish"), names(reporter))) {
    reporter[[name]] <- function(...) NULL
  }

  ## Progress state
  max_steps <- NULL
  step <- NULL
  auto_finish <- TRUE
  timestamps <- NULL
  milestones <- NULL
  prev_milestone <- NULL

  if (is.null(handler)) {
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))
      type <- p$type
      debug <- getOption("progressr.debug", FALSE)
      if (type == "initiate") {
        max_steps <<- p$steps
        auto_finish <<- p$auto_finish
        times <- min(times, max_steps)
	if (debug) mstr(list(type = type, auto_finish = auto_finish, times = times, interval = interval, intrusiveness = intrusiveness))
	
        ## Adjust 'times' and 'interval' according to 'intrusiveness'
        times <- max(times / intrusiveness, 2L)
        interval <- interval * intrusiveness
	
        milestones <<- seq(from = 1L, to = max_steps, length.out = times)
	timestamps <<- rep(as.POSIXct(NA), times = max_steps)
	timestamps[1] <<- Sys.time()
        step <<- 0L
	args <- list(max_steps = max_steps, step = step, delta = step - prev_milestone, message = p$message, clear = clear, timestamps = timestamps)
	if (debug) mstr(list(type = type, args = args, milestones = milestones))
        do.call(reporter$initiate, args = args)
        prev_milestone <<- step
        milestones <<- milestones[-1]
      } else if (type == "finish") {
	args <- list(max_steps = max_steps, step = step, delta = step - prev_milestone, message = p$message, clear = clear, timestamps = timestamps)
	if (debug) mstr(list(type = type, args = args, milestones = milestones))
        do.call(reporter$finish, args = args)
	timestamps[max_steps] <<- Sys.time()
        prev_milestone <<- max_steps
      } else if (type == "update") {
        step <<- step + p$amount
	timestamps[step] <<- Sys.time()
        if (debug) mstr(list(type = type, step = step, milestones = milestones))
        if (length(milestones) > 0L && step >= milestones[1]) {
          skip <- FALSE
          if (interval > 0) {
            dt <- difftime(timestamps[step], timestamps[max(prev_milestone, 1L)], units = "secs")
            skip <- (dt < interval)
            if (debug) mstr(list(type = type, step = step, milestones = milestones, prev_milestone = prev_milestone, interval = interval, dt = dt, timestamps[step], timestamps[prev_milestone], skip = skip))
          }
          if (!skip) {
            args <- list(max_steps = max_steps, step = step, delta = step - prev_milestone, message = p$message, clear = clear, timestamps = timestamps)
            if (debug) mstr(list(type = type, args = args, milestones = milestones))
            do.call(reporter$update, args = args)
            milestones <<- milestones[-1]
            prev_milestone <<- step
	    if (auto_finish && step == max_steps) {
              args <- list(max_steps = max_steps, step = max_steps, delta = 0L, message = p$message, clear = clear, timestamps = timestamps)
              if (debug) mstr(list(type = "finish (auto)", args = args, milestones = milestones))
              do.call(reporter$finish, args = args)
	    }
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
