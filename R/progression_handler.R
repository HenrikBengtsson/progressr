#' Creates a Progression Handler
#'
#' @param name (character) Name of progression handler.
#'
#' @param reporter (environment) A reporter environment.
#'
#' @param handler (function) Function take a `progression` condition
#'   as the first argument.
#'
#' @param intrusiveness (numeric) A non-negative scalar on how intrusive
#'   (disruptive) the reporter to the user.
#'
#' @param enable (logical) If FALSE, then progress is not reported.
#'
#' @param enable_after (numeric) Delay (in seconds) before progression
#'   updates are reported.
#'
#' @param times (numeric) The maximum number of times this handler
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
progression_handler <- function(name, reporter = list(), handler = NULL, enable = interactive(), enable_after = 0.0, times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0), intrusiveness = 1.0, clear = getOption("progressr.clear", TRUE)) {
  if (!enable) times <- 0
  name <- as.character(name)
  stop_if_not(length(name) == 1L, !is.na(name), nzchar(name))
#  stop_if_not(is.function(handler))
#  formals <- formals(handler)
#  stop_if_not(length(formals) == 1L)
  stop_if_not(is.list(reporter))
  stop_if_not(is.numeric(enable_after), length(enable_after),
              !is.na(enable_after), enable_after >= 0)
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
  finished <- FALSE
  enabled <- FALSE
  
  reporter_args <- function(message, progression) {
    if (!enabled && !is.null(timestamps)) {
      dt <- difftime(Sys.time(), timestamps[1L], units = "secs")
      enabled <<- (dt >= enable_after)
    }

    config <- list(
      max_steps = max_steps,
      enable_after = enable_after,
      clear = clear
    )

    state <- list(
      step = step,
      message = message,
      timestamps = timestamps,
      delta = step - prev_milestone,
      enabled = enabled
    )
    if (length(state$delta) == 0L) state$delta <- 0L

    c(config, state, list(
      config = config,
      state = state,
      progression = progression
    ))
  }

  initiate_reporter <- function(p) {
    args <- reporter_args(message = p$message, progression = p)
    debug <- getOption("progressr.debug", FALSE)
    if (debug) {
      mprintf("initiate_reporter() ...")
      mstr(args)
    }
    stop_if_not(is.null(prev_milestone), length(milestones) > 0L)
    do.call(reporter$initiate, args = args)
    finished <<- FALSE
    if (debug) mprintf("initiate_reporter() ... done")
  }

  update_reporter <- function(p) {
    args <- reporter_args(message = p$message, progression = p)
    debug <- getOption("progressr.debug", FALSE)
    if (debug) {
      mprintf("update_reporter() ...")
      mstr(args)
    }
    stop_if_not(!is.null(step), length(milestones) > 0L)
    do.call(reporter$update, args = args)
    if (debug) mprintf("update_reporter() ... done")
  }

  finish_reporter <- function(p) {
    args <- reporter_args(message = p$message, progression = p)
    debug <- getOption("progressr.debug", FALSE)
    if (debug) {
      mprintf("finish_reporter() ...")
      mstr(args)
    }
    do.call(reporter$finish, args = args)
    finished <<- TRUE
    if (debug) mprintf("finish_reporter() ... done")
  }

  is_owner <- local({
    owner <- NULL
    function(p) {
      progressor_uuid <- p$progressor_uuid
      if (is.null(owner)) owner <<- progressor_uuid
      (owner == progressor_uuid)
    }
  })

  is_duplicated <- local({
    done <- list()
    function(p) {
      progressor_uuid <- p$progressor_uuid
      session_uuid <- p$session_uuid
      progression_index <- p$progression_index
      progression_id <- sprintf("%s-%d", session_uuid, progression_index)
      db <- done[[progressor_uuid]]
      res <- is.element(progression_id, db)
      if (!res) {
        db <- c(db, progression_id)
        done[[progressor_uuid]] <<- db
      }
      res
    }
  })
  
  if (is.null(handler)) {
    handler <- function(p) {
      stopifnot(inherits(p, "progression"))

      if (inherits(p, "control_progression") && p$type == "shutdown") {
        finish_reporter(p)
	return(invisible())
      }

      ## Ignore stray progressions coming from other sources, e.g.
      ## a function of a package that started to report on progression.
      if (!is_owner(p)) return(FALSE)
      
      duplicated <- is_duplicated(p)
      
      type <- p$type
      debug <- getOption("progressr.debug", FALSE)
      if (debug) {
        mprintf("Progression handler %s ...", sQuote(type))
        mprintf("- progression:")
        mstr(p)
        mprintf("- progressor_uuid: %s", p$progressor_uuid)
        mprintf("- progression_index: %s", p$progression_index)
        mprintf("- duplicated: %s", duplicated)
      }

      if (duplicated) {
        mprintf("Progression handler %s ... already done", sQuote(type))
        return(invisible())
      } else if (finished) {
        mprintf("Progression handler %s ... already finished", sQuote(type))
        return(invisible())
      }

      if (type == "initiate") {
        max_steps <<- p$steps
        auto_finish <<- p$auto_finish
        times <- min(times, max_steps)
        if (debug) mstr(list(auto_finish = auto_finish, times = times, interval = interval, intrusiveness = intrusiveness))
        
        ## Adjust 'times' and 'interval' according to 'intrusiveness'
        times <- max(min(times / intrusiveness, max_steps), 2L)
        interval <- interval * intrusiveness
        
        milestones <<- seq(from = 1L, to = max_steps, length.out = times)
        timestamps <<- rep(as.POSIXct(NA), times = max_steps)
        timestamps[1] <<- Sys.time()
        step <<- 0L
        if (debug) mstr(list(finished = finished, milestones = milestones))
        initiate_reporter(p)
        prev_milestone <<- step
      } else if (type == "finish") {
        if (debug) mstr(list(finished = finished, milestones = milestones))
        finish_reporter(p)
        timestamps[max_steps] <<- Sys.time()
        prev_milestone <<- max_steps
      } else if (type == "update") {
        step <<- min(max(step + p$amount, 0L), max_steps)
        timestamps[step] <<- Sys.time()
        if (debug) mstr(list(finished = finished, step = step, milestones = milestones, prev_milestone = prev_milestone, interval = interval))
        if (length(milestones) > 0L && step >= milestones[1]) {
          skip <- FALSE
          if (interval > 0) {
            dt <- difftime(timestamps[step], timestamps[max(prev_milestone, 1L)], units = "secs")
            skip <- (dt < interval)
            if (debug) mstr(list(dt = dt, timestamps[step], timestamps[prev_milestone], skip = skip))
          }
          if (!skip) {
            if (debug) mstr(list(milestones = milestones))
            update_reporter(p)
            prev_milestone <<- step
          }
          milestones <<- milestones[milestones > step]
          if (auto_finish && step == max_steps) {
            if (debug) mstr(list(type = "finish (auto)", milestones = milestones))
            finish_reporter(p)
          }
        }
      } else {
        stop("Unknown 'progression' type: ", sQuote(type))
      }
      
      if (debug) mprintf("Progression handler %s ... done", sQuote(type))
    }
  }

  class(handler) <- c(sprintf("%s_progression_handler", name),
                      "progression_handler", class(handler))

  handler
}
