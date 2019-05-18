#' Inject Progress Updates to an R Expression
#'
#' @param expr An \R expression.
#'
#' @param substitute If TRUE, argument `expr` is [base::substitute()]:ed.
#'
#' @example incl/add_progress.R
#'
#' @export
add_progress <- function(expr, substitute = TRUE) {
  if (substitute) expr <- substitute(expr)

  if (length(expr) == 1L) expr <- bquote({ .(expr) })
  
  idxs <- seq(from = 2L, to = length(expr))
  max_steps <- length(idxs)
  labels <- as.character(expr[idxs])
  
  idxs2 <- rep(idxs, each = 2L)
  idxs2 <- idxs2 + c(NA_integer_, 0L)
  idxs2 <- c(1L, 1L, idxs2, 1L)
  expr2 <- expr[idxs2]
  
  idxs3 <- which(is.na(idxs2))
  for (kk in seq_along(idxs3)) {
    idx <- idxs3[kk]
    label <- labels[[kk]]
    expr2[[idx]] <- substitute(progress(message = s), list(s = label))
  }
  
  expr2[[2L]] <- bquote(progress <- progressr::progression(.(max_steps)))
  expr2[[length(expr2)]] <- quote(progress())

  class(expr2) <- c("progressr_expression", class(expr2))
  
  expr2
}

