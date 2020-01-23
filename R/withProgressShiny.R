#' Use Progressr in Shiny Apps: Plug-in Backward Compatibility Replacement for shiny::withProgress()
#'
#' @param expr,\ldots,env,quoted Arguments passed to [shiny::withProgress] as is.
#'
#' @param handlers Zero or more progression handlers used to report on progress.
#'
#' @return The value of [shiny::withProgress].
#'
#' @example incl/withProgressShiny.R
#'
#' @section Requirements:
#' This function requires the \pkg{shiny} package.
#'
#' @export
withProgressShiny <- function(expr, ..., env = parent.frame(), quoted = FALSE, handlers = c(shiny = handler_shiny, progressr::handlers(default = NULL))) {
  if (!quoted) expr <- substitute(expr)
  expr <- bquote(progressr::with_progress({.(expr)}, handlers = .(handlers)))
  res <- withVisible(shiny::withProgress(expr, ..., env = env, quoted = TRUE))
  if (res$visible) res$value else invisible(res$value)
}
