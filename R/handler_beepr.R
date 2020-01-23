#' Progression Handler: Progress Reported as 'beepr' Sounds (Audio)
#'
#' A progression handler for [beepr::beep()].
#'
#' @inheritParams make_progression_handler
#'
#' @param initiate,update,finish (integer) Indices of [beepr::beep()] sounds to
#'  play when progress starts, is updated, and completes.  For silence, use `NA_integer_`.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @example incl/handler_beepr.R
#'
#' @section Requirements:
#' This progression handler requires the \pkg{beepr} package.
#'
#' @export
handler_beepr <- function(initiate = 2L, update = 10L,  finish = 11L, intrusiveness = getOption("progressr.intrusiveness.auditory", 5.0), target = "audio", ...) {
  ## Used for package testing purposes only when we want to perform
  ## everything except the last part where the backend is called
  if (!is_fake("handler_beepr")) {
    beepr_beep <- beepr::beep
  } else {
    beepr_beep <- function(sound, expr) NULL
  }

  beep <- function(sound) {
    ## Silence?
    if (is.na(sound)) return()
    beepr_beep(sound)
  }

  ## Reporter state
  reporter <- local({
    list(
      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
	beep(initiate)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || progression$amount == 0 || config$times <= 2L) return()
        beep(update)
      },
        
      finish = function(config, state, progression, ...) {
        if (!state$enabled) return()
        beep(finish)
      }
    )
  })
  
  make_progression_handler("beepr", reporter, intrusiveness = intrusiveness, ...)
}
