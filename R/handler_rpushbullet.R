#' Progression Handler: Progress Reported via the Pushbullet Messaging Service
#'
#' A progression handler for `pbPost()` of the \pkg{RPushbullet} package.
#'
#' @inheritParams make_progression_handler
#' @inheritParams RPushbullet::pbPost
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/handler_rpushbullet.R
#'
#' @section Requirements:
#' This progression handler requires the \pkg{RPushbullet} package, a
#' Pushbullet account, and configuration according to the instructions
#' of the \pkg{RPushbullet} package.  It also requires internet access
#' from the computer where this progress handler is registered.
#'
#' @keywords internal
#' @export
handler_rpushbullet <- function(intrusiveness = getOption("progressr.intrusiveness.rpushbullet", 5), target = "gui", ..., title = "Progress update from R", recipients = NULL, email = NULL, channel = NULL, apikey = NULL, device = NULL) {
  ## Used for package testing purposes only when we want to perform
  ## everything except the last part where the backend is called
  if (!is_fake("handler_rpushbullet")) {
    pkg <- "RPushbullet"
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop("Package RPushbullet is not available")
    }
    pbPost <- get("pbPost", mode = "function", envir = getNamespace(pkg))
  } else {
    pbPost <- function(...) NULL
  }

  notify <- function(step, max_steps, message) {
    ratio <- if (max_steps == 0) 1 else step / max_steps
    ratio <- sprintf("%.0f%%", 100*ratio)
    msg <- paste(c("", message), collapse = "")
    args <- list(
      type = "note",
      title = title,
      body = sprintf("[%s] %s", ratio, msg)
    )
    if (!is.null(recipients)) args$recipients <- recipients
    if (!is.null(email)) args$email <- email
    if (!is.null(channel)) args$channel <- channel
    if (!is.null(apikey)) args$apikey <- apikey
    if (!is.null(device)) args$device <- device
    
    pbPost(
      type = "note",
      title = title,
      body = sprintf("[%s] %s", ratio, msg)
    )
  }

  reporter <- local({
    finished <- FALSE
    
    list(
      reset = function(...) {
        finished <<- FALSE
      },
      
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        notify(step = state$step, max_steps = config$max_steps, message = state$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || progression$amount == 0 || config$times <= 2L) return()
        notify(step = state$step, max_steps = config$max_steps, message = state$message)
      },
        
      finish = function(config, state, progression, ...) {
        if (finished) return()
        if (!state$enabled) return()
        if (state$delta > 0) notify(step = state$step, max_steps = config$max_steps, message = state$message)
	finished <<- TRUE
      }
    )
  })
  
  make_progression_handler("rpushbullet", reporter, intrusiveness = intrusiveness, target = target, ...)
}
