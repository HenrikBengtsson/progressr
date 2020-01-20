#' Textual Progression Feedback for Debug Purposes
#'
#' @inheritParams make_progression_handler
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/debug_handler.R
#'
#' @export
debug_handler <- function(interval = getOption("progressr.interval", 0), intrusiveness = getOption("progressr.intrusiveness.debug", 0), target = "terminal", ...) {
  reporter <- local({
    t_init <- NULL
    
    add_to_log <- function(config, state, progression, ...) {
      t <- Sys.time()
      if (is.null(t_init)) t_init <<- t
      dt <- difftime(t, t_init, units = "secs")
      delay <- difftime(t, progression$time, units = "secs")
      message <- paste(c(state$message, ""), collapse = "")
      entry <- list(now(t), dt, delay, progression$type, state$step, config$max_steps, state$delta, message, config$clear, state$enabled, paste0(progression$status, ""))
      msg <- do.call(sprintf, args = c(list("%s(%.3fs => +%.3fs) %s: %d/%d (%+d) '%s' {clear=%s, enabled=%s, status=%s}"), entry))
      message(msg)
    }

    list(
      reset = function(...) {
        t_init <<- NULL
      },
      
      initiate = function(...) {
        add_to_log("initiate", ...)
      },
        
      update = function(...) {
        add_to_log("update", ...)
      },
        
      finish = function(...) {
        add_to_log("finish", ...)
      }
    )
  })
  
  make_progression_handler("debug", reporter, intrusiveness = intrusiveness, ...)
}
