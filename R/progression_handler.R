#' @export
progression_handler <- function(name, handler) {
  name <- as.character(name)
  stop_if_not(length(name) == 1L, !is.na(name), nzchar(name))
  stop_if_not(is.function(handler))
  formals <- formals(handler)
  stop_if_not(length(formals) == 1L)

  class(handler) <- c(sprintf("%s_progression_handler", name),
                      "progression_handler", class(handler))

  handler
}
