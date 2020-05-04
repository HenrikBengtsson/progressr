#' Progression Handler: No Progress Report
#'
#' @inheritParams make_progression_handler
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @examples
#' \donttest{\dontrun{
#' handlers(handler_void())
#' with_progress(y <- slow_sum(1:100))
#' print(y)
#' }}
#'
#' @details
#' This progression handler gives not output - it is invisible and silent.
#'
#' @export
handler_void <- function(intrusiveness = 0, target = "void", enable = FALSE, ...) {
  reporter <- local({
    list(
      initiate = function(config, state, progression, ...) NULL,
      update = function(config, state, progression, ...) NULL,
      finish = function(config, state, progression, ...) NULL
    )
  })
  
  make_progression_handler("void", reporter, intrusiveness = intrusiveness, target = target, enable = enable, ...)
}
