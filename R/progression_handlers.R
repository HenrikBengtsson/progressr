#' Auditory Progression Feedback
#'
#' @export
ascii_alert_handler <- function(symbol = "\a", ..., enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0.5), file = stderr()) {
  if (!enable) times <- 0

  reporter <- local({
    list(
      update = function(step, max_steps, delta, message) {
        cat(file = file, symbol)
      }
    )
  })

  progression_handler("ascii_alert", reporter, times = times, interval = interval)
}



#' Visual Progression Feedback
#'
#' @export
txtprogressbar_handler <- function(..., enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0), file = stderr()) {
  if (!enable) times <- 0
  
  reporter <- local({
    ## Import functions
    txtProgressBar <- utils::txtProgressBar
    getTxtProgressBar <- utils::getTxtProgressBar
    setTxtProgressBar <- utils::setTxtProgressBar

    pb <- NULL

    list(
      setup = function(step, max_steps, delta, message) {
        pb <<- txtProgressBar(max = max_steps, ..., file = file)
      },
        
      update = function(step, max_steps, delta, message) {
        setTxtProgressBar(pb, value = step)
      },
        
      done = function(step, max_steps, delta, message) {
        close(pb)
      }
    )
  })
  
  progression_handler("txtprogressbar", reporter, times = times, interval = interval)
}



#' Visual Progression Feedback
#'
#' @export
tkprogressbar_handler <- function(..., enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0)) {
  if (!enable) times <- 0

  reporter <- local({
    ## Import functions
    tkProgressBar <- tcltk::tkProgressBar
    getTkProgressBar <- tcltk::getTkProgressBar
    setTkProgressBar <- tcltk::setTkProgressBar

    pb <- NULL
    
    list(
      setup = function(step, max_steps, delta, message) {
        pb <<- tkProgressBar(max = max_steps, ...)
      },
        
      update = function(step, max_steps, delta, message) {
        setTkProgressBar(pb, value = step)
      },
        
      done = function(step, max_steps, delta, message) {
        close(pb)
      }
    )
  })
  
  progression_handler("tkprogressbar", reporter, times = times, interval = interval)
}



#' Visual Progression Feedback
#'
#' @export
progress_handler <- function(..., clear = FALSE, show_after = 0, enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0)) {
  if (!enable) times <- 0
  
  reporter <- local({
    ## Import functions
    progress_bar <- progress::progress_bar

    pb <- NULL
    
    list(
      setup = function(step, max_steps, delta, message) {
        pb <<- progress_bar$new(total = max_steps,
                                clear = clear, show_after = show_after, ...)
        pb$tick(0)
      },
        
      update = function(step, max_steps, delta, message) {
        if (delta > 0) pb$tick(delta)
      },
        
      done = function(step, max_steps, delta, message) {
        if (delta > 0) pb$tick(delta)
      }
    )
  })

  progression_handler("progress", reporter, times = times, interval = interval)
}



#' Auditory Progression Feedback
#'
#' @export
beepr_handler <- function(setup_sound = 2L, update_sound = 10L,  done_sound = 11L, enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0.5), ...) {
  if (!enable) times <- 0

  ## Reporter state
  reporter <- local({
    ## Import functions
    beep <- beepr::beep

    list(
      setup = function(step, max_steps, delta, message) {
        beep(setup_sound)
      },
        
      update = function(step, max_steps, delta, message) {
        beep(update_sound)
      },
        
      done = function(step, max_steps, delta, message) {
        beep(done_sound)
      }
    )
  })
  
  progression_handler("beepr", reporter, times = times, interval = interval)
}



#' Operating-System Specific Progression Feedback
#'
#' @export
notifier_handler <- function(setup = 2L, update = 10L,  done = 11L, enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 5), ...) {
  if (!enable) times <- 0
  
  reporter <- local({
    notify_ideally <- function(step, max_steps, message, p) {
      msg <- paste(c("", message), collapse = "")
      ratio <- if (step == 0L) "STARTED" else if (step == max_steps) "DONE" else sprintf("%.0f%%", 100*step/max_steps)
      notifier::notify(sprintf("[%s] %s (at %s)", ratio, msg, p$time))
    }

    notify <- function(step, max_steps, message) {
      msg <- paste(c("", message), collapse = "")
      ratio <- if (step == 0L) "STARTED" else if (step == max_steps) "DONE" else sprintf("%.1f%%", 100*step/max_steps)
      notifier::notify(sprintf("[%s] %s (Step %d of %d)", ratio, msg, step, max_steps))
    }

    list(
      setup = function(step, max_steps, delta, message) {
        notify(step = step, max_steps = max_steps, message = message)
      },
        
      update = function(step, max_steps, delta, message) {
        notify(step = step, max_steps = max_steps, message = message)
      },
        
      done = function(step, max_steps, delta, message) {
        notify(step = step, max_steps = max_steps, message = message)
      }
    )
  })
  
  progression_handler("notifier", reporter, times = times, interval = interval)
}
