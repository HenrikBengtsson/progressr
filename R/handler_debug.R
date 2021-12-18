#' Progression Handler: Progress Reported as Debug Information (Text) in the Terminal
#'
#' @inheritParams make_progression_handler
#'
#' @param uuid If TRUE, then the progressor UUID and the owner UUID are shown,
#' otherwise not (default).
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/handler_debug.R
#'
#' @section Appearance:
#' Below is how this progress handler renders by default at 0%, 30% and 99%
#' progress:
#' 
#' With `handlers(handler_debug())`:
#' ```r
#' [21:27:11.236] (0.000s => +0.001s) initiate: 0/100 (+0) '' {clear=TRUE, enabled=TRUE, status=}
#' [21:27:11.237] (0.001s => +0.000s) update: 0/100 (+0) 'Starting' {clear=TRUE, enabled=TRUE, status=}
#' [21:27:14.240] (3.004s => +0.002s) update: 30/100 (+30) 'Importing' {clear=TRUE, enabled=TRUE, status=}
#' [21:27:16.245] (5.009s => +0.001s) update: 100/100 (+70) 'Summarizing' {clear=TRUE, enabled=TRUE, status=}
#' [21:27:16.246] (5.010s => +0.003s) update: 100/100 (+0) 'Summarizing' {clear=TRIE, enabled=TRUE, status=}
#' ```
#' @export
handler_debug <- function(interval = getOption("progressr.interval", 0), intrusiveness = getOption("progressr.intrusiveness.debug", 0), target = "terminal", uuid = FALSE, ...) {
  reporter <- local({
    t_init <- NULL
    
    add_to_log <- function(config, state, progression, ...) {
      t <- Sys.time()
      if (is.null(t_init)) t_init <<- t
      dt <- difftime(t, t_init, units = "secs")
      delay <- difftime(t, progression$time, units = "secs")
      message <- paste(c(state$message, ""), collapse = "")
      entry <- list(now(t), dt, delay, progression$type, state$step, config$max_steps, state$delta, message, config$clear, state$enabled, paste0(progression$status, ""))
      
      msg <- do.call(sprintf, args = c(list("%s(%.3fs => +%.3fs) %s: %.0f/%.0f (%+g) '%s' {clear=%s, enabled=%s, status=%s}"), entry))
      if (uuid) {
        msg <- sprintf("%s [progressor=%s, owner=%s]", msg, progression$progressor_uuid, progression$owner_session_uuid)
      }
      message(msg)
    }

    list(
      reset = function(...) {
        t_init <<- NULL
      },

      hide = function(...) NULL,
      
      unhide = function(...) NULL,

      interrupt = function(...) NULL,

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
  
  make_progression_handler("debug", reporter, interval = interval, intrusiveness = intrusiveness, target = target, ...)
}
