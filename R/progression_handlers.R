#' Auditory Progression Feedback
#'
#' @export
ascii_alert_handler <- function(symbol = "\a", ..., enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0.5), file = stderr()) {
  if (!enable) times <- 0

  reporter <- env({
    update <- function(delta) {
      cat(file = file, symbol)
    }
  })

  progression_handler("ascii_alert", reporter, times = times, interval = interval)
}



#' Visual Progression Feedback
#'
#' @export
txtprogressbar_handler <- function(..., enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0), file = stderr()) {
  if (!enable) times <- 0
  
  reporter <- env({
    ## Import functions
    txtProgressBar <- utils::txtProgressBar
    getTxtProgressBar <- utils::getTxtProgressBar
    setTxtProgressBar <- utils::setTxtProgressBar

    ## To please R CMD check
    max_steps <- step <- NULL
    
    pb <- NULL
    
    setup <- function() {
      pb <<- txtProgressBar(max = max_steps, ..., file = file)
    }
      
    update <- function(delta) {
      setTxtProgressBar(pb, value = step)
    }
      
    done <- function(delta) {
      close(pb)
    }
  })
  
  progression_handler("txtprogressbar", reporter, times = times, interval = interval)
}



#' Visual Progression Feedback
#'
#' @export
tkprogressbar_handler <- function(..., enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0)) {
  if (!enable) times <- 0

  reporter <- env({
    ## Import functions
    tkProgressBar <- tcltk::tkProgressBar
    getTkProgressBar <- tcltk::getTkProgressBar
    setTkProgressBar <- tcltk::setTkProgressBar

    ## To please R CMD check
    max_steps <- step <- NULL
    
    pb <- NULL
    
    setup <- function() {
      pb <<- tkProgressBar(max = max_steps, ...)
    }
      
    update <- function(delta) {
      setTkProgressBar(pb, value = step)
    }
      
    done <- function(delta) {
      close(pb)
    }
  })
  
  progression_handler("tkprogressbar", reporter, times = times, interval = interval)
}



#' Visual Progression Feedback
#'
#' @export
progress_handler <- function(..., clear = FALSE, show_after = 0, enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0)) {
  if (!enable) times <- 0
  
  reporter <- env({
    ## Import functions
    progress_bar <- progress::progress_bar

    ## To please R CMD check
    max_steps <- NULL
    
    pb <- NULL
    
    setup <- function() {
      pb <<- progress_bar$new(total = max_steps,
                              clear = clear, show_after = show_after, ...)
      pb$tick(0)
    }
      
    update <- function(delta) {
      if (delta > 0) pb$tick(delta)
    }
      
    done <- function(delta) {
      if (delta > 0) pb$tick(delta)
    }
  })

  progression_handler("progress", reporter, times = times, interval = interval)
}



#' Auditory Progression Feedback
#'
#' @export
beepr_handler <- function(setup_sound = 2L, update_sound = 10L,  done_sound = 11L, enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 0.5), ...) {
  if (!enable) times <- 0

  ## Reporter state
  reporter <- env({
    ## Import functions
    beep <- beepr::beep
  
    setup <- function() {
      beep(setup_sound)
    }
      
    update <- function(delta) {
      beep(update_sound)
    }
      
    done <- function(delta) {
      beep(done_sound)
    }
  })
  
  progression_handler("beepr", reporter, times = times, interval = interval)
}



#' Operating-System Specific Progression Feedback
#'
#' @export
notifier_handler <- function(setup = 2L, update = 10L,  done = 11L, enable = interactive(), times = getOption("progressr.times", +Inf), interval = getOption("progressr.interval", 5), ...) {
  if (!enable) times <- 0
  
  reporter <- env({
    ## To please R CMD check
    max_steps <- step <- NULL
    
    notify_ideally <- function(p) {
      msg <- paste(c("", p$message), collapse = "")
      ratio <- switch(p$type, setup = "STARTED", done = "DONE", sprintf("%.0f%%", 100*step/max))
      notifier::notify(sprintf("[%s] %s (at %s)", ratio, msg, p$time))
    }

    notify <- function(step) {
      notifier::notify(sprintf("[%.1f%%] Step %d of %d", 100*step/max_steps, step, max_steps))
    }

    setup <- function() {
      notify(step)
    }
      
    update <- function(delta) {
      notify(step)
    }
      
    done <- function(delta) {
      notify(step)
    }
  })
  
  progression_handler("notifier", reporter, times = times, interval = interval)
}
