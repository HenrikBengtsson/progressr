#' Use Progressr in Shiny Apps: Plug-in Backward Compatibility Replacement for shiny::withProgress()
#'
#' @inheritParams handler_shiny
#'
#' @param expr,\ldots,env,quoted Arguments passed to [shiny::withProgress] as is.
#'
#' @param message,detail (character string) The message and the detail message to be passed to [shiny::withProgress()].
#' 
#' @param handlers Zero or more progression handlers used to report on progress.
#'
#' @return The value of [shiny::withProgress].
#'
#' @example incl/withProgressShiny.R
#'
#' @section Requirements:
#' This function requires the \pkg{shiny} package and will use the
#' [handler_shiny()] **progressr** handler internally to report on updates.
#'
#' @export
withProgressShiny <- function(expr, ..., message = NULL, detail = NULL, inputs = list(message = NULL, detail = "message"), env = parent.frame(), quoted = FALSE, handlers = c(shiny = handler_shiny, progressr::handlers(default = NULL))) {
  if (!quoted) expr <- substitute(expr)

  stop_if_not(is.list(inputs), all(names(inputs) %in% c("message", "detail")))

  stop_if_not("shiny" %in% names(handlers))
  if (sum(names(handlers) == "shiny") > 1) {
    warning("Detected a 'shiny' handler set via progressr::handlers()")
  }

  ## Optional, configure 'inputs' from attribute 'input' of arguments
  ## 'message' and 'detail', if and only if that attribute is available.
  args <- list(message = message, detail = detail)
  for (name in names(args)) {
    input <- unique(attr(args[[name]], "input"))
    if (is.null(input)) next
    unknown <- setdiff(input, c("message", "sticky_message", "non_sticky_message"))
    if (length(unknown) > 0) {
      stop(sprintf("Unknown value of attribute %s on argument %s: %s",
           sQuote("input"), sQuote(name), commaq(unknown)))
    }
    inputs[[name]] <- input
  }

  stop_if_not(
    is.list(inputs),
    !is.null(names(inputs)),
    all(names(inputs) %in% c("message", "detail")),
    all(vapply(inputs, FUN = function(x) {
      if (is.null(x)) return(TRUE)
      if (!is.character(x)) return(FALSE)
      x %in% c("message", "non_sticky_message", "sticky_message")
    }, FUN.VALUE = FALSE))
  )

  ## Customize the shiny 'message' target?
  if (is.function(handlers$shiny) &&
      !inherits(handlers$shiny, "progression_handler")) {
    tweaked_handler_shiny <- handlers$shiny
    if (!identical(inputs, formals(tweaked_handler_shiny)$inputs)) {
      formals(tweaked_handler_shiny)$inputs <- inputs
      handlers$shiny <- tweaked_handler_shiny
    }
  }
  
  expr <- bquote(progressr::with_progress({.(expr)}, handlers = .(handlers)))
  res <- withVisible(shiny::withProgress(expr, ..., message = message, detail = detail, env = env, quoted = TRUE))
  if (res$visible) res$value else invisible(res$value)
}
