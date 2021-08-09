#' Creates a Progression Calling Handler
#'
#' A progression calling handler is a function that takes a [base::condition]
#' as its first argument and that can be use together with
#' [base::withCallingHandlers()].  This function helps creating such
#' progression calling handler functions.
#'
#' @param name (character) Name of progression handler.
#'
#' @param reporter (environment) A reporter environment.
#'
#' @param handler (function) Function take a [progression] condition
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
#' @param target (character vector) Specifies where progression updates are
#'   rendered.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()]
#' or not used.
#'
#' @return A function of class `progression_handler` that takes a
#' [progression] condition as its first and only argument.
#'
#' @details
#' The inner details of progression handlers and how to use this function
#' are still to be documented.  Until then, see the source code of existing
#' handlers for how it is used, e.g. `progressr::handler_txtprogressbar`.
#' Please use with care as things might change.
#'
#' @seealso
#' [base::withCallingHandlers()].
#'
#' @keywords internal
#' @export
make_progression_handler <- function(name, reporter = list(), handler = NULL, enable = getOption("progressr.enable", interactive()), enable_after = getOption("progressr.enable_after", 0.0), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0.0), intrusiveness = 1.0, clear = getOption("progressr.clear", TRUE), target = "terminal", ...) {
  enable <- as.logical(enable)
  stop_if_not(is.logical(enable), length(enable) == 1L, !is.na(enable))
  if (!enable) times <- 0
  name <- as.character(name)
  stop_if_not(length(name) == 1L, !is.na(name), nzchar(name))
#  stop_if_not(is.function(handler))
#  formals <- formals(handler)
#  stop_if_not(length(formals) == 1L)
  stop_if_not(is.list(reporter))
  enable_after <- as.numeric(enable_after)
  stop_if_not(is.numeric(enable_after), length(enable_after),
              !is.na(enable_after), enable_after >= 0)
  times <- as.numeric(times)
  stop_if_not(length(times) == 1L, is.numeric(times), !is.na(times),
              times >= 0)
  interval <- as.numeric(interval)
  stop_if_not(length(interval) == 1L, is.numeric(interval),
              !is.na(interval), interval >= 0)
  clear <- as.logical(clear)
  stop_if_not(is.logical(clear), length(clear) == 1L, !is.na(clear))
  stop_if_not(is.character(target))
  
  ## Disable progress updates?
  if (times == 0 || is.infinite(interval) || is.infinite(intrusiveness)) {
    handler <- function(p) NULL
  }

  ## Reporter
  for (key in setdiff(c("reset", "initiate", "update", "finish", "hide", "unhide"), names(reporter))) {
    reporter[[key]] <- structure(function(...) NULL, class = "null_function")
  }

  ## Progress state
  active <- FALSE
  max_steps <- NULL
  step <- NULL
  message <- NULL
  auto_finish <- TRUE
  timestamps <- NULL
  milestones <- NULL
  prev_milestone <- NULL
  finished <- FALSE
  enabled <- FALSE

  ## Progress cache
  owner <- NULL
  done <- list()

  ## Sanity checks
  .validate_internal_state <- function(label = "<no-label>") {
    error <- function(...) {
      msg <- sprintf(...)
      stop(sprintf(".validate_internal_state(%s): %s", sQuote(label), msg))
    }
    if (!is.null(timestamps)) {
      if (length(timestamps) == 0L) {
        error(paste("length(timestamps) == 0L but not is.null(timestamps):",
                    sQuote(deparse(timestamps))))
      }
    }
  }
  
  reporter_args <- function(progression) {
    .validate_internal_state("reporter_args() ... begin")
    
    if (!enabled && !is.null(timestamps)) {
      dt <- difftime(Sys.time(), timestamps[1L], units = "secs")
      enabled <<- (dt >= enable_after)
    }

    config <- list(
      max_steps = max_steps,
      times = times,
      interval = interval,
      enable_after = enable_after,
      auto_finish = auto_finish,
      clear = clear,
      target = target
    )

    state <- list(
      step = step,
      message = message,
      timestamps = timestamps,
      delta = step - prev_milestone,
      enabled = enabled
    )
    if (length(state$delta) == 0L) state$delta <- 0L

    .validate_internal_state("reporter_args() ... end")

    c(config, state, list(
      config = config,
      state = state,
      progression = progression
    ))    
  }

  reset_internal_state <- function() {
    ## Progress state
    active <<- FALSE
    max_steps <<- NULL
    step <<- NULL
    message <<- NULL
    auto_finish <<- TRUE
    timestamps <<- NULL
    milestones <<- NULL
    prev_milestone <<- NULL
    finished <<- FALSE
    enabled <<- FALSE
  
    ## Progress cache
    owner <<- NULL
    done <<- list()
  }

  reset_reporter <- function(p) {
    args <- reporter_args(progression = p)
    debug <- getOption("progressr.debug", FALSE)
    if (debug) {
      mprintf("reset_reporter() ...")
      mstr(args)
    }
    do.call(reporter$reset, args = args)
    .validate_internal_state("reset_reporter() ... done")
    if (debug) mprintf("reset_reporter() ... done")
  }

  initiate_reporter <- function(p) {
    args <- reporter_args(progression = p)
    debug <- getOption("progressr.debug", FALSE)
    if (debug) {
      mprintf("initiate_reporter() ...")
      mstr(args)
    }
    stop_if_not(!isTRUE(active))
    stop_if_not(is.null(prev_milestone), length(milestones) > 0L)
    do.call(reporter$initiate, args = args)
    active <<- TRUE
    finished <<- FALSE
    .validate_internal_state("initiate_reporter() ... done")
    if (debug) mprintf("initiate_reporter() ... done")
  }

  update_reporter <- function(p) {
    args <- reporter_args(progression = p)
    debug <- getOption("progressr.debug", FALSE)
    if (debug) {
      mprintf("update_reporter() ...")
      mstr(args)
    }
    stop_if_not(isTRUE(active))
    stop_if_not(!is.null(step), length(milestones) > 0L)
    do.call(reporter$update, args = args)
    .validate_internal_state("update_reporter() ... done")
    if (debug) mprintf("update_reporter() ... done")
  }

  hide_reporter <- function(p) {
    args <- reporter_args(progression = p)
    debug <- getOption("progressr.debug", FALSE)
    if (debug) {
      mprintf("hide_reporter() ...")
      mstr(args)
    }
#    stop_if_not(isTRUE(active))
    if (is.null(reporter$hide)) {
      if (debug) mprintf("hide_reporter() ... skipping; not supported")
      return()
    }
    do.call(reporter$hide, args = args)
    .validate_internal_state("hide_reporter() ... done")
    if (debug) mprintf("hide_reporter() ... done")
  }

  unhide_reporter <- function(p) {
    args <- reporter_args(progression = p)
    debug <- getOption("progressr.debug", FALSE)
    if (debug) {
      mprintf("unhide_reporter() ...")
      mstr(args)
    }
#    stop_if_not(isTRUE(active))
    if (is.null(reporter$unhide)) {
      if (debug) mprintf("unhide_reporter() ... skipping; not supported")
      return()
    }
    do.call(reporter$unhide, args = args)
    .validate_internal_state("unhide_reporter() ... done")
    if (debug) mprintf("unhide_reporter() ... done")
  }

  finish_reporter <- function(p) {
    args <- reporter_args(progression = p)
    debug <- getOption("progressr.debug", FALSE)
    if (debug) {
      mprintf("finish_reporter() ...")
      mstr(args)
    }

    ## Signal 'finish' if active and not already finished
    ## because it could already have been auto-finished before
    if (active && !finished) {
      do.call(reporter$finish, args = args)
    } else {
      if (debug) message("- Hmm ... got a request to 'finish' handler, but it's not active. Oh well, will finish it then")
    }
    
    reset_internal_state()
    finished <<- TRUE
    if (debug) message("- owner: ", deparse(owner))
    .validate_internal_state("finish_reporter() ... done")
    if (debug) mprintf("finish_reporter() ... done")
  }

  is_owner <- function(p) {
    progressor_uuid <- p[["progressor_uuid"]]
    if (is.null(owner)) owner <<- progressor_uuid
    (owner == progressor_uuid)
  }

  is_duplicated <- function(p) {
    progressor_uuid <- p[["progressor_uuid"]]
    session_uuid <- p[["session_uuid"]]
    progression_index <- p[["progression_index"]]
    progression_time <- p[["progression_time"]]
    progression_id <- sprintf("%s-%d-%s", session_uuid, progression_index, progression_time)
    db <- done[["progressor_uuid"]]
    res <- is.element(progression_id, db)
    if (!res) {
      db <- c(db, progression_id)
      done[["progressor_uuid"]] <<- db
    }
    res
  }
  
  if (is.null(handler)) {
    handler <- function(p) {
      stop_if_not(inherits(p, "progression"))

      ## Ignore if running in a forked child process
      if (is_fork_child()) return(invisible(FALSE))
      
      if (inherits(p, "control_progression")) {
        type <- p[["type"]]
        if (type == "reset") {
          reset_internal_state()
          reset_reporter(p)
          .validate_internal_state(sprintf("handler(type=%s) ... end", type))
        } else if (type == "shutdown") {
          finish_reporter(p)
          .validate_internal_state(sprintf("handler(type=%s) ... end", type))
        } else if (type == "hide") {
          hide_reporter(p)
          .validate_internal_state(sprintf("handler(type=%s) ... end", type))
        } else if (type == "unhide") {
          unhide_reporter(p)
          .validate_internal_state(sprintf("handler(type=%s) ... end", type))
        } else {
          stop("Unknown control_progression type: ", sQuote(type))
        }
        .validate_internal_state(sprintf("control_progression ... end", type))
        return(invisible(finished))
      }        

      debug <- getOption("progressr.debug", FALSE)

      ## Ignore stray progressions coming from other sources, e.g.
      ## a function of a package that started to report on progression.
      if (!is_owner(p)) {
        if (debug) message("- not owner of this progression. Skipping")
        return(invisible(finished))
      }
      
      duplicated <- is_duplicated(p)
      
      type <- p[["type"]]
      if (debug) {
        mprintf("Progression calling handler %s ...", sQuote(type))
        mprintf("- progression:")
        mstr(p)
        mprintf("- progressor_uuid: %s", p[["progressor_uuid"]])
        mprintf("- progression_index: %s", p[["progression_index"]])
        mprintf("- duplicated: %s", duplicated)
      }

      if (duplicated) {
        if (debug) mprintf("Progression calling handler %s ... condition already done", sQuote(type))
        return(invisible(finished))
      } else if (active && finished) {
        if (debug) mprintf("Progression calling handler %s ... active but already finished", sQuote(type))
        return(invisible(finished))
      }

      if (type == "initiate") {
        if (active) {
          if (debug) message("- cannot 'initiate' handler, because it is already active")
          return(invisible(finished))
        }
        max_steps <<- p[["steps"]]
        if (debug) mstr(list(max_steps=max_steps))
        stop_if_not(!is.null(max_steps), is.numeric(max_steps), length(max_steps) == 1L, max_steps >= 0)
        auto_finish <<- p[["auto_finish"]]
        times <- min(times, max_steps)
        if (debug) mstr(list(auto_finish = auto_finish, times = times, interval = interval, intrusiveness = intrusiveness))
        
        ## Adjust 'times' and 'interval' according to 'intrusiveness'
        times <- min(c(times / intrusiveness, max_steps), na.rm = TRUE)
        times <- max(times, 1L)
        interval <- interval * intrusiveness
        if (debug) mstr(list(times = times, interval = interval))

        ## Milestone steps that need to be reach in order to trigger an
        ## update of the reporter
        milestones <<- if (times == 1L) {
          c(max_steps)
        } else if (times == 2L) {
          c(0L, max_steps)
        } else {
          seq(from = 0L, to = max_steps, length.out = times + 1L)[-1]
        }

        ## Timestamps for when steps where reached
        ## Note that they will remain NA for "skipped" steps
        timestamps <<- rep(as.POSIXct(NA), times = max_steps)
        timestamps[1] <<- Sys.time()
        
        step <<- 0L
        message <<- character(0L)
        if (debug) mstr(list(finished = finished, milestones = milestones))
        initiate_reporter(p)
        prev_milestone <<- step
        .validate_internal_state(sprintf("handler(type=%s) ... end", type))
      } else if (type == "finish") {
        if (debug) mstr(list(finished = finished, milestones = milestones))
        finish_reporter(p)
        .validate_internal_state("type=finish")
      } else if (type == "update") {
        if (!active) {
          if (debug) message("- cannot 'update' handler, because it is not active")
          return(invisible(finished))
        }
        if (debug) mstr(list(step=step, "p$amount"=p[["amount"]], "p$step"=p[["step"]], max_steps=max_steps))
        if (!is.null(p[["step"]])) {
          ## Infer effective 'amount' from previous 'step' and p$step
          p[["amount"]] <- p[["step"]] - step
        }
        step <<- min(max(step + p[["amount"]], 0L), max_steps)
        stop_if_not(step >= 0L)
        msg <- conditionMessage(p)
        if (length(msg) > 0) message <<- msg
        if (step > 0) timestamps[step] <<- Sys.time()
        if (debug) mstr(list(finished = finished, step = step, milestones = milestones, prev_milestone = prev_milestone, interval = interval))
        .validate_internal_state("type=update")

        ## Only update if a new milestone step has been reached ...
        ## ... or if we want to send a zero-amount update
        if ((length(milestones) > 0L && step >= milestones[1]) ||
            p[["amount"]] == 0) {
          skip <- FALSE
          if (interval > 0 && step > 0) {
            dt <- difftime(timestamps[step], timestamps[max(prev_milestone, 1L)], units = "secs")
            skip <- (dt < interval)
            if (debug) mstr(list(dt = dt, timestamps[step], timestamps[prev_milestone], skip = skip))
          }
          if (!skip) {
            if (debug) mstr(list(milestones = milestones))
            update_reporter(p)
            if (p[["amount"]] > 0) prev_milestone <<- step
          }
          if (p[["amount"]] > 0) {
            milestones <<- milestones[milestones > step]
            if (auto_finish && step == max_steps) {
              if (debug) mstr(list(type = "finish (auto)", milestones = milestones))
              finish_reporter(p)
            }
          }
        }
        .validate_internal_state(sprintf("handler(type=%s) ... end", type))
      } else {
        stop("Unknown 'progression' type: ", sQuote(type))
      }

      ## Sanity checks
      .validate_internal_state(sprintf("handler() ... end", type))

      if (debug) mprintf("Progression calling handler %s ... done", sQuote(type))
      invisible(finished)
    } ## handler()
  }

  class(handler) <- c(sprintf("%s_progression_handler", name),
                      "progression_handler", "calling_handler",
                      class(handler))
      
  handler
}


#' @export
print.progression_handler <- function(x, ...) {
  print(sys.calls())
  s <- sprintf("Progression calling handler of class %s:", sQuote(class(x)[1]))
  
  env <- environment(x)
  s <- c(s, " * configuration:")
  s <- c(s, sprintf("   - name: %s", sQuote(env$name %||% "<NULL>")))
  s <- c(s, sprintf("   - max_steps: %s", env$max_steps %||% "<NULL>"))
  s <- c(s, sprintf("   - enable: %s", env$enable))
  s <- c(s, sprintf("   - enable_after: %g seconds", env$enable_after))
  s <- c(s, sprintf("   - times: %g", env$times))
  s <- c(s, sprintf("   - interval: %g seconds", env$interval))
  s <- c(s, sprintf("   - intrusiveness: %g", env$intrusiveness))
  s <- c(s, sprintf("   - auto_finish: %s", env$auto_finish))
  s <- c(s, sprintf("   - clear: %s", env$clear))
  s <- c(s, sprintf("   - target: %s", paste(sQuote(env$target), collapse = ", ")))
  s <- c(s, sprintf("   - milestones: %s", hpaste(env$milestones %||% "<NULL>")))
  s <- c(s, sprintf("   - owner: %s", hpaste(env$owner %||% "<NULL>")))

  s <- c(s, " * state:")
  s <- c(s, sprintf("   - enabled: %s", env$enabled))
  s <- c(s, sprintf("   - finished: %s", env$finished))
  s <- c(s, sprintf("   - step: %s", env$step %||% "<NULL>"))
  s <- c(s, sprintf("   - message: %s", env$message %||% "<NULL>"))
  s <- c(s, sprintf("   - prev_milestone: %s", env$prev_milestone %||% "<NULL>"))
  s <- c(s, sprintf("   - delta: %g", (env$step - env$prev_milestone) %||% 0L))
  s <- c(s, sprintf("   - timestamps: %s", hpaste(env$timestamps %||% "<NULL>")))

  s <- paste(s, collapse = "\n")
  cat(s, "\n", sep = "")
}


# Additional arguments passed to the progress backend
handler_backend_args <- function(...) {
  args <- list(...)
  if (length(args) == 0L) return(list())
  
  names <- names(args)
  if (is.null(names) || !all(nzchar(names))) {
    stop("Additional arguments must be named")
  }
  
  ## Drop arguments passed to make_progression_handler()
  names <- setdiff(names, names(formals(make_progression_handler)))
  args[names]
}

